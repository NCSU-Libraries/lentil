module Lentil
  class PhotographersController < Lentil::ApplicationController
    def index
      @photographers = User.joins(:images).where("state = 1").group('lentil_users.id').order(:user_name)
      @title = "Photographers"
    end

    def show
      @images = Image.search(params[:page]).approved.where(:user_id => params[:id]).includes(:user).order("original_datetime DESC")


      if @images.empty?
        head :internal_server_error
      else
        @photographer = @images.find(:first).user
        @title = @photographer.user_name + " - Photographers"
      end
    end
  end
end