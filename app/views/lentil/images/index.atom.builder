atom_feed do |feed|
  feed.title @title
  feed.description feed_description
  feed.link images_url

  @images.each do |image|
    feed.entry(image) do |entry|
      entry.title image.description
      entry.author image.user.user_name
      entry.link image_url(image)
      entry.description image_tag(image.jpeg, :alt => image.description)
      entry.media :content, url: image.jpeg, type:"image/jpeg"
      entry.guid image_url(image)
    end
  end
end