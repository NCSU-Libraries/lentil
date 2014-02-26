module Lentil
  class ImagesController < Lentil::ApplicationController
    include ActionView::Helpers::TextHelper

    def index
        respond_to do |format|
          format.html { @images = Image.includes(:user).approved.recent.search(params[:page]) }
          format.atom { @images = Image.includes(:user).approved.recent.limit(200) }
          format.rss { @images = Image.includes(:user).approved.recent.limit(200) }
        end
    end

    def recent
        @title = "Recent Images"
        respond_to do |format|
          format.html { @images = Image.includes(:user).approved.recent.search(params[:page]) }
          format.atom { @images = Image.includes(:user).approved.recent.limit(200) }
          format.rss { @images = Image.includes(:user).approved.recent.limit(200) }
        end
        render :action => "index"
    end

    def popular
      @title = "Popular Images"
      # show about 10% of image ordered by popularity
      number_to_show = (Image.approved.count*0.1).round
      respond_to do |format|
        format.html { @images = Image.includes(:user).approved.popular.search(params[:page], number_to_show) }
        format.atom { @images = Image.includes(:user).approved.popular.limit(number_to_show) }
        format.rss { @images = Image.includes(:user).approved.popular.limit(number_to_show) }
      end
      render :action => "index"
    end

    def staff_picks
      @title = "Staff Picks"
      respond_to do |format|
        format.html { @images = Image.includes(:user).approved.staff_picks.search(params[:page]) }
        format.atom { @images = Image.includes(:user).approved.staff_picks.limit(200)}
        format.rss { @images = Image.includes(:user).approved.staff_picks.limit(200)}
      end
      render :action => "index"
    end

    def show
      @image = Image.approved.find(params[:id])
      short_title = truncate(@image.description, :length => 50, :separator => ' ')
      @title = "#{short_title}, #{@image.user.user_name}, Image #{@image.id}"
    end

    def animate
      @images = Image.approved.blend
    end

    def staff_picks_animate
      @images = Image.approved.staff_picks.limit(100)
      render 'animate'
    end

    def iframe
      @images = Image.includes(:user).approved.recent.limit(125)
      render :action => "iframe", :layout => "lentil/iframe"
    end
  end
end
