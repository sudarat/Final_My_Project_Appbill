module DocumentsHelper
  
  def new_customer
    link_to image_tag("/images/add1-24.png",:height => "17",:alt => "New customer",:title => "New customer"), new_customer_path 
#     link_to image_tag("/images/newc.jpg",:height => "17"), new_customer_path 
  end

  
  def paper_show
    if @quotation.paper.url != '/papers/original/missing.png'     
      @quotation.paper_file_name
      link_to @quotation.paper_file_name, @quotation.paper.url  
    end
  end
  
  #   index_document
  
  def nextt
    image_tag("index/icon-next.gif",:alt => "Next",:title => "Next document",:width => "25",:height => "25" ,:class=>"right")
  end
  
  def nextb
    image_tag("index/icon-next.gif",:alt => "Next",:title => "Next document",:width => "25",:height => "25" )
  end
  
  def nextt_non
    image_tag("index/icon-next2.gif",:alt => "Next",:width => "25",:height => "25" ,:class=>"right")
  end
  
  def nexti
    image_tag("index/icon-next.gif",:alt => "Next",:title => "New invoice",:width => "25",:height => "25")
  end
  
  def edit
    image_tag("index/icon-edit.gif",:alt => "Edit",:title => "Edit",:width => "25",:height => "25" ,:class=>"right")
  end
  
  def edit_non
    image_tag("index/icon-edit2.gif",:width => "25",:height => "25",:class=>"right" )
  end
  
  def show  
    image_tag("index/icon-show.gif",:alt => "Show",:title => "Show",:width => "25",:height => "25" ,:class=>"right")
  end
  
  def complete  
    image_tag("index/icon-ok.png",:alt => "Complete",:title => "Complete",:width => "25",:height => "25")
  end
  
  def nonecomplete  
    image_tag("index/icon-none.png",:alt => "None Complete",:title => "None Complete",:width => "25px",:height => "25px")
  end
  
  def notspecified  
    image_tag("index/icon-none.png",:alt => "Not Specified",:title => "Not Specified",:width => "25",:height => "25")
  end
  
  def approve  
    image_tag("index/icon-ok.png",:alt => "Approve",:title => "Approve",:width => "25",:height => "25")
  end
  
  def reject  
    image_tag("index/icon-none.png",:alt => "Reject",:title => "Reject",:width => "25",:height => "25")
  end
  
  def wait 
    image_tag("index/icon-wait.png",:alt => "Waiting...",:title => "Waiting...",:width => "25",:height => "25")
  end
  
  def ready  
    image_tag("index/icon-ok.png",:alt => "Ready",:title => "Ready",:width => "25",:height => "25")
  end
  
  def cancel  
    image_tag("index/icon-none.png",:alt => "Cancel",:title => "Cancel",:width => "25",:height => "25")
  end
  
  def paid  
    image_tag("index/icon-ok.png",:alt => "Paid",:title => "Paid",:width => "25",:height => "25")
  end
  
  def notpaid  
    image_tag("index/icon-none.png",:alt => "Not paid",:title => "Not paid",:width => "25",:height => "25")
  end
  
  def empty  
    image_tag("index/empty.png",:width => "25px",:height => "25px")
  end
  
  def new_q
    image_tag("/images/index/newquotation1.jpg",:alt => "New Quotation",:title => "New Quotation",:onmouseover =>"this.src='/images/index/newquotation2.jpg';" ,:onmouseout => "this.src='/images/index/newquotation1.jpg';" ,:class=>"round")
  end
  
  def new_r
    image_tag("/images/index/newreceipt1.jpg",:alt => "New Receipt",:title => "New Receipt",:onmouseover =>"this.src='/images/index/newreceipt2.jpg';" ,:onmouseout => "this.src='/images/index/newreceipt1.jpg';" ,:class=>"round")
  end
  
  def allm
    if (request.url)["wait"] == nil && (request.url)["complete"] == nil && (request.url)["notcomplete"] == nil
	image_tag("/images/index/all2.jpg",:alt => "All",:title => "All",:onmouseover =>"this.src='/images/index/all2.jpg';" ,:onmouseout => "this.src='/images/index/all2.jpg';" ,:class=>"roundl")
    else
      image_tag("/images/index/all1.jpg",:alt => "All",:title => "All",:onmouseover =>"this.src='/images/index/all2.jpg';" ,:onmouseout => "this.src='/images/index/all1.jpg';" ,:class=>"roundl")
    end
  end
  
  def waitm
    if (request.url)["wait"] == nil
      image_tag("/images/index/wait1.jpg",:alt => "Wait",:title => "Wait",:onmouseover =>"this.src='/images/index/wait2.jpg';" ,:onmouseout => "this.src='/images/index/wait1.jpg';")
    else
      image_tag("/images/index/wait2.jpg",:alt => "Wait",:title => "Wait",:onmouseover =>"this.src='/images/index/wait2.jpg';" ,:onmouseout => "this.src='/images/index/wait2.jpg';")
    end  
  end
  
  def notcompletem
    if (request.url)["notcomplete"] == nil && (request.url)["twait"] == nil && (request.url)["rwait"] == nil 
      image_tag("/images/index/notcomplete1.jpg",:alt => "Not Complete",:title => "Not Complete",:onmouseover =>"this.src='/images/index/notcomplete2.jpg';" ,:onmouseout => "this.src='/images/index/notcomplete1.jpg';")
    else
      image_tag("/images/index/notcomplete2.jpg",:alt => "Not Complete",:title => "Not Complete",:onmouseover =>"this.src='/images/index/notcomplete2.jpg';" ,:onmouseout => "this.src='/images/index/notcomplete2.jpg';")
    end
  end
    
  def completem
    if (request.url)["dcomplete"] != nil
      image_tag("/images/index/complete2.jpg",:alt => "Complete",:title => "Complete",:onmouseover =>"this.src='/images/index/complete2.jpg';" ,:onmouseout => "this.src='/images/index/complete2.jpg';",:class=>"roundr")
    else if (request.url)["qcomplete"] != nil
	  image_tag("/images/index/complete2.jpg",:alt => "Complete",:title => "Complete",:onmouseover =>"this.src='/images/index/complete2.jpg';" ,:onmouseout => "this.src='/images/index/complete2.jpg';",:class=>"roundr")
	 else if (request.url)["icomplete"] != nil
		image_tag("/images/index/complete2.jpg",:alt => "Complete",:title => "Complete",:onmouseover =>"this.src='/images/index/complete2.jpg';" ,:onmouseout => "this.src='/images/index/complete2.jpg';",:class=>"roundr")
	      else if (request.url)["bcomplete"] != nil
		    image_tag("/images/index/complete2.jpg",:alt => "Complete",:title => "Complete",:onmouseover =>"this.src='/images/index/complete2.jpg';" ,:onmouseout => "this.src='/images/index/complete2.jpg';",:class=>"roundr")
		   else if (request.url)["btcomplete"] != nil
			  image_tag("/images/index/complete2.jpg",:alt => "Complete",:title => "Complete",:onmouseover =>"this.src='/images/index/complete2.jpg';" ,:onmouseout => "this.src='/images/index/complete2.jpg';",:class=>"roundr")
			else if (request.url)["rcomplete"] != nil
			      image_tag("/images/index/complete2.jpg",:alt => "Complete",:title => "Complete",:onmouseover =>"this.src='/images/index/complete2.jpg';" ,:onmouseout => "this.src='/images/index/complete2.jpg';",:class=>"roundr")
			     else 
			      image_tag("/images/index/complete1.jpg",:alt => "Complete",:title => "Complete",:onmouseover =>"this.src='/images/index/complete2.jpg';" ,:onmouseout => "this.src='/images/index/complete1.jpg';",:class=>"roundr")
			     end
			end
		   end
	      end
	 end
    end
  end
  
  def deliverm
    if (request.url)["tcomplete"] != nil
      image_tag("/images/index/complete2.jpg",:alt => "Deliver",:title => "Deliver",:onmouseover =>"this.src='/images/index/complete2.jpg';" ,:onmouseout => "this.src='/images/index/complete2.jpg';",:class=>"roundr")
    else if (request.url)["rcomplete"] != nil
	  image_tag("/images/index/complete2.jpg",:alt => "Deliver",:title => "Deliver",:onmouseover =>"this.src='/images/index/complete2.jpg';" ,:onmouseout => "this.src='/images/index/complete2.jpg';",:class=>"roundr")
	 else  
	  image_tag("/images/index/complete1.jpg",:alt => "Deliver",:title => "Deliver",:onmouseover =>"this.src='/images/index/complete2.jpg';" ,:onmouseout => "this.src='/images/index/complete1.jpg';",:class=>"roundr")
	 end
    end
  end
  
  def newbill
    image_tag("/images/index/newbill1.jpg",:alt => "New Bill",:title => "New Bill",:onmouseover =>"this.src='/images/index/newbill2.jpg';" ,:onmouseout => "this.src='/images/index/newbill1.jpg';",:class=>"round")
  end
  
  def newbilltax
    image_tag("/images/index/newbillandtaxinvoice1.jpg",:alt => "New Bill and taxinvoice",:title => "New Bill and taxinvoice",:onmouseover =>"this.src='/images/index/newbillandtaxinvoice2.jpg';" ,:onmouseout => "this.src='/images/index/newbillandtaxinvoice1.jpg';",:class=>"round")
  end
  
  def printicon
    image_tag("/images/index/icon-print.jpeg",:alt => "Print",:width => "25px",:height => "25px")
  end
  
  def printr
    image_tag("/images/index/pr.jpg",:alt => "Print",:width => "25px",:height => "25px")
  end
  
  def printb
    image_tag("/images/index/pb.jpg",:alt => "Print",:width => "25px",:height => "25px")
  end
  
  def printw
    image_tag("/images/index/pw.jpg",:alt => "Print",:width => "25px",:height => "25px")
  end
  
# 
  
  
  
end
