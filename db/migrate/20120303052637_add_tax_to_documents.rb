class AddTaxToDocuments < ActiveRecord::Migration
  def self.up
    add_column :documents, :tax, :boolean
  end

  def self.down
    remove_column :documents, :tax
  end
end
