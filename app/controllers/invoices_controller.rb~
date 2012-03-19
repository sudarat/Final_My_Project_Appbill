class InvoicesController < ApplicationController 
  helper_method :run_docnumber, :sort_column, :sort_direction
  # GET /invoices
  # GET /invoices.xml
  def index
    @invoices = Invoice.all
    @invoices.each do |invoice|
      if invoice.cancel==false && invoice.approve == false
	if Date.today.strftime("%d-%m-%Y")==invoice.doc_date.strftime("%d-%m-%Y")
	  invoice.approve=nil
	  invoice.cancel=true
	  @items=Item.find(:all, :conditions => { :invoice_id => invoice.id })
   	  @items.each do |item|
		@i = Item.new 
		@i.description = item.description
		@i.quantity = item.quantity
		@i.unit_price = item.unit_price
		@i.invoice_id = item.invoice_id
		@i.save

   	  	item.invoice_id = nil  #
   		item.update_attributes(params[:item])
   	  end
	  invoice.update_attributes(params[invoice])
	  @quotation = Quotation.find(invoice.ref_id)  
	  @quotation.complete = 'false'
	  @quotation.update_attributes(params[:quotation])
	end
	if Date.today.year==invoice.doc_date.year && Date.today.month>invoice.doc_date.month
	  invoice.approve=nil
	  invoice.cancel=true
	  @items=Item.find(:all, :conditions => { :invoice_id => invoice.id })
   	  @items.each do |item|
		@i = Item.new 
		@i.description = item.description
		@i.quantity = item.quantity
		@i.unit_price = item.unit_price
		@i.invoice_id = item.invoice_id
		@i.save
		
   	  	item.invoice_id = nil  #
   		item.update_attributes(params[:item])
   	  end
	  invoice.update_attributes(params[invoice])
	  @quotation = Quotation.find(invoice.ref_id)  
	  @quotation.complete = 'false'
	  @quotation.update_attributes(params[:quotation])
	end
	if Date.today.year==invoice.doc_date.year && Date.today.month==invoice.doc_date.month && Date.today.day>invoice.doc_date.day
	  invoice.approve=nil
	  invoice.cancel=true
	  @items=Item.find(:all, :conditions => { :invoice_id => invoice.id })
   	  @items.each do |item|
		@i = Item.new 
		@i.description = item.description
		@i.quantity = item.quantity
		@i.unit_price = item.unit_price
		@i.invoice_id = item.invoice_id
		@i.save
		
   	  	item.invoice_id = nil  #
   		item.update_attributes(params[:item])
   	  end
	  invoice.update_attributes(params[invoice])
	  @quotation = Quotation.find(invoice.ref_id)  
	  @quotation.complete = 'false'
	  @quotation.update_attributes(params[:quotation])
	end  
      end  
    end
    
