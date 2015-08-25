if defined?(ActiveAdmin)
  ActiveAdmin.register Lentil::Image do
    actions :index, :show

    config.batch_actions = true
    config.per_page = 10

    batch_action :destroy, false

    batch_action :approve_all do |ids|
      images = Lentil::Image.where(id: ids)
      total_images = images.size
      image_counter = 0
      errors = []

      images.each do |image|
        second_moderation = true
        unless image.moderator_id.nil?
          second_moderation = false
        end

        begin
          image.update_attributes!(:state => 1, :moderator => current_admin_user, :moderated_at => DateTime.now,
            :second_moderation => second_moderation)
        rescue Exception => e
          errors << "image_id #{image.id}: #{e.message}"
          next
        end

        image_counter += 1
      end

      if errors.length > 0
        redirect_to collection_path, notice: "#{image_counter} #{'Image'.pluralize(image_counter)} approved (out of #{total_images})", alert: errors.join('<br>').html_safe
      else
        redirect_to collection_path, notice: "#{image_counter} #{'Image'.pluralize(image_counter)} approved (out of #{total_images})"
      end
    end

    filter :suppressed
    filter :media_type, :as => :select
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

    scope :all
    scope :new, :default => true do |images|
      images.where(:state => Lentil::Image::States[:pending])
    end
    scope :approved do |images|
      images.where(:state => Lentil::Image::States[:approved])
    end
    scope :rejected do |images|
      images.where(:state => Lentil::Image::States[:rejected])
    end
    scope :skipped do |images|
      images.where(:state => Lentil::Image::States[:pending]).where("moderator_id IS NOT NULL")
    end
    # scope :flagged do |images|
    #   # images.where(:state => Lentil::Image::States[:pending]).where("moderator_id IS NOT NULL")
    #   images.includes(:user, :tags, :taggings, :flags).joins(:flags).where(:second_moderation => false).uniq.all
    # end

    action_item :only => :show do
      link_to('Update Image', update_image_admin_lentil_image_path(lentil_image))
    end
    action_item { link_to "Moderate New", moderate_admin_lentil_images_path }
    action_item { link_to "Moderate Skipped", moderate_skipped_admin_lentil_images_path }
    action_item { link_to "Moderate Flagged", moderate_flagged_admin_lentil_images_path }
    action_item { link_to "Moderate Approved", moderate_approved_admin_lentil_images_path }
    action_item { link_to "Moderate Rejected", moderate_rejected_admin_lentil_images_path }
    action_item { link_to "Flagging History", flagging_history_admin_lentil_images_path }
    action_item { link_to "Add Instagram Image", manual_input_admin_lentil_images_path }

    index do
      harvestable_tag_ids = Lentil::Tag.harvestable.map(&:id)
      if current_scope.name == 'New'
        selectable_column
      end
      column "Image" do |image|
        unless image.media_type == "video"
            link_to(image_tag(image.image_url, :class => "moderation_thumbnail"), admin_lentil_image_path(image))
        else
            link_to(video_tag(image.video_url, controls: true, size: "250x250"),  admin_lentil_image_path(image))
        end
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
      column "Harvesting Tags" do |image|
        image.service_tags.select{|tag| harvestable_tag_ids.include? tag.id}.map{|tag| tag.name}.join(' | ')
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
      column :suppressed
      column :state do |image|
        image.state_name
      end
    end

    show :title => :id do |image|
      harvestable_tag_ids = Lentil::Tag.harvestable.map(&:id)
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
        row "Harvesting Tags" do |image|
          unless image.service_tags.select{|tag| harvestable_tag_ids.include? tag.id}.empty?
            image.service_tags.select{|tag| harvestable_tag_ids.include? tag.id}.map{|tag| tag.name}.join(' | ')
          else
            "Image has no harvesting tags."
          end
        end
        row :staff_like
        row :do_not_request_donation
        row :donor_agreement_submitted_date
        row :file_harvested_date
        row :suppressed
        row :state do
          image.state_name
        end
        row :image do
      unless image.media_type == "video"
        link_to(image_tag(image.image_url), admin_lentil_image_path(image))
      else
        video_tag(image.video_url, controls: true, size: "640x640")
      end
        end
      end
      active_admin_comments
    end

    controller do
      def scoped_collection
        super.includes :user, :taggings, :tags
      end

      # TODO: This method may need optimization
      def update_images(images, images_params, second_moderation)
        total_images = images.size
        image_counter = 0
        errors = []

        images.each do |image|
          image_params = images_params[image.id.to_s]

          if image_params.key?(:tag_ids)
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

            taggings_to_keep = image.taggings.select{ |tagging| tag_ids_to_keep.include? tagging.tag_id}
            taggings = new_taggings + taggings_to_keep

            # Save Updated Image with new tags
            begin
              image.update_attributes!(:state => image_params['state'], :taggings => taggings, :staff_like => image_params['staff_like'],
              :moderator => current_admin_user, :moderated_at => DateTime.now, :second_moderation => second_moderation,
              :do_not_request_donation => image_params['do_not_request_donation'], :suppressed => image_params['suppressed'])
            rescue Exception => e
              errors << "image_id #{image.id}: #{e.message}"
              next
            end
          else
            # Save Updated Image with same tags
            begin
              image.update_attributes!(:state => image_params['state'], :staff_like => image_params['staff_like'],
              :moderator => current_admin_user, :moderated_at => DateTime.now, :second_moderation => second_moderation,
              :do_not_request_donation => image_params['do_not_request_donation'], :suppressed => image_params['suppressed'])
            rescue Exception => e
              errors << "image_id #{image.id}: #{e.message}"
              next
            end
          end

          image_counter += 1
        end

        if errors.length > 0
          redirect_to :back, notice: "#{image_counter} #{'Image'.pluralize(image_counter)} moderated (out of #{total_images})", alert: errors.join('<br>').html_safe
        else
          redirect_to :back, notice: "#{image_counter} #{'Image'.pluralize(image_counter)} moderated (out of #{total_images})"
        end
      end
    end

    member_action :update_image do
      @tags = Lentil::Tag.all
      @harvestable_tag_ids = Lentil::Tag.harvestable.map(&:id)
      id = params['id']
      @second_moderation = false
      @images = Lentil::Image.where(id: id)
      render "admin/lentil_images/moderate"
    end

    collection_action :moderate do
      @harvestable_tag_ids = Lentil::Tag.harvestable.map(&:id)
      @second_moderation = false
      @images = Lentil::Image.includes(:user, :taggings, :tags).where(state: Lentil::Image::States[:pending], moderator_id: nil).paginate(:page => params[:page], :per_page => 10)
    end

    collection_action :moderate_approved do
      @harvestable_tag_ids = Lentil::Tag.harvestable.map(&:id)
      @second_moderation = false
      @images = Lentil::Image.includes(:user, :taggings, :tags).where(state: Lentil::Image::States[:approved]).paginate(:page => params[:page], :per_page => 10)
      render "/admin/lentil_images/moderate"
    end

    collection_action :moderate_rejected do
      @harvestable_tag_ids = Lentil::Tag.harvestable.map(&:id)
      @second_moderation = false
      @images = Lentil::Image.includes(:user, :taggings, :tags).where(state: Lentil::Image::States[:rejected]).paginate(:page => params[:page], :per_page => 10)
      render "/admin/lentil_images/moderate"
    end

    collection_action :moderate_skipped do
      @harvestable_tag_ids = Lentil::Tag.harvestable.map(&:id)
      @second_moderation = false
      @images = Lentil::Image.includes(:user, :taggings, :tags).where(state: Lentil::Image::States[:pending]).where("moderator_id IS NOT NULL").paginate(:page => params[:page], :per_page => 10)
      render "/admin/lentil_images/moderate"
    end

    collection_action :moderate_flagged do
      @harvestable_tag_ids = Lentil::Tag.harvestable.map(&:id)
      @second_moderation = true
      temp_images = Lentil::Image.includes(:user, :tags, :taggings, :flags).joins(:flags).where(:second_moderation => false).uniq.all
      @images = Kaminari.paginate_array(temp_images).page(params[:page]).per(10)
      render "/admin/lentil_images/moderate"
    end

    collection_action :do_moderation, :method => :post do
      images = Lentil::Image.find(params[:image].keys, :include => [:user, :taggings, :tags])
      images_params = params[:image]
      second_moderation = params[:moderation]['second_moderation']
      update_images(images, images_params, second_moderation)
    end

    collection_action :flagging_history do
      @harvestable_tag_ids = Lentil::Tag.harvestable.map(&:id)
      temp_images = Lentil::Image.includes(:user, :tags, :flags, :moderator).joins(:flags).uniq.all
      @images = Kaminari.paginate_array(temp_images).page(params[:page]).per(10)
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
