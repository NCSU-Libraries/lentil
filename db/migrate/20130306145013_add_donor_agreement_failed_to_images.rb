class AddDonorAgreementFailedToImages < ActiveRecord::Migration
  def change
    add_column :images, :donor_agreement_failed, :integer, :default => 0
  end
end
