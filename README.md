# Lentil

lentil is a Ruby on Rails Engine that supports the harvesting of images from Instagram and provides several browsing views, mechanisms for sharing, tools for users to select their favorite images, an administrative interface for moderating images, and a system for harvesting images and submitting donor agreements in preparation of ingest into external repositories. Built according to the principles of responsive design, lentil is designed for use on mobile devices, tablets, desktops, and larger screens.

[![Build Status](https://travis-ci.org/NCSU-Libraries/lentil.png)](https://travis-ci.org/NCSU-Libraries/lentil)
[![Gem Version](https://badge.fury.io/rb/lentil.png)](http://badge.fury.io/rb/lentil)

## History

lentil is extracted from the [My #HuntLibrary project](http://www.lib.ncsu.edu/dli/projects/MHL) at [NCSU Libraries](http://www.lib.ncsu.edu/). My #HuntLibrary was created as a platform to foster student and community engagement with the new [James B. Hunt Jr. Library](http://www.lib.ncsu.edu/huntlibrary) via social media imagery and to preserve and archive these images as part of the record of the Hunt Library launch. Images from this crowdsourced documentation effort will be selected to become part of our permanent digital collections, allowing the NCSU community to contribute to the historical record of the Hunt Library through image submissions as well as the use of voting tools.

## Project Maturity

Although we are using this gem in production, **this gem should be considered an early release**.

## Installation

lentil has been tested under Ruby 1.9.3 and 2.1.0.

### Add lentil and therubyracer (or another ExecJS runtime) to your Gemfile and `bundle`

```ruby
gem 'lentil'
gem 'therubyracer'
```

> If you would like to work directly from the master branch, use `gem 'lentil', :git => 'git://github.com/NCSU-Libraries/lentil.git'` instead.

### Run the generator

```sh
bundle exec rails generate lentil:install
```

### Start the server

```sh
bundle exec rails server
```

Visit <http://localhost:3000>

## Harvest Images

- You will need to define your `instagram_client_id` and `instagram_client_secret` in `config/lentil_config.yml`. You can generate these strings by creating an [Instagram API](http://instagram.com/developer) client for your application.

- If you haven't already, add an administrative user in development.

```sh
bundle exec rake lentil:dummy_admin_user
```

You will then have an administrative user with the following credentials:
- Username: admin@example.com
- Password: password

- Login to the administrative console. Go to <http://localhost:3000/admin>

- Go to <http://localhost:3000/admin/lentil_tags/> and create a new tag.
- Go to <http://localhost:3000/admin/lentil_tagsets> and create a new tagset, selecting the tag you just created. Make sure to mark this tagset as `harvestable`.

- Harvest some images by opening up another terminal and running:

```sh
bundle exec rake lentil:image_services:instagram:fetch_by_tag
```

You ought to see a message like: "15 new images added"

> **Note:** The harvesting task currently does not utilize Instagram's result paging. It is important at this point to harvest images frequently in order to avoid missed content.

- Go to <http://localhost:3000/admin/lentil_images> and click on "Moderate New." Approve or reject some images. Once you've approved some, go to <http://localhost:3000> to see your approved images.
- Congratulations! You're now up and running!

## Scheduling tasks

There are several rake tasks that you should schedule to run on a recurring basis:

- `rake lentil:image_services:instagram:fetch_by_tag` harvests image metadata for all tags within "harvestable" tagsets.
- `rake lentil:image_services:test_image_files[number_of_images,image_service]` checks that the image content for approved images is still available. After 3 failures, Lentil will stop displaying the images. After 10 failures, Lentil will stop checking. Defaults to checking 10 Instagram images. Images will not be checked more than once per day.
- `rake lentil:popularity:update_score` recalculates the popularity score based on "likes" and "battles."

Additionally, there are two optional rake tasks that support image file harvesting for longer-term retention:

- `rake lentil:image_services:save_image_files[number_of_images,image_service,base_directory]` Lentil normally only stores image metadata, but this task will save the image file to a specified directory. This file will still not be used by Lentil, but the file retrieval will be noted in the Image model. Defaults to 50 Instagram images, saving to the path specified by the `base_image_file_dir` option from `config/lentil_config.yml`.
- `rake lentil:image_services:submit_donor_agreements[number_of_images,image_service]` will submit a donor agreement (using the `donor_agreement_text` option from `config/lentil_config.yml`) as a comment on approved Instagram images that have been in the system for at least a week. Currently defaults to one image.

> In order to submit comments, you will need to generate an access token for the user that will submit the comments. See the [Instagram documentation](http://instagram.com/developer/authentication/) and a [discussion of access token expiration](https://groups.google.com/forum/?fromgroups=#!searchin/instagram-api-developers/access$20token%7Csort:date/instagram-api-developers/OBOTwIh3FSw/9hTccUX1Jq4J).

An example of a background task schedule using the [whenever](https://github.com/javan/whenever) gem:

```ruby
case @environment
when 'production'
  every 5.minutes do
    rake "image_services:instagram:fetch_by_tag", :output => {:standard => nil}
  end

  every 30.minutes do
    rake "image_services:test_image_files", :output => {:standard => nil}
  end
end

# All environments
every :hour do
  rake "popularity:update_score", :output => {:standard => nil}
end
```

## Customization

- A simple first customization to do is to override the about page by putting your own about page at app/views/lentil/pages/about.html.erb.
- If you haven't already you'll have update your `config/lentil_config.yml` file with your application name.
- You can change the look of your site by including some variables in your application.css.scss before importing the lentil CSS:

```sass
$gray_text: #34282C;
$lentil_yellow: #DAB416;
$lentil_blue: #08C;
@import "lentil";
```

- In order to set image backgrounds in [My #HuntLibrary](http://d.lib.ncsu.edu/myhuntlibrary), the following CSS is included in a file that is imported after `lentil`:

```css
body {
    background: image-url("background/fins3.jpg") fixed;
}

.navbar-inner {
    background: #121212 image-url("nav/top_background.png") repeat-x;
}

div.header {
    background: #0C1021 image-url("nav/example_08.jpg");
}
```

## Special displays

### Embeddable iframe view

This is a simple responsive non-interactive image grid that is intended to be embedded as an iframe. You can find this at `http://YOUR_HOST/images/iframe`.

### Large animated view

This is an example of an animated image grid that is designed for non-interactive displays. We have used customized versions of this on e-boards as well as very large video walls. This view will require some customization based on your project and target display. You can find this at `http://YOUR_HOST/images/animate`.

## Testing

- Install all of the dependencies:

```sh
bundle install
```

- Prepare the test database

```sh
RAILS_ENV=test bundle exec rake app:db:migrate
RAILS_ENV=test bundle exec rake app:db:test:prepare
```

- Run the tests

```sh
bundle exec rake test
```

## Running the Test/Dummy Instance

Sometimes you just might want to see what the dummy instance actually looks like. You can do the following:

```sh
bundle exec rake app:db:schema:load
cd test/dummy
bundle exec rake db:fixtures:load FIXTURES_PATH=../fixtures
bundle exec rails s
```

Once you load the fixtures you'll be able to harvest anything that has the tag "#hunttesting"

```sh
cd test/dummy
```

Edit `config/lentil_config.yml` and set `instagram_client_id` to the client ID associated with your Instagram API client.

```sh
bundle exec rake image_services:instagram:fetch_by_tag
```

## License

See MIT-LICENSE

## Contact

Submit a GitHub issue or contact lentil@lists.ncsu.edu.

## Authors (in alphabetical order)

* Jason Casden
* Bret Davidson
* Cory Lown
* Jason Ronallo

## Additional project team members

* Brian Dietz
* Jennifer Garrett
* Mike Nutt (Product Lead for My #HuntLibrary project)