#     @invoices = Invoice.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
    
    
    if (params[:col] == '1')
      if (params[:sort] == 'custname' && params[:direction]=='asc') 
	 @invoices = Invoice.joins(:customer).searchcustname(params[:search]).order('custname' + ' ' + 'asc').paginate(:per_page => 15, :page => params[:page])
      else if (params[:sort] == 'custname' && params[:direction]=='desc')
	     @invoices = Invoice.joins(:customer).searchcustname(params[:search]).order('custname' + ' ' + 'desc').paginate(:per_page => 15, :page => params[:page])
	  else
	     @invoices = Invoice.joins(:customer).searchcustname(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
	  end
      end
#       @invoices = Invoice.joins(:customer).searchcustname(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
    else if (params[:col] == '2')
	    if (params[:sort] == 'custname' && params[:direction]=='asc') 
	      @invoices = Invoice.joins(:customer).searchtitle(params[:search]).order('custname' + ' ' + 'asc').paginate(:per_page => 15, :page => params[:page])
	  else if (params[:sort] == 'custname' && params[:direction]=='desc')
		  @invoices = Invoice.joins(:customer).searchtitle(params[:search]).order('custname' + ' ' + 'desc').paginate(:per_page => 15, :page => params[:page])
	       else
		  @invoices = Invoice.joins(:customer).searchtitle(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
	       end
	  end
      
# 	    @invoices = Invoice.joins(:customer).searchtitle(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
	 else
	    if (params[:sort] == 'custname' && params[:direction]=='asc') 
	      @invoices = Invoice.joins(:customer).search(params[:search]).order('custname' + ' ' + 'asc').paginate(:per_page => 15, :page => params[:page])
	    else if (params[:sort] == 'custname' && params[:direction]=='desc')
		    @invoices = Invoice.joins(:customer).search(params[:search]).order('custname' + ' ' + 'desc').paginate(:per_page => 15, :page => params[:page])
		 else
		    @invoices = Invoice.joins(:customer).search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
		 end
	    end
# 	    @invoices = Invoice.joins(:customer).search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
	 end
    end
    
    cookies.delete :back_doc
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @invoices }
      format.json  { render :json => @invoices }
    end
  end

  # GET /invoices/1
  # GET /invoices/1.xml
  def show
    @invoice = Invoice.find(params[:id])
    #@item = @invoice.ref_id
    @quotation = Quotation.find(@invoice.ref_id)  
#    ถ้า ยกเลิกใบส่งของ ไอดีใบส่งของของไอเทมนั้นจะถูกลบไปด้วย 
     @comp=0
    if @invoice.complete
      @bill = Bill.where(:ref_id => @invoice.id)
      @billtaxinvoice = Billtaxinvoice.where(:ref_id => @invoice.id)
    end
    
    cookies.delete :invoice_id   
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @invoice }
      format.json  { render :json => @invoice }
    end
  end

  # GET /invoice/new
  # GET /invoice/new.xml
  def new
    @quotation = Quotation.find(cookies[:quotation_id])
    @invoice = Invoice.new
    run_docnumber
    default_cancel
    @invoice.tax = @quotation.tax
    @invoice.doc_date= Date.today.tomorrow
    @invoice.approve=false
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @invoice }
      format.json  { render :json => @invoice }
    end
  end

  # GET /invoices/1/edit
  def edit
    @invoice = Invoice.find(params[:id])
    @quotation = Quotation.find(@invoice.ref_id)
  end

  # POST /invoices
  # POST /invoices.xml
  def create
    @quotation = Quotation.find(cookies[:quotation_id])
    @invoice = Invoice.new(params[:invoice])
    @invoice.ref_id = @quotation.id
    @invoice.title = @quotation.title
    @invoice.customer = @quotation.customer
    @invoice.complete = false
    @invoice.approve=false
    @invoice.tax = @quotation.tax
    default_cancel
    run_docnumber
    respond_to do |format|
      if @invoice.save
	if (@invoice.doc_date==Date.today)
	  @invoice.destroy
	  format.html { render :action => "new" }
	else
	  format.html { cookies.delete :quotation_id
			redirect_to(manageitem_invoice_path(@invoice), :notice => 'Invoice was successfully created.') }     
	  format.xml  { render :xml => @invoice, :status => :created, :location => @invoice }
	end
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @invoice.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /invoices/1
  # PUT /invoices/1.xml
  def update
    @invoice = Invoice.find(params[:id])
    @quotation = Quotation.find(@invoice.ref_id)
    respond_to do |format|
      if @invoice.update_attributes(params[:invoice])
        format.html { if @invoice.cancel
			@items=Item.find(:all, :conditions => { :invoice_id => @invoice.id })
			@items.each do |item|
			  @i = Item.new 
			  @i.description = item.description
			  @i.quantity = item.quantity
			  @i.unit_price = item.unit_price
			  @i.invoice_id = item.invoice_id
			  @i.save

			  item.invoice_id = nil  #
			  item.update_attributes(params[:item])		
			end	            
			redirect_to(@invoice, :notice => 'Invoice was successfully updated.')
	              else if @invoice.approve==true
			      redirect_to(@invoice, :notice => 'Invoice was successfully updated.')
			   else
			      redirect_to(manageitem_invoice_path(@invoice), :notice => 'Invoice was successfully updated.')
			   end
		      end }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @invoice.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /invoices/1
  # DELETE /invoices/1.xml
  def destroy
    @invoice = Invoice.find(params[:id])
    @items=Item.find(:all, :conditions => { :invoice_id => @invoice.id })
			@items.each do |item|
			  @i = Item.new 
			  @i.description = item.description
			  @i.quantity = item.quantity
			  @i.unit_price = item.unit_price
			  @i.invoice_id = item.invoice_id
			  @i.save

			  item.invoice_id = nil  #
			  item.update_attributes(params[:item])		
			end	            
    # set invoice_id ของแต่ละ item ให้เปน 0
    @invoice.destroy

    respond_to do |format|
      format.html { redirect_to(invoices_url) }
      format.xml  { head :ok }
    end
  end
  
  def manageitem
    @invoice = Invoice.find(params[:id])
    @quotation = Quotation.find(@invoice.ref_id)
    @comp = 0 
  end
  
  def printred
    @company = Company.first
    @invoice = Invoice.find(params[:id])
    render :layout => 'print'
  end
  
  def printwhite
    @company = Company.first
    @invoice = Invoice.find(params[:id])
    render :layout => 'print'
  end
  
  def printblue
    @company = Company.first
    @invoice = Invoice.find(params[:id])
    render :layout => 'print'
  end
  
  def changedoc
    @company = Company.first
    @invoice = Invoice.find(params[:id])
