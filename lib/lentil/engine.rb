module Lentil
  class Engine < ::Rails::Engine
    isolate_namespace Lentil

    initializer :lentil do
      # FIXME: why?
      ActiveAdmin.application.load_paths += [File.expand_path(File.join(Lentil::Engine.root, 'lib/lentil/admin'))]

      config_file = File.join(Rails.root, "/config/lentil_config.yml")
      if File.exist?(config_file)
        APP_CONFIG = YAML.load_file(config_file)[Rails.env]
      end
    end

    # FIXME: Why is this necessary in order to have access to helpers from within the engine itself?
    config.to_prepare do
      ApplicationController.helper(Lentil::ApplicationHelper)
      ApplicationController.helper(Lentil::ImagesHelper)
      ApplicationController.helper(Lentil::ThisorthatHelper)
    end
  end
end
