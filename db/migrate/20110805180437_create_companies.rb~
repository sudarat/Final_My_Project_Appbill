class CreateCompanies < ActiveRecord::Migration
  def self.up
    create_table :companies do |t|
      t.string :compname
      t.text :compaddress
      t.string :comptel
      t.string :compfax
      t.string :comptax
      t.string :compauthor_name
      t.string :compauthor_position
      t.string :compauthor_tel

      t.timestamps
    end
  end

  def self.down
    drop_table :companies
  end
end
