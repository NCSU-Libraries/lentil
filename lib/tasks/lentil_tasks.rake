namespace :lentil do

  desc 'create a dummy admin user in development'
  task :dummy_admin_user => :environment do
    if Lentil::AdminUser.find_by_email('admin@example.com').blank?
      Lentil::AdminUser.create!(:email => 'admin@example.com', :password => 'password', :password_confirmation => 'password')
    end
  end

end