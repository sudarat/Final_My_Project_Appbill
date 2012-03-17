class Customer < ActiveRecord::Base
  has_many :document , :dependent => :destroy
  has_many :quotation , :dependent => :destroy
  belongs_to :province
  belongs_to :company
  
  validates_presence_of :custname ,:message => "Please fill in the blank"
  validates_presence_of :custaddress, :custsub_district, :custdistrict, :province ,:message => "Please fill in the blank"
  
  validates_presence_of :custtel,:message => "Please fill in the blank"
#   validates_numericality_of :custtel, :allow_blank => true/\A((?[0-9]{3}\)?[-. ]?[0-9]{3}[-. ]?[0-9]{3,4})\z/i
  validates_format_of :custtel , :with => /\(?[0-9]{2,3}\)?[-.-](?:[0-9]{6,7})\Z/i , :allow_blank => true
#   validates_length_of :custtel, :in => 9..10, :allow_blank => true
  validates_format_of :custfax , :with => /\(?[0-9]{2,3}\)?[-.-](?:[0-9]{6,7})\Z/i , :allow_blank => true
  
  validates_presence_of :custcontact_name,:message => "Please fill in the blank"
#   validates_uniqueness_of :custcontact_name
  
  validates_presence_of :custcontact_tel,:message => "Please fill in the blank"
#   validates_numericality_of :custcontact_tel, :allow_blank => true
#   validates_length_of :custcontact_tel, :in => 9..10, :allow_blank => true
#   validates_uniqueness_of :custcontact_tel
  validates_format_of :custcontact_tel , :with => /\(?[0-9]{2,3}\)?[-.-](?:[0-9]{6,7})\Z/i , :allow_blank => true


  
#   validates_uniqueness_of :custcontact_email , :allow_blank => true
  validates_format_of :custcontact_email , :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i , :allow_blank => true
  
# search  
  def self.searchcustname(search)
   if search
    where('custname LIKE ?', "%#{search}%")
   else
    scoped
   end
  end
  
  def self.searchcustcontact(search)
   if search
    where('custcontact_name LIKE ?', "%#{search}%")
   else
    scoped
   end
  end
  

end
