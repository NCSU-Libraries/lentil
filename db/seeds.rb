# These seeds are run by including Lentil::Engine.load_seed in the application db/seeds file.

Lentil::License.where(short_name: 'ARR').first_or_create(name: 'All Right Reserved')
Lentil::Service.where(name: 'Instagram').first_or_create(url: 'http://www.instagram.com')
Lentil::Tag.where(name: 'MHL_geolocated').first_or_create