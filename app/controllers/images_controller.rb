require 'open-uri'

class ImagesController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :create, :edit, :update, :destroy]

  # GET /images
  # GET /images.xml
  def index
    @images = Image.page(0).per(20)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @images }
      format.rss  { render :layout => nil, :content_type => 'application/xml' }
    end
  end

  # GET /images/1
  # GET /images/1.xml
  def show
    @image = Image.find_by_slug(params[:id])
    @images = image_range(@image)

    @image.viewed!

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @image }
    end
  end

  # GET /images/full/slug
  def full
    @image = Image.find_by_slug(params[:id])

    respond_to do |format|
      format.html { render :full, :layout => false } # full.html.erb
      format.xml  { render :xml => @image }
    end
  end

  # GET /albums/userpics/10001/sailorstarspb_47.jpg
  def proxy
    if params[:src] =~ /^thumb_/
      type= 'thumb'
      src = params[:src].sub /^thumb_/, ''
    elsif params[:src] =~ /^normal_/
      type= 'view'
      src = params[:src].sub /^normal_/, ''
    else
      type = 'original'
      src = params[:src]
    end

    @image = Image.find_by_subject_file_name(src)

    #file = open(@image.subject.url(:original))

    #send_data file, :type => file.content_type, :disposition => 'inline'
    redirect_to @image.subject.url(type.to_sym), :status => :moved_permanently
  end

  # GET /images/new
  # GET /images/new.xml
  def new
    @image = Image.new
    @image.album = Album.find_by_slug(params[:album_id])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @image }
    end
  end

  # GET /images/1/edit
  def edit
    @image = Image.find_by_slug(params[:id])
  end

  # POST /images
  # POST /images.xml
  def create
    @image = Image.new(params[:image])

    respond_to do |format|
      if @image.save
        format.html { redirect_to([@image.album.category, @image.album, @image], :notice => 'Image was successfully created.') }
        format.xml  { render :xml => @image, :status => :created, :location => @image }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @image.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /images/1
  # PUT /images/1.xml
  def update
    @image = Image.find_by_slug(params[:id])

    respond_to do |format|
      if @image.update_attributes(params[:image])
        format.html { redirect_to([@image.album.category, @image.album, @image], :notice => 'Image was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @image.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1
  # DELETE /images/1.xml
  def destroy
    @image = Image.find_by_slug(params[:id])
    @image.destroy

    respond_to do |format|
      format.html { redirect_to([@image.album.category, @image.album]) }
      format.xml  { head :ok }
    end
  end

  private

  def image_range(target_image)
    images = target_image.album.images.order(:subject_file_name)
    index = images.index {|image| image == target_image}
    return [] unless index

    range_start = index - 2
    range_start = 0 if range_start < 0
    range_end = range_start + 5
    range_end = images.count - 1 if range_end >= images.count

    p range_start, range_end
    images[Range.new(range_start, range_end, true)]
  end
end
