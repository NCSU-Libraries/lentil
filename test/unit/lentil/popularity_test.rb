require 'test_helper'

class PopularityTest < ActiveSupport::TestCase
  def setup
    @popularity_calculator = Lentil::PopularityCalculator.new
  end

  test "Given an image object a popularity score should be returned" do
      image = lentil_images(:one)
      popularity_score = @popularity_calculator.calculate_popularity(image)
      assert(popularity_score > 0)
  end

  test "Popularity score should be saved" do
      image = lentil_images(:one)
      @popularity_calculator.update_image_popularity_score(image.id)
      assert(Lentil::Image.find(image.id).popular_score > 0)
  end
end