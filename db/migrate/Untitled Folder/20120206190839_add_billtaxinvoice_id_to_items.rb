class AddBilltaxinvoiceIdToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :billtaxinvoice_id, :integer ,:references=>"billtaxinvoices"
  end

  def self.down
    remove_column :items, :billtaxinvoice
  end
end
