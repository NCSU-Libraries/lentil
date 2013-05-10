module Lentil
  class PagesController < Lentil::ApplicationController
    def about
      @title = "About"
    end
  end
end