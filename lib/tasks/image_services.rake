namespace :lentil do
  namespace :image_services do
    namespace :instagram do

      desc "Fetch and import recent images from Instagram that are tagged with the default tag"
      task :fetch_by_tag => :environment do

        begin
          harvester = Lentil::InstagramHarvester.new
          new_image_count = 0
          harvestable_tags = Lentil::Tag.harvestable.collect {|tag| tag.name}
          raise "No tags in harvestable tagsets" if harvestable_tags.empty?

          harvestable_tags.each do |tag|
            instagram_metadata = harvester.fetch_recent_images_by_tag(tag)
            new_image_count += harvester.save_instagram_load(instagram_metadata).size
          end

          puts "#{new_image_count} new images added"
        rescue => e
          Rails.logger.error e.message
          raise e
        end
      end
    end

    desc "Fetch and save image files to the directory specified in the applicaton config"
    task :save_image_files, [:number_of_images, :image_service, :base_directory] => :environment do |t, args|

      args.with_defaults(:number_of_images => 50, :image_service => 'Instagram')

      base_dir = args[:base_directory] || Lentil::Engine::APP_CONFIG["base_image_file_dir"] || nil
      raise "Base directory is required" unless base_dir

      num_to_harvest = args[:number_of_images].to_i

      harvester = Lentil::InstagramHarvester.new

      Lentil::Service.where(:name => args[:image_service]).first.images.where(:file_harvested_date => nil).
        order("file_harvest_failed ASC").limit(num_to_harvest).each do |image|
        begin
          raise "Destination directory does not exist or is not a directory: #{base_dir}" unless File.directory?(base_dir)

          image_file_path = "#{base_dir}/#{image.service.name}"

          if !File.exist?(image_file_path)
            Dir.mkdir(image_file_path)
          else
            raise "Service directory is not a directory: #{image_file_path}" unless File.directory?(image_file_path)
          end
        rescue => e
          Rails.logger.error e.message
          raise e
        end

        begin
          # TODO: Currently expects JPEG
          video_file_path = image_file_path + "/#{image.external_identifier}.mp4"
          image_file_path += "/#{image.external_identifier}.jpg"
          raise "Image file already exists, will not overwrite: #{image_file_path}" if File.exist?(image_file_path)

          image_data = harvester.harvest_image_data(image)
          
          File.open(image_file_path, "wb") do |f|
            f.write image_data
          end

          if image.media_type == "video"
            raise "Video file already exists, will not overwrite: #{video_file_path}" if File.exist?(video_file_path)
            video_data = harvester.harvest_video_data(image)
            File.open(video_file_path, "wb") do |f|
              f.write video_data
            end
          end
          
          image.file_harvested_date = DateTime.now
          image.save
          puts "Harvested image #{image.id}, #{image_file_path}"
        rescue => e
          image.file_harvest_failed += 1
          image.save
          Rails.logger.error e.message
          puts e.message
        end
      end
    end

    desc "Test whether image file can still be retrieved"
    task :test_image_files, [:number_of_images, :image_service] => :environment do |t, args|
      args.with_defaults(:number_of_images => 10, :image_service => 'Instagram')

      num_to_check = args[:number_of_images].to_i
      harvester = Lentil::InstagramHarvester.new

      Lentil::Service.unscoped.where(:name => args[:image_service]).first.images.
        where("(file_last_checked IS NULL) OR (file_last_checked < :day)", {:day => 1.day.ago}).
        where("failed_file_checks < 10").
        order("file_last_checked ASC").limit(num_to_check).each do |image|
          image_check = harvester.test_remote_image(image)

          if image_check
            image.failed_file_checks = 0
          elsif image_check == false
            image.failed_file_checks += 1
          end

          image.file_last_checked = DateTime.now
          image.save
      end
    end

    desc "Submit donor agreement as a comment on a given number of approved images.
          Currently, image must have been in the system for at least a week"
    task :submit_donor_agreements, [:number_of_images, :image_service] => :environment do |t, args|
      args.with_defaults(:number_of_images => 1, :image_service => 'Instagram')
      num_to_harvest = args[:number_of_images].to_i

      donor_agreement = Lentil::Engine::APP_CONFIG["donor_agreement_text"] || nil
      raise "donor_agreement_text must be defined in application config" unless donor_agreement

      harvester = Lentil::InstagramHarvester.new

      # If you are running the test_image_files task regularly,
      # deleted images will eventually be ignored by this task.
      Lentil::Service.where(:name => args[:image_service]).first.images.approved.where("lentil_images.created_at < :week", {:week => 1.week.ago}).
              where(:do_not_request_donation => false).
              where(:donor_agreement_submitted_date => nil).
              where("lentil_images.last_donor_agreement_failure_date < :week OR lentil_images.last_donor_agreement_failure_date IS NULL", {:week => 1.week.ago}).
              order("donor_agreement_failed ASC").
              limit(num_to_harvest).each do |image|

        begin
          harvester.leave_image_comment(image, donor_agreement)
          image.donor_agreement_submitted_date = DateTime.now
          image.save
          puts "Left donor agreement on image #{image.id}"
        rescue => e
          image.donor_agreement_failed += 1
          image.last_donor_agreement_failure_date = DateTime.now
          image.save
          Rails.logger.error e.message
          puts e.message
          raise e
        end
      end
    end
    
    desc "Get video urls from videos previously harvested"
    task :restore_videos, [:image_service] => :environment do |t, args|
      args.with_defaults(:image_service => 'Instagram')

      harvester = Lentil::InstagramHarvester.new

      lentilService = Lentil::Service.unscoped.where(:name => args[:image_service]).first
      numUpdated = 0;
      lentilService.images.unscoped.each do |image|
        #Skip if media type already known i.e. was properly harvested
        next if !image.media_type.blank?
        
        meta = image.original_metadata
        obj = YAML.load(meta)
        type = obj["type"]
        video_url = image.video_url
        if(type == "video")
          video_url = obj["videos"]["standard_resolution"]["url"]
          image.video_url = video_url
          image.media_type = 'video'
          image.save
          numUpdated += 1
        else
          image.media_type = 'image'
          image.save
          numUpdated += 1
        end
      end
      puts numUpdated.to_s + " record(s) updated"
    end
    
    desc "Dump image metadata for archiving"
    task :dump_metadata, [:image_service, :base_directory] => :environment do |t, args|
      args.with_defaults(:image_service => 'Instagram')
      base_dir = args[:base_directory] || Lentil::Engine::APP_CONFIG["base_image_file_dir"] || nil
      raise "Base directory is required" unless base_dir

      lentilService = Lentil::Service.unscoped.where(:name => args[:image_service]).first
      numArchived = 0;
      lentilService.images.unscoped.each do |image|
        begin
          raise "Destination directory does not exist or is not a directory: #{base_dir}" unless File.directory?(base_dir)

          image_file_path = "#{base_dir}/#{image.service.name}"

          if !File.exist?(image_file_path)
            Dir.mkdir(image_file_path)
          else
            raise "Service directory is not a directory: #{image_file_path}" unless File.directory?(image_file_path)
          end
        rescue => e
          Rails.logger.error e.message
          raise e
        end
      
        @jsonobj = JSON.parse(image.to_json)
        @jsonobj.delete("id")
        @jsonobj["tags"] = JSON.parse(image.tags.to_json)
        @jsonobj["licenses"] = JSON.parse(image.licenses.to_json)
        @jsonobj["licenses"].each do |lic|
          lic.delete("id")
        end
        
        @jsonobj["like_votes"] = JSON.parse(image.like_votes.to_json)
        @jsonobj["flags"] = JSON.parse(image.flags.to_json)
        
        @jsonobj["service"] = JSON.parse(image.service.to_json).except("id")
        @jsonobj["user"] = JSON.parse(image.user.to_json).except("id", "service_id")
        
        image_file_path += "/#{image.external_identifier}.json"
        File.open(image_file_path, "w") do |f|
          f.write @jsonobj.to_json
          numArchived += 1
        end
      end
      puts "#{numArchived} image(s) metadata extracted"
    end
  end
end
