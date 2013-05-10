namespace :lentil do
  namespace :popularity do
    desc "Calculate value of popularity score from battle, staff picks, and like votes"
    task :update_score => :environment do

      begin
        popularity_calculator = Lentil::PopularityCalculator.new
        updated_score_count = popularity_calculator.update_image_popularity_score().size
        puts "#{updated_score_count} image popularity scores updated"
      rescue => e
        Rails.logger.error e.message
        raise e
      end
    end
  end
end