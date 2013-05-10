class AddDonorAgreementSubmittedToImages < ActiveRecord::Migration
  def change
    add_column :images, :donor_agreement_submitted_date, :datetime
  end
end
