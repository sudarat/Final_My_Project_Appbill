class CreateDocuments < ActiveRecord::Migration
  def self.up
    create_table :documents do |t|
      t.string :title
      t.text :detail
      t.integer :terms
      t.text :condition
      t.date :doc_date
      t.string :doc_number
      t.boolean :approve
      t.boolean :complete
      t.references :customer
      t.string :type

      t.timestamps
    end
  end

  def self.down
    drop_table :documents
  end
end
