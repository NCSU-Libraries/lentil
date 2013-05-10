module Lentil
  class FlagsController < Lentil::ApplicationController
    def tally
      image = Image.find(params[:image_id])
      flag = Flag.new(:image => image)
      if flag.save
        session[:flagged_images] ||= []
        session[:flagged_images] << params[:image_id]
      end
      redirect_to :back
    end
  end
end