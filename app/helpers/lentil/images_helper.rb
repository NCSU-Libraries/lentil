module Lentil
  module ImagesHelper

    def already_like_voted?(image)
      session['liked_images'] && session['liked_images'].include?(image.id.to_s)
    end

    def already_flagged?(image)
      session['flagged_images'] && session['flagged_images'].include?(image.id.to_s)
    end

    # FIXME: This doesn't seem to be used
    # def feed_url(protocol)
    #   unless current_page?(root_url)
    #     "#{request.protocol}#{request.host_with_port}#{request.fullpath}.#{protocol}"
    #   else
    #     "#{images_recent_url}.#{protocol}"
    #   end
    # end

  end
end

