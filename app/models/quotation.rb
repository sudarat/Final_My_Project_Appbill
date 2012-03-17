class Quotation < Document
  
  has_many :items
  has_attached_file :paper 
  

  
  
  validates_presence_of :doc_number, :customer, :title,:message => "please fill in the blank"
  
  scope :customer, joins(:customer).order("custname asc") # Just reference :comments
  scope :customerd, joins(:customer).order("custname desc") # Just reference :comments
  scope :cust, joins(:customer)
  
  validates_presence_of :detail,:if => :should_validate_detail?, :allow_blank => true
  def should_validate_detail?
    if detail == "<br>"
      errors.add(:detail, "please fill in the blank")
    end
  end
  
  validates_presence_of :terms,:message => "Please fill in the blank"
  validates_numericality_of :terms, :only_integer => true , :allow_blank => true , :greater_than => 0
  
  validates_presence_of :doc_date ,:message => "Please fill in the blank"
  validates_presence_of :doc_date,:if => :should_validate_date?,:message => "please fill in the blank"
  def should_validate_date?
    if doc_date == nil 
#        errors.add(:doc_date, "can't be blank")
    else if doc_date < Date.today && approve == nil
	  errors.add(:doc_date, "over time ago")
	 end
    end
  end
  
#   validates_attachment_content_type :paper , :content_type => 'application/pdf' , :allow_blank => true
  validates_attachment_content_type :paper , :content_type => ['application/pdf'], :allow_blank => true , :message => "is not PDF"
  validates_attachment_size :paper, :less_than => 20.megabytes
  


  
  def details_html
    html = ""
    
    items.each do |detail|
	html += "<tr valign=middle height=25>
		  <td class=bordertop borderright><font size=2>#{detail.description}</font></td> 
		  <td align= right  class=borderdetail ><font size=2>#{detail.quantity}</font></td> 
		  <td align= right class=borderdetail><font size=2><img src=/images/print/b.jpg , align=left>#{detail.unit_price.round(2)}</font></td> 
		  <td align= right class=bordertop borderleft><font size=2><img src=/images/print/b.jpg , align=left>#{(detail.unit_price*detail.quantity).round(2)}</font></td>
		 </tr>"
    end
    
    return html
  end
  
   def subtotal_html
    subtotal = 0
    
    items.each do |detail|
	subtotal += detail.unit_price*detail.quantity
    end
    
    return subtotal.round(2)
  end
  
  def tax_html
    tax = 0
    
    items.each do |detail|
	tax += detail.unit_price*detail.quantity
    end
    
    tax = (tax * 7)/100
    
    return tax.round(2)
  end
  
  def total_html
    total = 0
    
    items.each do |item|
	total += item.unit_price*item.quantity
    end
    
    total = total + ((total * 7)/100)
    
    return total.round(2)
  end
  
  def showcond
    quotations.each do |quotation|
      cond = quotation.condition
    end
    return cond
  end
  
  def self.search(search)
    if search
      where('title LIKE ?', "%#{search}%")
    else
      scoped
    end
  end
  
  def self.searchtitle(search)
    if search
      where('title LIKE ?', "%#{search}%")
    else
      scoped
    end
  end
  
  def self.searchcustname(search)
    if search
      where('custname LIKE ?', "%#{search}%")      
    else
      scoped
    end
  end
  
  
  
end