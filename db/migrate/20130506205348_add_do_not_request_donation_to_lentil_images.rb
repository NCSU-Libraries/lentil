class AddDoNotRequestDonationToLentilImages < ActiveRecord::Migration
  def change
    add_column :lentil_images, :do_not_request_donation, :boolean, :default => false
  end
end
