if defined?(ActiveAdmin)
  ActiveAdmin.register_page "Dashboard" do

    menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

    content :title => proc{ I18n.t("active_admin.dashboard") } do
      # div :class => "blank_slate_container", :id => "dashboard_default_message" do
      #   span :class => "blank_slate" do
      #     span "Welcome to Active Admin. This is the default dashboard page."
      #     small "To add dashboard sections, checkout 'app/admin/dashboards.rb'"
      #   end
      # end
      #
      columns do
        images = Lentil::Image.where(state: Lentil::Image::States[:pending], moderator_id: nil).reverse.first(10)
        column do
          panel "New Images" do
            if images.length > 0
              table_for images.map do |image|
                column("Image") {|image| image_tag(image.image_url, :class => "dash_thumbnail")}
                column("Description") {|image| image.description}
                column("Tags") {|image| image.tags.map{|tag| tag.name}.join(' | ')}
              end
            else
              div :class => "blank_slate_container", :id => "dashboard_default_message" do
                span :class => "blank_slate" do
                  span "No New Images"
                end
              end
            end
          end
        end

        column do
          images = Lentil::Image.joins(:flags).group("lentil_images.id HAVING count(lentil_flags.id) > 0").where(:second_moderation => false).limit(5)
          panel "Recently Flagged", :id => 'recently_flagged' do
            if images.length > 0
              table_for images.map do |image|
                column("Image")  do |image|
                  link_to image_tag(image.image_url, :class => "dash_thumbnail"), admin_lentil_image_path(image)
                end
                column("Description") {|image| image.description}
                column("Tags") {|image| image.tags.map{|tag| tag.name}.join(' | ')}
              end
            else
              div :class => "blank_slate_container", :id => "dashboard_default_message" do
                span :class => "blank_slate" do
                  span "No Recently Flagged Images"
                end
              end
            end
          end

          images = Lentil::Image.order("popular_score DESC").limit(5)
          panel "Top Images" do
            if images.length > 0
              table_for images.map do |image|
                column("Image") {|image| image_tag(image.image_url, :class => "dash_thumbnail")}
                column("ID") {|image| image.id}
                column("Likes") {|image| image.like_votes_count}
                column("Staff Like") {|image| image.staff_like}
                column("Win Pct") {|image| image.win_pct}
                column("Score") {|image| image.popular_score}
              end
            else
              div :class => "blank_slate_container", :id => "dashboard_default_message" do
                span :class => "blank_slate" do
                  span "No Top Images Found"
                end
              end
            end
          end

          users = Lentil::User.order("images_count DESC").limit(5)
          panel "Top Users" do
            if users.length > 0
              table_for users.map do |user|
                column("Username") {|user| user.user_name}
                column("Full Name") {|user| user.full_name}
                column("Service") {|user| user.service.name}
                column("Images Count") {|user| user.images_count}
              end
            else
              div :class => "blank_slate_container", :id => "dashboard_default_message" do
                span :class => "blank_slate" do
                  span "No Users Found"
                end
              end
            end
          end
        end
      end # columns


      # Here is an example of a simple dashboard with columns and panels.
      #
      # columns do
      #   column do
      #     panel "Recent Posts" do
      #       ul do
      #         Post.recent(5).map do |post|
      #           li link_to(post.title, admin_post_path(post))
      #         end
      #       end
      #     end
      #   end

      #   column do
      #     panel "Info" do
      #       para "Welcome to ActiveAdmin."
      #     end
      #   end
      # end
    end # content
  end
end