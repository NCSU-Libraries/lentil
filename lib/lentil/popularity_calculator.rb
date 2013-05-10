module Lentil
  class PopularityCalculator

    # Takes image object and returns a popularity score
    #
    # @param [object] image object with image data
    #
    # @return [integer] popularity score of image
    def calculate_popularity(image)

      # A staff like is worth 10 points
      if (image.staff_like === false)
        staff_like_points = 0
      else
        staff_like_points = 10
      end

      # likes have diminishing returns
      # 10 likes is 13 points
      # 100 likes is 25 points
      if image.like_votes_count > 0
        like_vote_points = Math::log(image.like_votes_count, 1.2).round
      else
        like_vote_points = 0
      end

      # if an image has fewer than 5 battle rounds this is 0
      # 5 or more and the points awarded is the win_pct/2
      if image.win_pct and image.wins_count + image.losses_count > 4
        battle_points = (image.win_pct/2).round
      else
        battle_points = 0
      end

      battle_points + like_vote_points + staff_like_points

    end

    # Takes an image id and updates its popularity score
    #
    # @param [integer] id of image to update defaults to :all
    #
    # @return [boolean] success/failure of update
    def update_image_popularity_score(image_to_update = :all)

      def get_score_write_to_db(image)
        popularity_score = calculate_popularity(image)
        image.update_attribute(:popular_score, popularity_score)
      end

      if image_to_update == :all
        images = Lentil::Image.find(image_to_update)
        images.each  do |image|
          get_score_write_to_db(image)
        end
      elsif image_to_update.kind_of?(Integer)
          image = Lentil::Image.find(image_to_update)
          get_score_write_to_db(image)
      end
    end

  end
end