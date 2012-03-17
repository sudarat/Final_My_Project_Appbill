class Document < ActiveRecord::Base
  belongs_to :customer 

  scope :dwait, :conditions=>[
    if type = "Quotation"
      approve = nil
#     else  approve == false
    end
    ]
  
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
