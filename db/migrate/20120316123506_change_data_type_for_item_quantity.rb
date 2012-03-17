class ChangeDataTypeForItemQuantity < ActiveRecord::Migration
  def self.up
    change_table :items do |t|
      t.change :quantity, :float
    end
  end

  def self.down
    change_table :items do |t|
      t.change :quantity, :integer
    end
  end
end
