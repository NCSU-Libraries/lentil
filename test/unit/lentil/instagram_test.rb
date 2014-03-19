require 'test_helper'

class InstagramTest < ActiveSupport::TestCase
  def setup
    @harvester = Lentil::InstagramHarvester.new
  end

  test "Instagram images should be added to Image model without duplication" do
    VCR.use_cassette('instagram_by_tag') do
      instagram_metadata = @harvester.fetch_recent_images_by_tag "huntlibrary"
      @harvester.save_instagram_load instagram_metadata
      assert_raise DuplicateImageError do
        @harvester.save_instagram_load! instagram_metadata
      end
    end
  end

  test "Invalid image metadata should not prevent other images from being added" do
    # One record in this cassette is damaged by manually removing the 'link'
    VCR.use_cassette('instagram_by_tag_damaged') do
      instagram_metadata = @harvester.fetch_recent_images_by_tag "dhhill"
      expected_image_count = instagram_metadata.length - 1
      actual_image_count = nil

      silence_stream(STDOUT) do
        actual_image_count = @harvester.save_instagram_load(instagram_metadata)
      end

      assert_equal(expected_image_count, actual_image_count.length)
    end
  end

  test "OEmbed should return image ID" do
    image = lentil_images(:uno)
    VCR.use_cassette('instagram_oembed') do
      oembed_data = @harvester.retrieve_oembed_data_from_url(image.url)
      assert_equal(image.external_identifier,oembed_data.fields["media_id"])
    end
  end

  test "Individual images should be saved" do
    VCR.use_cassette('instagram_image_id') do
      instagram_metadata = @harvester.fetch_image_by_id("289998623568090948_31727100")
      @harvester.save_instagram_load instagram_metadata

      assert(Lentil::Image.where(:external_identifier => "289998623568090948_31727100").first.url.length > 1)
    end
  end

  test "Should be able to harvest image data" do
    image = lentil_images(:one)
    VCR.use_cassette('instagram_image_harvest') do
      image_data = @harvester.harvest_image_data(image)
      assert(!image_data.blank?)
    end
  end

  test "Existing image should pass data retrieval check" do
    image = lentil_images(:one)
    VCR.use_cassette('instagram_good_image_check') do
      assert(@harvester.test_remote_image(image))
    end
  end

  test "Nonexistent image should fail data retrieval check" do
    image = lentil_images(:tres)
    VCR.use_cassette('instagram_bad_image_check') do
      assert(!@harvester.test_remote_image(image))
    end
  end

end