#     render :layout => 'print'
  end
  
  def nextbill
    @invoice = Invoice.find(params[:id])
    cookies[:invoice_id] = @invoice.id
    redirect_to(new_bill_path)
  end
  
  def nextbilltaxinvoice
    @invoice = Invoice.find(params[:id])
    cookies[:invoice_id] = @invoice.id
    redirect_to(new_billtaxinvoice_path)
  end
  
  def iwait
    @invoices = Invoice.all
    @invoices.each do |invoice|
      if invoice.cancel==false && invoice.approve == false
	if Date.today.strftime("%d-%m-%Y")==invoice.doc_date.strftime("%d-%m-%Y")
	  invoice.cancel=true
	  @items=Item.find(:all, :conditions => { :invoice_id => invoice.id })
   	  @items.each do |item|
		@i = Item.new 
		@i.description = item.description
		@i.quantity = item.quantity
		@i.unit_price = item.unit_price
		@i.invoice_id = item.invoice_id
		@i.save

   	  	item.invoice_id = nil  #
   		item.update_attributes(params[:item])
   	  end
	  @quotation = Quotation.find(invoice.ref_id)  
	  @quotation.complete = 'false'
	  @quotation.update_attributes(params[:quotation])
	  invoice.update_attributes(params[invoice])
	end
	if Date.today.year==invoice.doc_date.year && Date.today.month>invoice.doc_date.month
	  invoice.doc_date=Date.today
	  invoice.cancel=true
	  @items=Item.find(:all, :conditions => { :invoice_id => invoice.id })
   	  @items.each do |item|
		@i = Item.new 
		@i.description = item.description
		@i.quantity = item.quantity
		@i.unit_price = item.unit_price
		@i.invoice_id = item.invoice_id
		@i.save
		
   	  	item.invoice_id = nil  #
   		item.update_attributes(params[:item])
   	  end
	  @quotation = Quotation.find(invoice.ref_id)  
	  @quotation.complete = 'false'
	  @quotation.update_attributes(params[:quotation])
	  invoice.update_attributes(params[invoice])
	end
	if Date.today.year==invoice.doc_date.year && Date.today.month==invoice.doc_date.month && Date.today.day>invoice.doc_date.day
	  invoice.doc_date=Date.today
	  invoice.cancel=true
	  @items=Item.find(:all, :conditions => { :invoice_id => invoice.id })
   	  @items.each do |item|
		@i = Item.new 
		@i.description = item.description
		@i.quantity = item.quantity
		@i.unit_price = item.unit_price
		@i.invoice_id = item.invoice_id
		@i.save
		
   	  	item.invoice_id = nil  #
   		item.update_attributes(params[:item])
   	  end
	  @quotation = Quotation.find(invoice.ref_id)  
	  @quotation.complete = 'false'
	  @quotation.update_attributes(params[:quotation])
	  invoice.update_attributes(params[invoice])
	end  
      end  
    end
    
