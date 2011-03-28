class AlbumsController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :create, :edit, :update, :destroy]

  # GET /albums
  # GET /albums.xml
  def index
    @albums = Album.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @albums }
    end
  end

  # GET /albums/1
  # GET /albums/1.xml
  def show
    @album = Album.find_by_slug(params[:id])
    @images = @album.images.page(params[:page]).per(12)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @album }
    end
  end

  # GET /albums/new
  # GET /albums/new.xml
  def new
    @album = Album.new
    @album.category = Category.find_by_slug(params[:category_id])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @album }
    end
  end

  # GET /albums/1/edit
  def edit
    @album = Album.find_by_slug(params[:id])
  end

  # POST /albums
  # POST /albums.xml
  def create
    @album = Album.new(params[:album])

    respond_to do |format|
      if @album.save
        format.html { redirect_to([@album.category, @album], :notice => 'Album was successfully created.') }
        format.xml  { render :xml => @album, :status => :created, :location => @album }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @album.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /albums/1
  # PUT /albums/1.xml
  def update
    @album = Album.find_by_slug(params[:id])

    respond_to do |format|
      if @album.update_attributes(params[:album])
        format.html { redirect_to([@album.category, @album], :notice => 'Album was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @album.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /albums/1
  # DELETE /albums/1.xml
  def destroy
    @album = Album.find_by_slug(params[:id])
    @album.destroy

    respond_to do |format|
      format.html { redirect_to(@album.category) }
      format.xml  { head :ok }
    end
  end
end
