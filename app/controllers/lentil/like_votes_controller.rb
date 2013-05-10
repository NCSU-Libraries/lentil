module Lentil
  class LikeVotesController < Lentil::ApplicationController
    def tally
      image = Image.find(params[:image_id])
      like_vote = LikeVote.new(:image => image)
      if like_vote.save
        session[:liked_images] ||= []
        session[:liked_images] << params[:image_id]
      end
      redirect_to :back
    end
  end
end