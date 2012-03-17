class AddBilltaxinvoiceIdToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :billtaxinvoice, :references
  end

  def self.down
    remove_column :items, :billtaxinvoice
  end
end
