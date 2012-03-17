class AddCancelToDocument < ActiveRecord::Migration
  def self.up
    add_column :documents, :cancel, :boolean
  end

  def self.down
    remove_column :documents, :cancel
  end
end
