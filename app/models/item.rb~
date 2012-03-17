class Item < ActiveRecord::Base
  belongs_to :quotation
  belongs_to :invoice
  belongs_to :bill
  belongs_to :billtaxinvoice
  belongs_to :taxinvoice
  belongs_to :receipt
  
  validates_presence_of :description ,:message => "Please fill in the blank"
  
  validates_presence_of :quantity,:message => "Please fill in the blank"
  validates_numericality_of :quantity, :allow_blank => true , :greater_than => 0
  
  validates_presence_of :unit_price,:message => "Please fill in the blank"
  validates_numericality_of :unit_price, :allow_blank => true, :greater_than_or_equal_to => 0
  
  
end
