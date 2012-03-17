class RemoveCusttel2ToCustomers < ActiveRecord::Migration
  def self.up
    remove_column :customers, :custtel2
  end

  def self.down
    add_column :customers, :custtel2, :string
  end
end
