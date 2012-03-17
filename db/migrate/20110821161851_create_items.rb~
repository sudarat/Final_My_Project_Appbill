class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :description
      t.integer :quantity
      t.float :unit_price
      t.references :quotation
      t.references :invoice
      t.references :bill
      t.references :taxinvoice
      t.references :receipt
      t.references :billtaxinvoice

      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
