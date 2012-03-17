class Company < ActiveRecord::Base
   before_save :check_complogo,:check_compauthor_signature

#    has_attached_file	:image

   
  
  
  has_attached_file :complogo , :styles => { :medium => "300x300>", :thumb => "100x100>" , :print => "170x100>"}
  has_attached_file :compauthor_signature , :styles => { :medium => "150x150>", :thumb => "100x100>" , :print => "110x110>" }
  belongs_to :province
  has_many :customers
  
  validates_presence_of :compname,:message => "Please fill in the blank"

 
  validates_attachment_content_type :complogo,
				    :content_type => ['image/jpeg','image/png']

					 
  validates_attachment_size :complogo, :less_than => 5.megabytes
   def check_complogo
	if complogo.file?
 	  g = Paperclip::Geometry.from_file(complogo.to_file(:original))
 	    errors.add(:complogo, "file size is too small")
	    (g.width > 170 && g.height > 170)
	  
	end
         
   end
  
  validates_presence_of :compaddress, :compsub_district, :compdistrict, :province,:message => "Please fill in the blank"
  
  validates_presence_of :comptel,:message => "Please fill in the blank"
  validates_format_of :comptel , :with => /\(?[0-9]{2,3}\)?[-.-](?:[0-9]{6,7})\Z/i , :allow_blank => true
#   validates_numericality_of :comptel, :allow_blank => true
#   validates_length_of :comptel, :in => 9..10, :allow_blank => true
  
  validates_format_of :compfax , :with => /\(?[0-9]{2,3}\)?[-.-](?:[0-9]{6,7})\Z/i , :allow_blank => true
  
  validates_presence_of :comptax,:message => "Please fill in the blank"
  validates_numericality_of :comptax, :allow_blank => true
  validates_length_of :comptax, :is => 10, :allow_blank => true
  
  validates_presence_of :compauthor_name,:message => "Please fill in the blank"
  
  validates_presence_of :compauthor_tel,:message => "Please fill in the blank"
  validates_format_of :compauthor_tel , :with => /\(?[0-9]{2,3}\)?[-.-](?:[0-9]{6,7})\Z/i , :allow_blank => true
#   validates_numericality_of :compauthor_tel, :allow_blank => true
#   validates_length_of :compauthor_tel, :in => 9..10, :allow_blank => true
  
  validates_attachment_content_type :compauthor_signature, :content_type => ['image/jpeg','image/png'] , :allow_blank => true
  validates_attachment_size :compauthor_signature, :less_than => 5.megabytes
  def check_compauthor_signature
	if compauthor_signature.file?
 	  g = Paperclip::Geometry.from_file(compauthor_signature.to_file(:original))
 	    errors.add(:compauthor_signature, "file size is too small")
	    (g.width > 110 && g.height > 110)
	  
	end
         
   end
  
end
