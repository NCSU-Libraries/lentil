module Lentil
  class ApplicationController < ActionController::Base
    # FIXME: I don't know why the engine isn't using its own application layout like it is supposed to.
    layout "lentil/application"
  end
end