class CreateProvinces < ActiveRecord::Migration
  def self.up
    create_table :provinces do |t|
      t.string :province_name

      t.timestamps
    end
  end

  def self.down
    drop_table :provinces
  end
end
