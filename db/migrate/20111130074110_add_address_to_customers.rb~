class AddAddressToCustomers < ActiveRecord::Migration
  def self.up
    add_column :customers, :custstreet, :string
    add_column :customers, :custsub_district, :string
    add_column :customers, :custdistrict, :string
    add_column :customers, :province_id , :integer ,:references=>"provinces"
  end

  def self.down
    remove_column :customers, :province
    remove_column :customers, :custdistrict
    remove_column :customers, :custsub_district
    remove_column :customers, :custstreet
  end
end
