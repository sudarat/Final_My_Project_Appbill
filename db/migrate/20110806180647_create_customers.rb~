class CreateCustomers < ActiveRecord::Migration
  def self.up
    create_table :customers do |t|
      t.string :custname
      t.text :custaddress
      t.string :custtel
      t.string :custcontact_name
      t.string :custcontact_tel
      t.string :custcontact_email

      t.timestamps
    end
  end

  def self.down
    drop_table :customers
  end
end
