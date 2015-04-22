# FIXME: can these be moved to main library file?
require 'instagram'
require 'date'
require 'oembed'
require 'pp'

class DuplicateImageError < StandardError
end

module Lentil
  # A collection of methods for querying the Instagram API and importing metadata.
  class InstagramHarvester

    #
    # Configure the Instagram class in preparation requests.
    #
    # @options opts [String] :client_id (Lentil::Engine::APP_CONFIG["instagram_client_id"]) The Instagram client ID
    # @options opts [String] :client_secret (Lentil::Engine::APP_CONFIG["instagram_client_secret"]) The Instagram client secret
    # @options opts [String] :access_token (nil) The optional Instagram client ID
    def configure_connection(opts = {})
      opts['client_id'] ||= Lentil::Engine::APP_CONFIG["instagram_client_id"]
      opts['client_secret'] ||= Lentil::Engine::APP_CONFIG["instagram_client_secret"]
      opts['access_token'] ||= nil

      Instagram.configure do |config|
        config.client_id = opts['client_id']
        config.client_secret = opts['client_secret']

        if (opts['access_token'])
          config.access_token = opts['access_token']
        end
      end
    end


    #
    # Configure the Instagram class in preparation for leaving comments
    #
    # @param  access_token = nil [String] Instagram access token for the writing account
    def configure_comment_connection(access_token = nil)
      access_token ||= Lentil::Engine::APP_CONFIG["instagram_access_token"] || nil
      raise "instagram_access_token must be defined as a parameter or in the application config" unless access_token
      configure_connection({'access_token' => access_token})
    end

    # Queries the Instagram API for recent images with a given tag.
    #
    # @param [String] tag The tag to query by
    #
    # @return [Hashie::Mash] The data returned by Instagram API
    def fetch_recent_images_by_tag(tag = nil)
      configure_connection
      tag ||= Lentil::Engine::APP_CONFIG["default_image_search_tag"]
      Instagram.tag_recent_media(tag, :count=>100)
    end


    # Queries the Instagram API for the image metadata associated with a given ID.
    #
    # @param [String] image_id Instagram image ID
    #
    # @return [Hashie::Mash] data returned by Instagram API
    def fetch_image_by_id(image_id)
      configure_connection
      Instagram.media_item(image_id)
    end


    # Retrieves an image OEmbed metadata from the public URL using the Instagram OEmbed service
    #
    # @param  url [String] The public Instagram image URL
    #
    # @return [String] the Instagram image OEmbed data
    def retrieve_oembed_data_from_url(url)
      OEmbed::Providers::Instagram.get(url)
    end

    # Retrieves image metadata via the public URL and imports it
    #
    # @param  url [String] The public Instagram image URL
    #
    # @return [Array] new image objects
    def save_image_from_url(url)
      save_instagram_load(fetch_image_by_id(retrieve_oembed_data_from_url(url).fields["media_id"]))
    end


    # Produce processed image metadata from Instagram metadata.
    # This metadata is accepted by the save_image method.
    #
    # @param [Hashie::Mash] instagram_metadata The single image metadata returned by Instagram API
    #
    # @return [Hash] processed image metadata
    def extract_image_data(instagram_metadata)
      {
        url: instagram_metadata.link,
        external_id: instagram_metadata.id,
        large_url: instagram_metadata.images.standard_resolution.url,
        name: instagram_metadata.caption && instagram_metadata.caption.text,
        tags: instagram_metadata.tags,
        user: instagram_metadata.user,
        original_datetime: Time.at(instagram_metadata.created_time.to_i).to_datetime,
        original_metadata: instagram_metadata,
        media_type: instagram_metadata.type,
        video_url: instagram_metadata.videos && instagram_metadata.videos.standard_resolution.url
      }
    end


    # Takes return from Instagram API gem and adds image,
    # users, and tags to the database.
    #
    # @raise [DuplicateImageError] This method does not accept duplicate external image IDs
    #
    # @param [Hash] image_data processed Instagram image metadata
    #
    # @return [Image] new Image object
    def save_image(image_data)

      instagram_service = Lentil::Service.where(:name => "Instagram").first

      user_record = instagram_service.users.where(:user_name => image_data[:user][:username]).
        first_or_create!({:full_name => image_data[:user][:full_name], :bio => image_data[:user][:bio]})

      raise DuplicateImageError, "Duplicate image identifier" unless user_record.
        images.where(:external_identifier => image_data[:external_id]).first.nil?

      image_record = user_record.images.build({
        :external_identifier => image_data[:external_id],
        :description => image_data[:name],
        :url => image_data[:url],
        :long_url => image_data[:large_url],
        :video_url => image_data[:video_url],
        :original_datetime => image_data[:original_datetime],
        :media_type => image_data[:media_type]
      })

      image_record.original_metadata = image_data[:original_metadata].to_hash

      # Default to "All Rights Reserved" until we find out more about licenses
      # FIXME: Set the default license in the app config
      unless image_record.licenses.size > 0
        image_record.licenses << Lentil::License.where(:short_name => "ARR").first
      end

      image_data[:tags].each {|tag| image_record.tags << Lentil::Tag.where(:name => tag).first_or_create}

      user_record.save!
      image_record.save!
      image_record
    end

    # Takes return from Instagram API gem and adds all new images,
    # users, and tags to the database.
    #
    # @param [Hashie::Mash] instagram_load The content returned by the Instagram gem
    # @param [Boolean] raise_dupes Whether to raise exceptions for duplicate images
    #
    # @raise [DuplicateImageError] If there are duplicate images and raise_dupes is true
    #
    # @return [Array] New image objects
    def save_instagram_load(instagram_load, raise_dupes=false)
      # Handle collections of images and individual images
      images = instagram_load

      if !images.kind_of?(Array)
        images = [images]
      end

      images.collect {|image|
        begin
          save_image(extract_image_data(image))
        rescue DuplicateImageError => e
          raise e if raise_dupes
          next
        rescue => e
          Rails.logger.error e.message
          puts e.message
          pp image
          next
        end
      }.compact
    end


    #
    # Call save_instagram_load, but raise exceptions for duplicates.
    #
    # @param [Hashie::Mash] instagram_load The content returned by the Instagram gem
    #
    # @raise [DuplicateImageError] If there are duplicate images
    #
    # @return [Array] New image objects
    def save_instagram_load!(instagram_load)
      save_instagram_load(instagram_load, true)
    end

    #
    # Retrieve the binary image data for a given Image object
    #
    # @param [Image] image An Image model object from the Instagram service
    #
    # @raise [Exception] If there are request problems
    #
    # @return [String] Binary image data
    def harvest_image_data(image)
      response = Typhoeus.get(image.large_url(false), followlocation: true)

      if response.success?
        raise "Invalid content type: " + response.headers['Content-Type'] unless (response.headers['Content-Type'] == 'image/jpeg')
      elsif response.timed_out?
        raise "Request timed out"
      elsif response.code == 0
        raise "Could not get an HTTP response"
      else
        raise "HTTP request failed: " + response.code.to_s
      end

      response.body
    end
    
    #
    # Retrieve the binary video data for a given Image object
    #
    # @param [Image] image An Image model object from the Instagram service
    #
    # @raise [Exception] If there are request problems
    #
    # @return [String] Binary video data
    def harvest_video_data(image)
      response = Typhoeus.get(image.video_url, followlocation: true)

      if response.success?
        raise "Invalid content type: " + response.headers['Content-Type'] unless (response.headers['Content-Type'] == 'video/mp4')
      elsif response.timed_out?
        raise "Request timed out"
      elsif response.code == 0
        raise "Could not get an HTTP response"
      else
        raise "HTTP request failed: " + response.code.to_s
      end

      response.body
    end

    #
    # Test if an image is still avaiable
    #
    # @param [Image] image An Image model object from the Instagram service
    #
    # @raise [Exception] If there are request problems
    #
    # @return [Boolean] Whether the image request was successful
    def test_remote_image(image)
      response = Typhoeus.get(image.thumbnail_url(false), followlocation: true)

      if response.success?
        true
      elsif response.timed_out? || (response.code == 0)
        nil
      else
        false
      end
    end

    #
    # Leave a comment containing the donor agreement on an Instagram image
    #
    # @param  image [type] An Image model object from the Instagram service
    #
    # @raise [Exception] If a comment submission fails
    # @authenticated true
    #
    # @return [Hashie::Mash] Instagram response
    def leave_image_comment(image, comment)
      configure_comment_connection
      Instagram.client.create_media_comment(image.external_identifier, comment)
    end
  end
end
