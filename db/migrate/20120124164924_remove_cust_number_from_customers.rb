class RemoveCustNumberFromCustomers < ActiveRecord::Migration
  def self.up
    remove_column :customers, :cust_number
  end

  def self.down
    add_column :customers, :cust_number, :string
  end
end
