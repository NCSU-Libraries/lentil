class AddLastDonorAgreementFailureDateToLentilImages < ActiveRecord::Migration
  def change
    add_column :lentil_images, :last_donor_agreement_failure_date, :datetime
  end
end
