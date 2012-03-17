class AddCustfaxToCustomers < ActiveRecord::Migration
  def self.up
    add_column :customers, :custfax, :string
  end

  def self.down
    remove_column :customers, :custfax
  end
end
