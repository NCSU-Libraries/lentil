if defined?(ActiveAdmin)
  ActiveAdmin.register Lentil::Flag do
    actions :index

    filter :image, :as => :select, :collection => proc { Lentil::Image.joins(:flags).group("lentil_images.id").having("count(lentil_flags.id) > 0").map(&:id) }

    config.batch_actions = false

    index do
      column "Image" do |flag|
        link_to(image_tag(flag.image.image_url, :class => "moderation_thumbnail"), admin_lentil_image_path(flag.image),)
      end
      column :created_at
      column :updated_at
    end
  end
end
