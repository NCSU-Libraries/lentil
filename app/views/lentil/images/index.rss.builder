xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0", "xmlns:media" => "http://search.yahoo.com/mrss/" do
  xml.channel do
    xml.title @title
    xml.description feed_description
    xml.link images_url

    @images.each do |image|
      xml.item do
        xml.title image.description
        xml.author image.user.user_name
        xml.link image_url(image)
        xml.description image_tag(image.jpeg, :alt => image.description)
        xml.media :content, url: image.jpeg, type:"image/jpeg"
        xml.guid image_url(image)
      end
    end
  end
end