module ActiveAdmin::ViewHelpers
  def action?(action)
    params[:action] == action
  end

  def link_to_large_admin_image(image)
    link_to admin_lentil_image_path(image, :anchor => "show_view_big_image"), :target => "_blank" do
      image_tag image.image_url, :class => "moderation_thumbnail"
    end
  end
end