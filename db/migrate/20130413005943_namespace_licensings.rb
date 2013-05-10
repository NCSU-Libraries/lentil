class NamespaceLicensings < ActiveRecord::Migration
  def change
    rename_table :licensings, :lentil_licensings
  end
end
