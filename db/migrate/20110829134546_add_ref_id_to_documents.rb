class AddRefIdToDocuments < ActiveRecord::Migration
  def self.up
    add_column :documents, :ref_id, :interger
  end

  def self.down
    remove_column :documents, :ref_id
  end
end
