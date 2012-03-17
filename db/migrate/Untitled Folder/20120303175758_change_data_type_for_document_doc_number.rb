class ChangeDataTypeForDocumentDocNumber < ActiveRecord::Migration
  def self.up
    change_table :documents do |t|
      t.change :doc_number, :integer
    end
  end

  def self.down
    change_table :widgets do |t|
      t.change :doc_number, :string
    end
  end
end
