class AddDonorAgreementRejectedToImages < ActiveRecord::Migration
  def change
    add_column :lentil_images, :donor_agreement_rejected, :datetime
  end
end
