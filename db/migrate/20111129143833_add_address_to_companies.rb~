class AddAddressToCompanies < ActiveRecord::Migration
  def self.up
    add_column :companies, :compstreet, :string
    add_column :companies, :compsub_district, :string
    add_column :companies, :compdistrict, :string
    add_column :companies, :province_id , :integer ,:references=>"provinces"
  end

  def self.down
    remove_column :companies, :province
    remove_column :companies, :compdistrict
    remove_column :companies, :compsub_district
    remove_column :companies, :compstreet
  end
end
