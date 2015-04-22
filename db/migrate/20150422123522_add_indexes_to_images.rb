class AddIndexesToImages < ActiveRecord::Migration
  def change
    add_index :lentil_images, :user_id
    add_index :lentil_images, :state
    add_index :lentil_images, :created_at
    add_index :lentil_images, :updated_at
    add_index :lentil_images, :staff_like
    add_index :lentil_images, :original_datetime
    add_index :lentil_images, :file_last_checked
    add_index :lentil_images, :failed_file_checks
    add_index :lentil_images, :do_not_request_donation
    add_index :lentil_images, :last_donor_agreement_failure_date
    add_index :lentil_images, :suppressed
  end
end
