# i pretty much stole this wholesale from https://github.com/nono/linuxfr.org
# because elasticsearch-model doesn't currently really support searching on
# multiple models at once, and this is pretty much exactly what i needed.
class Search
  include Elasticsearch::Model

  Models = [Category, Album, Image]

  FACET_BY_TYPE = {
    'category' => 'category',
    'album'    => 'album',
    'image'    => 'image'
  }

  INDICES_BOOST = {
  }

  FIELDS_BOOST = [
    "_all",
    "name^5"
  ]

  PER_PAGE = 15

  class MultipleModels < Array
    def client
      Elasticsearch::Model.client
    end

    def ancestors
      []
    end

    def default_per_page
      PER_PAGE
    end
  end

  attr_accessor :query, :page, :type, :value, :start, :order, :tags
  attr_reader :results

  def run
    @tags ||= []

    query = {
      :query => {
        :filtered => ->{
          filtered = {
            :query => {
              :simple_query_string => {
                :query  => @query,
                :fields => FIELDS_BOOST
              }
            }
          }

          filters = []
          filters << {
            :range => {
              :created_at => { :gte => @start, :lte => Date.tomorrow }
            }
          } if @start
          filters << { :term => { facet => @value } } if @value
          @tags.each do |tag|
            filters << { :term => { :tags => tag } }
          end
          filtered[:filter] = { :and => filters } if filters.any?

          filtered
        }.call
      },

      :highlight => {
        :fields => {
          :name => {},
          :description => {}
        }
      },

      :aggs => ->{
        aggs = {}
        aggs[:types] = {
          :terms => {
            :field => "_type",
            :order => { :_count => "desc" }
          }
        } unless @type
        aggs[:facets] = {
          :terms => {
            :field => facet,
            :order => { :_count => "desc" }
          }
        } if facet && !@value
        aggs[:tags] = {
          :terms => {
            :field => "tags",
            :order => { :_count => "desc" },
            :min_doc_count => 2,
          }
        }
        aggs[:periods] = {
          :date_range => {
            :field => "created_at",
            :ranges => available_periods
          }
        } unless @start
        aggs
      }.call,

      :indices_boost => INDICES_BOOST
    }
    query[:sort] = [ { :created_at => :desc } ] if by_date?

    if by_mix?
      query[:query] = {
        :function_score => {
          :query => query[:query],
          :exp => {
            :created_at => {
              :origin => Date.today.to_s,
              :scale  => "1w",
              :decay  => 0.99
            }
          }
        }
      }
    end

    if @type
      klass = @type.camelize.constantize rescue nil
      if Models.include? klass
        response = klass.search query
      end
    end

    if response.nil?
      models  = MultipleModels.new(Models)
      options = {
       :index => models.map { |c| c.index_name },
       :type  => models.map { |c| c.document_type }
      }
      search  = Searching::SearchRequest.new(models, query, options)
      response = Response::Response.new(models, search)
    end

    @response = response.page(@page)

    self
  end

  def available_periods
    [
      { :from => "now-1w/d" },  # last week
      { :from => "now-1M/d" },  # last month
      { :from => "now-1y/d" },  # last year
    ]
  end

  def types
    aggregations.types.buckets
  end

  def facets
    aggregations.facets.buckets
  end

  def tag_buckets
    aggregations.tags.buckets
  end

  def periods
    aggregations.periods.buckets.sort_by {|p| -p.from.to_i }
  end

  def aggregations
    @aggregations ||= Hashie::Mash.new @response.response['aggregations']
  end

  def facet
    @facet ||= FACET_BY_TYPE[@type]
  end

  def total_count
    results.total_count
  end

  def results
    @response.results
  end

  def records
    results.map { |r| r['_type'].classify.constantize.find(r['_id']) }
  end

  def records_and_hits
    recs = records
    arr = []
    recs.each_with_index {|record, i| arr << {record: record, hit: results[i]}}

    arr
  end

  def by_score?
    !by_date? && !by_mix?
  end

  def by_date?
    @order == "date"
  end

  def by_mix?
    @order == "mix"
  end
end
