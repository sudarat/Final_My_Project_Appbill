class AddCusttel2ToCustomers < ActiveRecord::Migration
  def self.up
    add_column :customers, :custtel2, :string
  end

  def self.down
    remove_column :customers, :custtel2
  end
end