#     @invoices = Invoice.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])

    if (params[:col] == '1')
      if (params[:sort] == 'custname' && params[:direction]=='asc') 
	 @invoices = Invoice.joins(:customer).searchcustname(params[:search]).order('custname' + ' ' + 'asc').where(:approve => false , :cancel => false ).paginate(:per_page => 15, :page => params[:page])
      else if (params[:sort] == 'custname' && params[:direction]=='desc')
	     @invoices = Invoice.joins(:customer).searchcustname(params[:search]).order('custname' + ' ' + 'desc').where(:approve => false , :cancel => false ).paginate(:per_page => 15, :page => params[:page])
	  else
	     @invoices = Invoice.joins(:customer).searchcustname(params[:search]).order(sort_column + ' ' + sort_direction).where(:approve => false , :cancel => false ).paginate(:per_page => 15, :page => params[:page])
	  end
      end
#       @invoices = Invoice.joins(:customer).searchcustname(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
    else if (params[:col] == '2')
	    if (params[:sort] == 'custname' && params[:direction]=='asc') 
	      @invoices = Invoice.joins(:customer).searchtitle(params[:search]).order('custname' + ' ' + 'asc').where(:approve => false , :cancel => false ).paginate(:per_page => 15, :page => params[:page])
	  else if (params[:sort] == 'custname' && params[:direction]=='desc')
		  @invoices = Invoice.joins(:customer).searchtitle(params[:search]).order('custname' + ' ' + 'desc').where(:approve => false , :cancel => false ).paginate(:per_page => 15, :page => params[:page])
	       else
		  @invoices = Invoice.joins(:customer).searchtitle(params[:search]).order(sort_column + ' ' + sort_direction).where(:approve => false , :cancel => false ).paginate(:per_page => 15, :page => params[:page])
	       end
	  end
# 	    @invoices = Invoice.joins(:customer).searchtitle(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
	 else
	    if (params[:sort] == 'custname' && params[:direction]=='asc') 
	      @invoices = Invoice.joins(:customer).search(params[:search]).order('custname' + ' ' + 'asc').where(:approve => false , :cancel => false ).paginate(:per_page => 15, :page => params[:page])
	    else if (params[:sort] == 'custname' && params[:direction]=='desc')
		    @invoices = Invoice.joins(:customer).search(params[:search]).order('custname' + ' ' + 'desc').where(:approve => false , :cancel => false ).paginate(:per_page => 15, :page => params[:page])
		 else
		    @invoices = Invoice.joins(:customer).search(params[:search]).order(sort_column + ' ' + sort_direction).where(:approve => false , :cancel => false ).paginate(:per_page => 15, :page => params[:page])
		 end
	    end
# 	    @invoices = Invoice.joins(:customer).search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
	 end
    end
    
