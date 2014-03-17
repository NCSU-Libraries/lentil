if defined?(ActiveAdmin)
  ActiveAdmin.register Lentil::Image do
    actions :index, :show

    config.batch_actions = false
    config.per_page = 10

    filter :state, :as => :select, :collection => proc { Lentil::Image::States }
    filter :user_user_name, :as => :string, :label => "Username"
    filter :user_full_name, :as => :string, :label => "Full Name"
    filter :staff_like, :as => :select
    filter :do_not_request_donation, :as => :select
    filter :win_pct
    filter :popular_score, :label => "Score"
    filter :description
    filter :updated_at
    filter :donor_agreement_submitted_date
    filter :file_harvested_date
    filter :tags_name, :as => :string
    filter :url, :label => "Service URL"
    filter :id

    action_item :only => :show do
      link_to('Update Image', update_image_admin_lentil_image_path(lentil_image))
    end
    action_item { link_to "Moderate New", moderate_admin_lentil_images_path }
    action_item { link_to "Moderate Skipped", moderate_skipped_admin_lentil_images_path }
    action_item { link_to "Moderate Flagged", moderate_flagged_admin_lentil_images_path }
    action_item { link_to "Flagging History", flagging_history_admin_lentil_images_path }
    action_item { link_to "Add Instagram Image", manual_input_admin_lentil_images_path }

    index do
      column "Image" do |image|
        link_to(image_tag(image.image_url, :class => "moderation_thumbnail"), admin_lentil_image_path(image))
      end
      column :id
      column :description
      column "User", :user do |i|
        names = []
        names << i.user.user_name
        names << i.user.full_name
        names.join("\n")
      end
      column "All Tags" do |image|
        image.tags.map{|tag| tag.name}.join(' | ')
      end
      column "Likes", :like_votes_count
      column :staff_like
      column "Battles", :battles_count, :sortable => false
      column :win_pct, :sortable => :win_pct do |image|
        if image.win_pct
          number_to_percentage(image.win_pct, :precision => 0)
        else
          "No Battles Fought"
        end
      end
      column "Score", :popular_score
      column :state do |image|
        image.state_name
      end
    end

    show :title => :id do |image|
      attributes_table do
        row :id
        row :description
        row :user
        row :moderator do |image|
          unless image.moderator_id.nil?
            image.moderator.email
          else
            "Image has not been moderated."
          end
        end
        row :created_at
        row :updated_at
        row :like_votes_count
        row :url
        row "All Tags" do |image|
          unless image.tags.empty?
            image.tags.map{|tag| tag.name}.join(' | ')
          else
            "Image has not been tagged."
          end
        end
        row :staff_like
        row :do_not_request_donation
        row :donor_agreement_submitted_date
        row :file_harvested_date
        row :state do
          image.state_name
        end
        row :image do
          link_to(image_tag(image.image_url), admin_lentil_image_path(image))
        end
      end
      active_admin_comments
    end

    controller do
      def update_images(images, images_params, second_moderation)
        images.each do |image|
          image_params = images_params[image.id.to_s]

          incoming_tag_ids = image_params['tag_ids'].reject(&:empty?)
          existing_tag_ids = []
          service_tag_ids = []

          image.taggings.each do |tagging|
            existing_tag_ids << tagging[:tag_id]
            if tagging[:staff_tag] == false
              service_tag_ids << tagging[:tag_id]
            end
          end

          new_tag_ids = incoming_tag_ids - existing_tag_ids
          tag_ids_to_keep = incoming_tag_ids - new_tag_ids + service_tag_ids

          new_taggings = []
          new_tag_ids.each do |id|
            new_taggings << image.taggings.build(:tag_id => id, :staff_tag => true)
          end

          taggings_to_keep = image.taggings.where(:tag_id => tag_ids_to_keep)
          taggings = new_taggings + taggings_to_keep

          image.update_attributes!(:state => image_params['state'], :taggings => taggings, :staff_like => image_params['staff_like'],
            :moderator => current_admin_user, :moderated_at => DateTime.now, :second_moderation => second_moderation, :do_not_request_donation => image_params['do_not_request_donation'])
        end
      end
    end

    member_action :update_image do
      id = params['id']
      @second_moderation = false
      @images = Lentil::Image.where(id: id)
      render "admin/lentil_images/moderate"
    end

    collection_action :moderate do
      @second_moderation = false
      @images = Lentil::Image.where(state: Lentil::Image::States[:pending], moderator_id: nil).paginate(:page => params[:page], :per_page => 10)
    end

    collection_action :moderate_skipped do
      @second_moderation = false
      @images = Lentil::Image.where(state: Lentil::Image::States[:pending]).where("moderator_id IS NOT NULL").paginate(:page => params[:page], :per_page => 10)
      render "/admin/lentil_images/moderate"
    end

    collection_action :moderate_flagged do
      @second_moderation = true
      @images = Lentil::Image.joins(:flags).group("lentil_images.id").having("count(lentil_flags.id) > 0").where(:second_moderation => false).paginate(:page => params[:page], :per_page => 10)
      render "/admin/lentil_images/moderate"
    end

    collection_action :do_moderation, :method => :post do
      images = Lentil::Image.find(params[:image].keys)
      images_params = params[:image]
      second_moderation = params[:moderation]['second_moderation']

      begin
        update_images(images, images_params, second_moderation)
      rescue => e
        message = "Error moderating images: " + e.to_s
        redirect_to :back, :flash => {:error => message}
      else
        number_of_images = params['image'].size
        plural = 'image'.pluralize(number_of_images)
        message = number_of_images.to_s + " " + plural + " moderated."
        redirect_to :back, notice: message
      end
    end

    collection_action :flagging_history do
      @images = Lentil::Image.joins(:flags).group("lentil_images.id").having("count(lentil_flags.id) > 0").paginate(:page => params[:page], :per_page => 10)
    end

    collection_action :manual_input do
      @tags = Lentil::Tag.all
    end

    collection_action :do_manual_input, :method => :post do
      urls = params[:manual_input][:urls].lines.to_a.map(&:chomp).reject {|url| url.length < 1}
      total_urls = urls.size
      image_counter = 0
      errors = []

      urls.each do |raw_url|
        url = URI.parse(raw_url) rescue next
        unless url.kind_of?(URI::HTTP) || url.kind_of?(URI::HTTPS)
          errors << "#{raw_url}: Unable to validate URL"
          next
        end

        harvester = Lentil::InstagramHarvester.new
        begin
          image = harvester.save_image_from_url(url.to_s)
        rescue Exception => e
          errors << "#{raw_url}: #{e.message}"
          next
        end

        image_counter += image.length

        if image.length < 1
          errors << "#{raw_url}: Unknown error (possible duplicate)"
        end
      end

      redirect_to :back, notice: "#{image_counter} #{'URL'.pluralize(image_counter)} added (out of #{total_urls})", alert: errors.join('<br>').html_safe
    end
  end
end