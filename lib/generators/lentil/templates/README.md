

# Lentil Post-Installation Instructions

You will need to make the following changes:

1. If you haven't already, create an administrative user in development. See the project README.md.

2. You may need to configure config/initializers/devise.rb

3. From the Devise documentation: "Ensure you have defined default url options in your environments files. Here is an example of default_url_options appropriate for a development environment in config/environments/development.rb:

        config.action_mailer.default_url_options = { :host => 'localhost:3000' }

    In production, :host should be set to the actual host of your application."

3. Update that config/lentil_config.yml with your information. It is probably a good idea to add that file to your .gitignore too. You'll definitely want to change your instagram values and the default_image_search_tag.

4. Look at the README.md for how to begin harvesting images and customizing your application.

5. Enjoy!