#     @invoiceswait = Invoice.find(:all, :conditions => { :approve => false , :cancel => false})
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @invoices }
      format.json  { render :json => @invoices }
    end
  end
  
  def inotcomplete
    @invoices = Invoice.all
    @invoices.each do |invoice|
      if invoice.cancel==false && invoice.approve == false
	if Date.today.strftime("%d-%m-%Y")==invoice.doc_date.strftime("%d-%m-%Y")
	  invoice.cancel=true
	  @items=Item.find(:all, :conditions => { :invoice_id => invoice.id })
   	  @items.each do |item|
		@i = Item.new 
		@i.description = item.description
		@i.quantity = item.quantity
		@i.unit_price = item.unit_price
		@i.invoice_id = item.invoice_id
		@i.save

   	  	item.invoice_id = nil  #
   		item.update_attributes(params[:item])
   	  end
	  @quotation = Quotation.find(invoice.ref_id)  
	  @quotation.complete = 'false'
	  @quotation.update_attributes(params[:quotation])
	  invoice.update_attributes(params[invoice])
	end
	if Date.today.year==invoice.doc_date.year && Date.today.month>invoice.doc_date.month
	  invoice.doc_date=Date.today
	  invoice.cancel=true
	  @items=Item.find(:all, :conditions => { :invoice_id => invoice.id })
   	  @items.each do |item|
		@i = Item.new 
		@i.description = item.description
		@i.quantity = item.quantity
		@i.unit_price = item.unit_price
		@i.invoice_id = item.invoice_id
		@i.save
		
   	  	item.invoice_id = nil  #
   		item.update_attributes(params[:item])
   	  end
	  @quotation = Quotation.find(invoice.ref_id)  
	  @quotation.complete = 'false'
	  @quotation.update_attributes(params[:quotation])
	  invoice.update_attributes(params[invoice])
	end
	if Date.today.year==invoice.doc_date.year && Date.today.month==invoice.doc_date.month && Date.today.day>invoice.doc_date.day
	  invoice.doc_date=Date.today
	  invoice.cancel=true
	  @items=Item.find(:all, :conditions => { :invoice_id => invoice.id })
   	  @items.each do |item|
		@i = Item.new 
		@i.description = item.description
		@i.quantity = item.quantity
		@i.unit_price = item.unit_price
		@i.invoice_id = item.invoice_id
		@i.save
		
   	  	item.invoice_id = nil  #
   		item.update_attributes(params[:item])
   	  end
	  @quotation = Quotation.find(invoice.ref_id)  
	  @quotation.complete = 'false'
	  @quotation.update_attributes(params[:quotation])
	  invoice.update_attributes(params[invoice])
	end  
      end  
    end
    
#     @invoices = Invoice.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])

    if (params[:col] == '1')
      if (params[:sort] == 'custname' && params[:direction]=='asc') 
	 @invoices = Invoice.joins(:customer).searchcustname(params[:search]).order('custname' + ' ' + 'asc').where(:approve => true , :complete => false, :cancel => false ).paginate(:per_page => 15, :page => params[:page])
      else if (params[:sort] == 'custname' && params[:direction]=='desc')
	     @invoices = Invoice.joins(:customer).searchcustname(params[:search]).order('custname' + ' ' + 'desc').where(:approve => true , :complete => false, :cancel => false ).paginate(:per_page => 15, :page => params[:page])
	  else
	     @invoices = Invoice.joins(:customer).searchcustname(params[:search]).order(sort_column + ' ' + sort_direction).where(:approve => true , :complete => false, :cancel => false ).paginate(:per_page => 15, :page => params[:page])
	  end
      end
#       @invoices = Invoice.joins(:customer).searchcustname(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
    else if (params[:col] == '2')
	    if (params[:sort] == 'custname' && params[:direction]=='asc') 
	      @invoices = Invoice.joins(:customer).searchtitle(params[:search]).order('custname' + ' ' + 'asc').where(:approve => true , :complete => false, :cancel => false ).paginate(:per_page => 15, :page => params[:page])
	  else if (params[:sort] == 'custname' && params[:direction]=='desc')
		  @invoices = Invoice.joins(:customer).searchtitle(params[:search]).order('custname' + ' ' + 'desc').where(:approve => true , :complete => false, :cancel => false ).paginate(:per_page => 15, :page => params[:page])
	       else
		  @invoices = Invoice.joins(:customer).searchtitle(params[:search]).order(sort_column + ' ' + sort_direction).where(:approve => true , :complete => false, :cancel => false ).paginate(:per_page => 15, :page => params[:page])
	       end
	  end
