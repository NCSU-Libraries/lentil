require 'net/http'

module Lentil
  class ThisorthatController < Lentil::ApplicationController
    respond_to :html

    def test_urls(images, quantity)
      image = images.selecting{ |i|
        begin
          res = OEmbed::Providers::Instagram.get(i.url)
          true
        rescue
          false
        end
      }.first(quantity)
    end

    def battle_leaders
      @title = "Battle Leaders"

      @images = Image.approved.where("win_pct IS NOT NULL").select{ |i| i.battles_count > 4}
      @images = @images.sort_by{ |i| i.win_pct}.reverse.first(25)

      render :action => "../images/index"
    end

    def get_images
      images = Image.approved.random(20).sort_by{|i| i.battles_count}
      images = test_urls(images, 2).sort_by{ |i| i.id }

      session[:battle_images] = []
      images.each do |image|
        session[:battle_images] << image.id
      end

      return images
    end

    def battle
      @title = "Battle"
      @images = get_images
      @prev_winner = session[:prev_winner] || nil

      prev_images = session[:prev_images] || []

      unless prev_images.empty?
        begin
          @prev_images = Image.find(session[:prev_images]).sort_by{ |i| i.id }
        rescue
          @prev_images = []
        end
      else
        @prev_images = []
      end

      if @images.length < 2
        Rails.logger.error "Battle Image Failure: possible service outage"
        render "/lentil/thisorthat/battle_error"
      end
    end

    def result
      viewed_ids = session[:battle_images] || []

      submitted_ids = []
      params['image'].each do |image|
        submitted_ids << image[0].to_i
      end

      winner_id = params['vote'].to_i

      cond_one = submitted_ids.length == 2
      cond_two = (submitted_ids - viewed_ids).size == 0
      cond_three = submitted_ids.include? winner_id

      if cond_one && cond_two && cond_three
        loser_id = submitted_ids.reject{|id| id == winner_id}.first

        begin
          winner = Image.find(winner_id)
          loser  = Image.find(loser_id)
        rescue => e
          message = "Battle not saved: " << e.message
          Rails.logger.error message
        else
          winner.won_battles.create(:loser => loser)
        end
      else
        message = "Battle not saved"
        message << ": submitted_ids length is not equal to 2" unless cond_one
        message << ": submitted_ids not in viewed_ids" unless cond_two
        message << ": submitted_ids do not include winner_id" unless cond_three
        Rails.logger.error message
      end

      respond_with do |format|
        format.html do
          if request.xhr?
            @images = get_images
            if @images.length < 2
              render :partial => "/layouts/lentil/error", :locals => {:error_message => "Sorry, there was a problem loading images."}
            else
              session[:prev_images] = submitted_ids
              session[:prev_winner] = winner_id
              @prev_images = Lentil::Image.find(submitted_ids).sort_by{ |i| i.id }
              @prev_winner = session[:prev_winner]

              render :partial => "/lentil/thisorthat/battle_form", :locals => { :images => @images, :prev_images => @prev_images, :prev_winner => @prev_winner }, :layout => false, :status => :created
            end
          else
            session[:prev_images] = submitted_ids
            session[:prev_winner] = winner_id
            redirect_to :back
          end
        end
      end
    end
  end
end