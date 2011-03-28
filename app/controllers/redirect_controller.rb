class RedirectController < ApplicationController
  def category
    @category = Category.where(:legacy_id => params[:cat]).first

    redirect_to @category, :status => :moved_permanently
  end

  def album
    @album = Album.where(:legacy_id => params[:album]).first

    redirect_to [@album.category, @album], :status => :moved_permanently
  end

  def image
    @album = Album.where(:legacy_id => params[:album]).first
    @image = Image.where(:legacy_pos => params[:pos], :album_id => @album.id).first

    redirect_to [@album.category, @album, @image], :status => :moved_permanently
  end

end