# 	    @invoices = Invoice.joins(:customer).searchtitle(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
	 else
	    if (params[:sort] == 'custname' && params[:direction]=='asc') 
	      @invoices = Invoice.joins(:customer).search(params[:search]).order('custname' + ' ' + 'asc').where(:approve => true , :complete => false, :cancel => false ).paginate(:per_page => 15, :page => params[:page])
	    else if (params[:sort] == 'custname' && params[:direction]=='desc')
		    @invoices = Invoice.joins(:customer).search(params[:search]).order('custname' + ' ' + 'desc').where(:approve => true , :complete => false, :cancel => false ).paginate(:per_page => 15, :page => params[:page])
		 else
		    @invoices = Invoice.joins(:customer).search(params[:search]).order(sort_column + ' ' + sort_direction).where(:approve => true , :complete => false, :cancel => false ).paginate(:per_page => 15, :page => params[:page])
		 end
	    end
# 	    @invoices = Invoice.joins(:customer).search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
	 end
    end
    
#     @invoicesnotcomplete = Invoice.find(:all, :conditions => { :approve => true , :complete => false, :cancel => false})
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @invoices }
      format.json  { render :json => @invoices }
    end
  end
  
    def icomplete
    @invoices = Invoice.all
    @invoices.each do |invoice|
      if invoice.cancel==false && invoice.approve == false
	if Date.today.strftime("%d-%m-%Y")==invoice.doc_date.strftime("%d-%m-%Y")
	  invoice.cancel=true
	  @items=Item.find(:all, :conditions => { :invoice_id => invoice.id })
   	  @items.each do |item|
		@i = Item.new 
		@i.description = item.description
		@i.quantity = item.quantity
		@i.unit_price = item.unit_price
		@i.invoice_id = item.invoice_id
		@i.save

   	  	item.invoice_id = nil  #
   		item.update_attributes(params[:item])
   	  end
	  @quotation = Quotation.find(invoice.ref_id)  
	  @quotation.complete = 'false'
	  @quotation.update_attributes(params[:quotation])
	  invoice.update_attributes(params[invoice])
	end
	if Date.today.year==invoice.doc_date.year && Date.today.month>invoice.doc_date.month
	  invoice.doc_date=Date.today
	  invoice.cancel=true
	  @items=Item.find(:all, :conditions => { :invoice_id => invoice.id })
   	  @items.each do |item|
		@i = Item.new 
		@i.description = item.description
		@i.quantity = item.quantity
		@i.unit_price = item.unit_price
		@i.invoice_id = item.invoice_id
		@i.save
		
   	  	item.invoice_id = nil  #
   		item.update_attributes(params[:item])
   	  end
	  @quotation = Quotation.find(invoice.ref_id)  
	  @quotation.complete = 'false'
	  @quotation.update_attributes(params[:quotation])
	  invoice.update_attributes(params[invoice])
	end
	if Date.today.year==invoice.doc_date.year && Date.today.month==invoice.doc_date.month && Date.today.day>invoice.doc_date.day
	  invoice.doc_date=Date.today
	  invoice.cancel=true
	  @items=Item.find(:all, :conditions => { :invoice_id => invoice.id })
   	  @items.each do |item|
		@i = Item.new 
		@i.description = item.description
		@i.quantity = item.quantity
		@i.unit_price = item.unit_price
		@i.invoice_id = item.invoice_id
		@i.save
		
   	  	item.invoice_id = nil  #
   		item.update_attributes(params[:item])
   	  end
	  @quotation = Quotation.find(invoice.ref_id)  
	  @quotation.complete = 'false'
	  @quotation.update_attributes(params[:quotation])
	  invoice.update_attributes(params[invoice])
	end  
      end  
    end
    
