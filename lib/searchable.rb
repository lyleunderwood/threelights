module Searchable
  extend ActiveSupport::Concern

  included do
    include ::Elasticsearch::Model
    include ::Elasticsearch::Model::Callbacks

    index_name [Rails.application.engine_name, Rails.env].join('_')
  end
end
