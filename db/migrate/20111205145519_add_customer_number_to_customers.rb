class AddCustomerNumberToCustomers < ActiveRecord::Migration
  def self.up
    add_column :customers, :cust_number, :string
  end

  def self.down
    remove_column :customers, :cust_number
  end
end
