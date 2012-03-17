module CustomersHelper
  
  def del
    image_tag("index/icon-delete.gif",:alt => "Delete",:title => "Delete",:width => "25",:height => "25" ,:class=>"right")
  end
  
  def new_c
    image_tag("/images/index/newcustomer1.jpg",:alt => "New Customer",:title => "New Customer",:onmouseover =>"this.src='/images/index/newcustomer2.jpg';" ,:onmouseout => "this.src='/images/index/newcustomer1.jpg';" ,:class=>"round")
  end
  
end
