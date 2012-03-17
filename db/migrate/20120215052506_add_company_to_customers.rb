class AddCompanyToCustomers < ActiveRecord::Migration
  def self.up
    add_column :customers, :company_id, :integer ,:references=>"companies"
  end

  def self.down
    remove_column :customers, :company
  end
end