#     @invoices = Invoice.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])

    if (params[:col] == '1')
      if (params[:sort] == 'custname' && params[:direction]=='asc') 
	 @invoices = Invoice.joins(:customer).searchcustname(params[:search]).order('custname' + ' ' + 'asc').where(:approve => true , :complete => true, :cancel => false).paginate(:per_page => 15, :page => params[:page])
      else if (params[:sort] == 'custname' && params[:direction]=='desc')
	     @invoices = Invoice.joins(:customer).searchcustname(params[:search]).order('custname' + ' ' + 'desc').where(:approve => true , :complete => true, :cancel => false).paginate(:per_page => 15, :page => params[:page])
	  else
	     @invoices = Invoice.joins(:customer).searchcustname(params[:search]).order(sort_column + ' ' + sort_direction).where(:approve => true , :complete => true, :cancel => false).paginate(:per_page => 15, :page => params[:page])
	  end
      end
#       @invoices = Invoice.joins(:customer).searchcustname(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
    else if (params[:col] == '2')
	    if (params[:sort] == 'custname' && params[:direction]=='asc') 
	      @invoices = Invoice.joins(:customer).searchtitle(params[:search]).order('custname' + ' ' + 'asc').where(:approve => true , :complete => true, :cancel => false).paginate(:per_page => 15, :page => params[:page])
	  else if (params[:sort] == 'custname' && params[:direction]=='desc')
		  @invoices = Invoice.joins(:customer).searchtitle(params[:search]).order('custname' + ' ' + 'desc').where(:approve => true , :complete => true, :cancel => false).paginate(:per_page => 15, :page => params[:page])
	       else
		  @invoices = Invoice.joins(:customer).searchtitle(params[:search]).order(sort_column + ' ' + sort_direction).where(:approve => true , :complete => true, :cancel => false).paginate(:per_page => 15, :page => params[:page])
	       end
	  end
# 	    @invoices = Invoice.joins(:customer).searchtitle(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
	 else
	    if (params[:sort] == 'custname' && params[:direction]=='asc') 
	      @invoices = Invoice.joins(:customer).search(params[:search]).order('custname' + ' ' + 'asc').where(:approve => true , :complete => true, :cancel => false).paginate(:per_page => 15, :page => params[:page])
	    else if (params[:sort] == 'custname' && params[:direction]=='desc')
		    @invoices = Invoice.joins(:customer).search(params[:search]).order('custname' + ' ' + 'desc').where(:approve => true , :complete => true, :cancel => false).paginate(:per_page => 15, :page => params[:page])
		 else
		    @invoices = Invoice.joins(:customer).search(params[:search]).order(sort_column + ' ' + sort_direction).where(:approve => true , :complete => true, :cancel => false).paginate(:per_page => 15, :page => params[:page])
		 end
	    end
# 	    @invoices = Invoice.joins(:customer).search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
	 end
    end
    
#     @invoicescomplete = Invoice.find(:all, :conditions => { :approve => true , :complete => true, :cancel => false})
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @invoices }
      format.json  { render :json => @invoices }
    end
  end

    private
  
  def run_docnumber
    y=(Time.now.year+543).to_s.split("25").last
      if Invoice.find(:all).empty?
	@invoice.doc_number = y+'0001'
      else if y != Invoice.last.doc_number[0..1]
	      @invoice.doc_number = y+'0001'
	   else
	      i = Invoice.last.doc_number
	      n = i[2..5].to_i+1 
	      if n<10 
		@invoice.doc_number = y+'000'+n.to_s 
	      else if n<100
		    @invoice.doc_number = y+'00'+n.to_s 
		   else if n<1000 
			  @invoice.doc_number = y+'0'+n.to_s 
			else if n<=9999
			       @invoice.doc_number = y+n.to_s 
			     else 
			       @invoice.doc_number = 'Do not create invoice !!!' 
			     end  
		        end
		   end
	      end 
	    end
       end 
  end
  
  def default_cancel
    @invoice.cancel = false
  end
  
  def sort_column
    Invoice.column_names.include?(params[:sort]) ? params[:sort] : "updated_at"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
  
  
end
