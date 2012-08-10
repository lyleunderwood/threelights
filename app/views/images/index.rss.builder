xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Three-Lights.net Gallery - Latest"
    xml.description "Once again the Star of Destiny shines its light on this world."
    xml.link feed_url

    for image in @images
      xml.item do
        xml.title image.name
        xml.description render :partial => 'feed_image.html.erb', :locals => {:image => image}
        xml.pubDate image.created_at.to_s(:rfc822)
        xml.link category_album_image_url(image.album.category, image.album, image)
        xml.guid category_album_image_url(image.album.category, image.album, image)
      end
    end
  end
end