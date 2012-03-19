class DocumentsController < ApplicationController
  
  helper_method :sort_column, :sort_direction
  
  # GET /documents
  # GET /documents.xml
  def index
    if Company.find(:all).empty?
      redirect_to (new_company_path)
    else 
    @documents = Document.all
	
#     Auto update Date
    @documents.each do |document|
      if document.type=="Quotation"
      else if document.type=="Invoice"
	if document.cancel==false && document.approve == false
	if Date.today.strftime("%d-%m-%Y")==document.doc_date.strftime("%d-%m-%Y")
	  document.approve=nil
	  document.cancel=true
	  @items=Item.find(:all, :conditions => { :invoice_id => document.id })
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
	  document.update_attributes(params[document])
	  @quotation = Quotation.find(document.ref_id)  
	  @quotation.complete = 'false'
	  @quotation.update_attributes(params[:quotation])
	end
	if Date.today.year==document.doc_date.year && Date.today.month>document.doc_date.month
# 	  document.doc_date=Date.today
	  document.approve=nil
	  document.cancel=true
	  @items=Item.find(:all, :conditions => { :invoice_id => document.id })
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
	  document.update_attributes(params[document])
	  @quotation = Quotation.find(document.ref_id)  
	  @quotation.complete = 'false'
	  @quotation.update_attributes(params[:quotation])
	end
	if Date.today.year==document.doc_date.year && Date.today.month==document.doc_date.month && Date.today.day>document.doc_date.day
# 	  document.doc_date=Date.today
	  document.approve=nil
	  document.cancel=true
	  @items=Item.find(:all, :conditions => { :invoice_id => document.id })
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
	  document.update_attributes(params[document])
	  @quotation = Quotation.find(document.ref_id)  
	  @quotation.complete = 'false'
	  @quotation.update_attributes(params[:quotation])
	end  
      end  
      end
    end
    end
      
    @documents.each do |document|
      if document.type=="Quotation"
	if document.approve==nil && document.cancel==false
	  if Date.today.strftime("%d-%m-%Y")==document.doc_date.strftime("%d-%m-%Y")
	    document.cancel=true
	    document.approve=false
	    document.update_attributes(params[document])
	  end
	  if Date.today.year==document.doc_date.year && Date.today.month>document.doc_date.month
# 	    document.doc_date==Date.today
	    document.cancel=true
	    document.approve=false
	    document.update_attributes(params[document])
	  end
	  if Date.today.year==document.doc_date.year && Date.today.month==document.doc_date.month && Date.today.day>document.doc_date.day
# 	    document.doc_date==Date.today
	    document.cancel=true
	    document.approve=false 
	    document.update_attributes(params[document])
	  end
	end
      end
    end
    
    if (params[:col] == '1')
      if (params[:sort] == 'custname' && params[:direction]=='asc') 
	 @documents = Document.joins(:customer).searchcustname(params[:search]).order('custname' + ' ' + 'asc').paginate(:per_page => 15, :page => params[:page])
      else if (params[:sort] == 'custname' && params[:direction]=='desc')
	     @documents = Document.joins(:customer).searchcustname(params[:search]).order('custname' + ' ' + 'desc').paginate(:per_page => 15, :page => params[:page])
	  else
	     @documents = Document.joins(:customer).searchcustname(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
	  end
      end
#       @documents = Document.joins(:customer).searchcustname(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
    else if (params[:col] == '2')
	    if (params[:sort] == 'custname' && params[:direction]=='asc') 
	      @documents = Document.joins(:customer).searchtitle(params[:search]).order('custname' + ' ' + 'asc').paginate(:per_page => 15, :page => params[:page])
	  else if (params[:sort] == 'custname' && params[:direction]=='desc')
		  @documents = Document.joins(:customer).searchtitle(params[:search]).order('custname' + ' ' + 'desc').paginate(:per_page => 15, :page => params[:page])
	       else
		  @documents = Document.joins(:customer).searchtitle(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
	       end
	  end
      
# 	    @documents = Document.joins(:customer).searchtitle(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
	 else
	    if (params[:sort] == 'custname' && params[:direction]=='asc') 
	      @documents = Document.joins(:customer).search(params[:search]).order('custname' + ' ' + 'asc').paginate(:per_page => 15, :page => params[:page])
	    else if (params[:sort] == 'custname' && params[:direction]=='desc')
		    @documents = Document.joins(:customer).search(params[:search]).order('custname' + ' ' + 'desc').paginate(:per_page => 15, :page => params[:page])
		 else
		    @documents = Document.joins(:customer).search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
		 end
	    end
# 	    @documents = Document.joins(:customer).search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
	 end
    end
    
    cookies.delete :back_doc
    @comp=0
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @documents }
      format.json  { render :json => @documents }
    end
    end
  end

  # GET /documents/1
  # GET /documents/1.xml
  def show
    @document = Document.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @document }
      format.json  { render :json => @document }
    end
  end

  # GET /documents/new
  # GET /documents/new.xml
  def new
    @document = Document.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @document }
      format.json  { render :json => @document }
    end
  end

  # GET /documents/1/edit
  def edit
    @document = Document.find(params[:id])
    if @document.type == 'Quotation'
      @quotation = @document      
      redirect_to(edit_quotation_path(@quotation))
    else if @document.type == 'Invoice' 
	    @invoice = @document
	    redirect_to(edit_invoice_path(@invoice))
	 end
    end
  end 
   
  # POST /documents
  # POST /documents.xml
  def create
    @document = Document.new(params[:document])

    respond_to do |format|
      if @document.save
        format.html { redirect_to(@document, :notice => 'Document was successfully created.') }
        format.xml  { render :xml => @document, :status => :created, :location => @document }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @document.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /documents/1
  # PUT /documents/1.xml
  def update
    @document = Document.find(params[:id])

    respond_to do |format|
      if @document.update_attributes(params[:document])
        format.html { redirect_to(@document, :notice => 'Document was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @document.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /documents/1
  # DELETE /documents/1.xml
  def destroy
    @document = Document.find(params[:id])
    @document.destroy

    respond_to do |format|
      format.html { redirect_to(documents_url) }
      format.xml  { head :ok }
    end
  end
  
  def dwait
    if Company.find(:all).empty?
      redirect_to (new_company_path)
    else 
    @documents = Document.all
	
#     Auto update Date
    @documents.each do |document|
      if document.type=="Quotation"
      else if document.type=="Invoice"
	if document.cancel==false && document.approve == false
	if Date.today.strftime("%d-%m-%Y")==document.doc_date.strftime("%d-%m-%Y")
	  document.approve=nil
	  document.cancel=true
	  @items=Item.find(:all, :conditions => { :invoice_id => document.id })
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
	  document.update_attributes(params[document])
	  @quotation = Quotation.find(document.ref_id)  
	  @quotation.complete = 'false'
	  @quotation.update_attributes(params[:quotation])
	end
	if Date.today.year==document.doc_date.year && Date.today.month>document.doc_date.month
# 	  document.doc_date=Date.today
	  document.approve=nil
	  document.cancel=true
	  @items=Item.find(:all, :conditions => { :invoice_id => document.id })
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
	  document.update_attributes(params[document])
	  @quotation = Quotation.find(document.ref_id)  
	  @quotation.complete = 'false'
	  @quotation.update_attributes(params[:quotation])
	end
	if Date.today.year==document.doc_date.year && Date.today.month==document.doc_date.month && Date.today.day>document.doc_date.day
# 	  document.doc_date=Date.today
	  document.approve=nil
	  document.cancel=true
	  @items=Item.find(:all, :conditions => { :invoice_id => document.id })
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
	  document.update_attributes(params[document])
	  @quotation = Quotation.find(document.ref_id)  
	  @quotation.complete = 'false'
	  @quotation.update_attributes(params[:quotation])
	end  
      end  
      end
    end
    end
      
    @documents.each do |document|
      if document.type=="Quotation"
	if document.approve==nil && document.cancel==false
	  if Date.today.strftime("%d-%m-%Y")==document.doc_date.strftime("%d-%m-%Y")
	    document.cancel=true
	    document.approve=false
	    document.update_attributes(params[document])
	  end
	  if Date.today.year==document.doc_date.year && Date.today.month>document.doc_date.month
# 	    document.doc_date==Date.today
	    document.cancel=true
	    document.approve=false
	    document.update_attributes(params[document])
	  end
	  if Date.today.year==document.doc_date.year && Date.today.month==document.doc_date.month && Date.today.day>document.doc_date.day
# 	    document.doc_date==Date.today
	    document.cancel=true
	    document.approve=false 
	    document.update_attributes(params[document])
	  end
	end
      end
    end
    
    if (params[:col] == '1')
      if (params[:sort] == 'custname' && params[:direction]=='asc') 
	 @documents = Document.joins(:customer).searchcustname(params[:search]).order('custname' + ' ' + 'asc').where('(type = ? AND approve IS NULL) OR ((type = ? OR type = ?) AND approve =? AND cancel = ?) OR ((type = ? OR type = ? OR type = ?) AND complete =? AND cancel = ?) ' ,"Quotation","Invoice","Bill",false,false,"Taxinvoice","Billtaxinvoice","Receipt",false,false).paginate(:per_page => 15, :page => params[:page])
      else if (params[:sort] == 'custname' && params[:direction]=='desc')
	     @documents = Document.joins(:customer).searchcustname(params[:search]).order('custname' + ' ' + 'desc').where('(type = ? AND approve IS NULL) OR ((type = ? OR type = ?) AND approve =? AND cancel = ?) OR ((type = ? OR type = ? OR type = ?) AND complete =? AND cancel = ?) ' ,"Quotation","Invoice","Bill",false,false,"Taxinvoice","Billtaxinvoice","Receipt",false,false).paginate(:per_page => 15, :page => params[:page])
	  else
	     @documents = Document.joins(:customer).searchcustname(params[:search]).order(sort_column + ' ' + sort_direction).where('(type = ? AND approve IS NULL) OR ((type = ? OR type = ?) AND approve =? AND cancel = ?) OR ((type = ? OR type = ? OR type = ?) AND complete =? AND cancel = ?) ' ,"Quotation","Invoice","Bill",false,false,"Taxinvoice","Billtaxinvoice","Receipt",false,false).paginate(:per_page => 15, :page => params[:page])
	  end
      end
#       @documents = Document.joins(:customer).searchcustname(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
    else if (params[:col] == '2')
	    if (params[:sort] == 'custname' && params[:direction]=='asc') 
	      @documents = Document.joins(:customer).searchtitle(params[:search]).order('custname' + ' ' + 'asc').where('(type = ? AND approve IS NULL) OR ((type = ? OR type = ?) AND approve =? AND cancel = ?) OR ((type = ? OR type = ? OR type = ?) AND complete =? AND cancel = ?) ' ,"Quotation","Invoice","Bill",false,false,"Taxinvoice","Billtaxinvoice","Receipt",false,false).paginate(:per_page => 15, :page => params[:page])
	  else if (params[:sort] == 'custname' && params[:direction]=='desc')
		  @documents = Document.joins(:customer).searchtitle(params[:search]).order('custname' + ' ' + 'desc').where('(type = ? AND approve IS NULL) OR ((type = ? OR type = ?) AND approve =? AND cancel = ?) OR ((type = ? OR type = ? OR type = ?) AND complete =? AND cancel = ?) ' ,"Quotation","Invoice","Bill",false,false,"Taxinvoice","Billtaxinvoice","Receipt",false,false).paginate(:per_page => 15, :page => params[:page])
	       else
		  @documents = Document.joins(:customer).searchtitle(params[:search]).order(sort_column + ' ' + sort_direction).where('(type = ? AND approve IS NULL) OR ((type = ? OR type = ?) AND approve =? AND cancel = ?) OR ((type = ? OR type = ? OR type = ?) AND complete =? AND cancel = ?) ' ,"Quotation","Invoice","Bill",false,false,"Taxinvoice","Billtaxinvoice","Receipt",false,false).paginate(:per_page => 15, :page => params[:page])
	       end
	  end
      
# 	    @documents = Document.joins(:customer).searchtitle(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
	 else
	    if (params[:sort] == 'custname' && params[:direction]=='asc') 
	      @documents = Document.joins(:customer).search(params[:search]).order('custname' + ' ' + 'asc').where('(type = ? AND approve IS NULL) OR ((type = ? OR type = ?) AND approve =? AND cancel = ?) OR ((type = ? OR type = ? OR type = ?) AND complete =? AND cancel = ?) ' ,"Quotation","Invoice","Bill",false,false,"Taxinvoice","Billtaxinvoice","Receipt",false,false).paginate(:per_page => 15, :page => params[:page])
	    else if (params[:sort] == 'custname' && params[:direction]=='desc')
		    @documents = Document.joins(:customer).search(params[:search]).order('custname' + ' ' + 'desc').where('(type = ? AND approve IS NULL) OR ((type = ? OR type = ?) AND approve =? AND cancel = ?) OR ((type = ? OR type = ? OR type = ?) AND complete =? AND cancel = ?) ' ,"Quotation","Invoice","Bill",false,false,"Taxinvoice","Billtaxinvoice","Receipt",false,false).paginate(:per_page => 15, :page => params[:page])
		 else
 		    @documents = Document.joins(:customer).search(params[:search]).order(sort_column + ' ' + sort_direction).where('(type = ? AND approve IS NULL) OR ((type = ? OR type = ?) AND approve =? AND cancel = ?) OR ((type = ? OR type = ? OR type = ?) AND complete =? AND cancel = ?) ' ,"Quotation","Invoice","Bill",false,false,"Taxinvoice","Billtaxinvoice","Receipt",false,false).paginate(:per_page => 15, :page => params[:page])

		 end
	    end
	 end
    end
    
    @comp=0
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @documents }
      format.json  { render :json => @documents }
    end
    end
  end
  
  def dcomplete
    if Company.find(:all).empty?
      redirect_to (new_company_path)
    else 
    @documents = Document.all
	
#     Auto update Date
    @documents.each do |document|
      if document.type=="Quotation"
      else if document.type=="Invoice"
	if document.cancel==false && document.approve == false
	if Date.today.strftime("%d-%m-%Y")==document.doc_date.strftime("%d-%m-%Y")
	  document.approve=nil
	  document.cancel=true
	  @items=Item.find(:all, :conditions => { :invoice_id => document.id })
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
	  document.update_attributes(params[document])
	  @quotation = Quotation.find(document.ref_id)  
	  @quotation.complete = 'false'
	  @quotation.update_attributes(params[:quotation])
	end
	if Date.today.year==document.doc_date.year && Date.today.month>document.doc_date.month
# 	  document.doc_date=Date.today
	  document.approve=nil
	  document.cancel=true
	  @items=Item.find(:all, :conditions => { :invoice_id => document.id })
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
	  document.update_attributes(params[document])
	  @quotation = Quotation.find(document.ref_id)  
	  @quotation.complete = 'false'
	  @quotation.update_attributes(params[:quotation])
	end
	if Date.today.year==document.doc_date.year && Date.today.month==document.doc_date.month && Date.today.day>document.doc_date.day
# 	  document.doc_date=Date.today
	  document.approve=nil
	  document.cancel=true
	  @items=Item.find(:all, :conditions => { :invoice_id => document.id })
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
	  document.update_attributes(params[document])
	  @quotation = Quotation.find(document.ref_id)  
	  @quotation.complete = 'false'
	  @quotation.update_attributes(params[:quotation])
	end  
      end  
      end
    end
    end
      
    @documents.each do |document|
      if document.type=="Quotation"
	if document.approve==nil && document.cancel==false
	  if Date.today.strftime("%d-%m-%Y")==document.doc_date.strftime("%d-%m-%Y")
	    document.cancel=true
	    document.approve=false
	    document.update_attributes(params[document])
	  end
	  if Date.today.year==document.doc_date.year && Date.today.month>document.doc_date.month
# 	    document.doc_date==Date.today
	    document.cancel=true
	    document.approve=false
	    document.update_attributes(params[document])
	  end
	  if Date.today.year==document.doc_date.year && Date.today.month==document.doc_date.month && Date.today.day>document.doc_date.day
# 	    document.doc_date==Date.today
	    document.cancel=true
	    document.approve=false 
	    document.update_attributes(params[document])
	  end
	end
      end
    end
    
    if (params[:col] == '1')
      if (params[:sort] == 'custname' && params[:direction]=='asc') 
	 @documents = Document.joins(:customer).searchcustname(params[:search]).order('custname' + ' ' + 'asc').where(:complete => true,:cancel => false).paginate(:per_page => 15, :page => params[:page])
      else if (params[:sort] == 'custname' && params[:direction]=='desc')
	     @documents = Document.joins(:customer).searchcustname(params[:search]).order('custname' + ' ' + 'desc').where(:complete => true,:cancel => false).paginate(:per_page => 15, :page => params[:page])
	  else
	     @documents = Document.joins(:customer).searchcustname(params[:search]).order(sort_column + ' ' + sort_direction).where(:complete => true,:cancel => false).paginate(:per_page => 15, :page => params[:page])
	  end
      end
#       @documents = Document.joins(:customer).searchcustname(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
    else if (params[:col] == '2')
	    if (params[:sort] == 'custname' && params[:direction]=='asc') 
	      @documents = Document.joins(:customer).searchtitle(params[:search]).order('custname' + ' ' + 'asc').where(:complete => true,:cancel => false).paginate(:per_page => 15, :page => params[:page])
	  else if (params[:sort] == 'custname' && params[:direction]=='desc')
		  @documents = Document.joins(:customer).searchtitle(params[:search]).order('custname' + ' ' + 'desc').where(:complete => true,:cancel => false).paginate(:per_page => 15, :page => params[:page])
	       else
		  @documents = Document.joins(:customer).searchtitle(params[:search]).order(sort_column + ' ' + sort_direction).where(:complete => true,:cancel => false).paginate(:per_page => 15, :page => params[:page])
	       end
	  end
      
# 	    @documents = Document.joins(:customer).searchtitle(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
	 else
	    if (params[:sort] == 'custname' && params[:direction]=='asc') 
	      @documents = Document.joins(:customer).search(params[:search]).order('custname' + ' ' + 'asc').where(:complete => true,:cancel => false).paginate(:per_page => 15, :page => params[:page])
	    else if (params[:sort] == 'custname' && params[:direction]=='desc')
		    @documents = Document.joins(:customer).search(params[:search]).order('custname' + ' ' + 'desc').where(:complete => true,:cancel => false).paginate(:per_page => 15, :page => params[:page])
		 else
		    @documents = Document.joins(:customer).search(params[:search]).order(sort_column + ' ' + sort_direction).where(:complete => true,:cancel => false).paginate(:per_page => 15, :page => params[:page])
		 end
	    end
# 	    @documents = Document.joins(:customer).search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
	 end
    end
    
    @comp=0
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @documents }
      format.json  { render :json => @documents }
    end
    end
  end
  
  def dnotcomplete
    if Company.find(:all).empty?
      redirect_to (new_company_path)
    else 
    @documents = Document.all
	
#     Auto update Date
    @documents.each do |document|
      if document.type=="Quotation"
      else if document.type=="Invoice"
	if document.cancel==false && document.approve == false
	if Date.today.strftime("%d-%m-%Y")==document.doc_date.strftime("%d-%m-%Y")
	  document.approve=nil
	  document.cancel=true
	  @items=Item.find(:all, :conditions => { :invoice_id => document.id })
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
	  document.update_attributes(params[document])
	  @quotation = Quotation.find(document.ref_id)  
	  @quotation.complete = 'false'
	  @quotation.update_attributes(params[:quotation])
	end
	if Date.today.year==document.doc_date.year && Date.today.month>document.doc_date.month
# 	  document.doc_date=Date.today
	  document.approve=nil
	  document.cancel=true
	  @items=Item.find(:all, :conditions => { :invoice_id => document.id })
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
	  document.update_attributes(params[document])
	  @quotation = Quotation.find(document.ref_id)  
	  @quotation.complete = 'false'
	  @quotation.update_attributes(params[:quotation])
	end
	if Date.today.year==document.doc_date.year && Date.today.month==document.doc_date.month && Date.today.day>document.doc_date.day
# 	  document.doc_date=Date.today
	  document.approve=nil
	  document.cancel=true
	  @items=Item.find(:all, :conditions => { :invoice_id => document.id })
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
	  document.update_attributes(params[document])
	  @quotation = Quotation.find(document.ref_id)  
	  @quotation.complete = 'false'
	  @quotation.update_attributes(params[:quotation])
	end  
      end  
      end
    end
    end
      
    @documents.each do |document|
      if document.type=="Quotation"
	if document.approve==nil && document.cancel==false
	  if Date.today.strftime("%d-%m-%Y")==document.doc_date.strftime("%d-%m-%Y")
	    document.cancel=true
	    document.approve=false
	    document.update_attributes(params[document])
	  end
	  if Date.today.year==document.doc_date.year && Date.today.month>document.doc_date.month
# 	    document.doc_date==Date.today
	    document.cancel=true
	    document.approve=false
	    document.update_attributes(params[document])
	  end
	  if Date.today.year==document.doc_date.year && Date.today.month==document.doc_date.month && Date.today.day>document.doc_date.day
# 	    document.doc_date==Date.today
	    document.cancel=true
	    document.approve=false 
	    document.update_attributes(params[document])
	  end
	end
      end
    end
    
    if (params[:col] == '1')
      if (params[:sort] == 'custname' && params[:direction]=='asc') 
	 @documents = Document.joins(:customer).searchcustname(params[:search]).order('custname' + ' ' + 'asc').where('(type = ? AND approve = ? AND complete = ?) OR ((type = ? OR type = ?) AND approve =? AND complete = ? AND cancel = ?) ' ,"Quotation",true,false,"Invoice","Bill",true,false,false).paginate(:per_page => 15, :page => params[:page])
      else if (params[:sort] == 'custname' && params[:direction]=='desc')
	     @documents = Document.joins(:customer).searchcustname(params[:search]).order('custname' + ' ' + 'desc').where('(type = ? AND approve = ? AND complete = ?) OR ((type = ? OR type = ?) AND approve =? AND complete = ? AND cancel = ?) ' ,"Quotation",true,false,"Invoice","Bill",true,false,false).paginate(:per_page => 15, :page => params[:page])
	  else
	     @documents = Document.joins(:customer).searchcustname(params[:search]).order(sort_column + ' ' + sort_direction).where('(type = ? AND approve = ? AND complete = ?) OR ((type = ? OR type = ?) AND approve =? AND complete = ? AND cancel = ?) ' ,"Quotation",true,false,"Invoice","Bill",true,false,false).paginate(:per_page => 15, :page => params[:page])
	  end
      end
#       @documents = Document.joins(:customer).searchcustname(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
    else if (params[:col] == '2')
	    if (params[:sort] == 'custname' && params[:direction]=='asc') 
	      @documents = Document.joins(:customer).searchtitle(params[:search]).order('custname' + ' ' + 'asc').where('(type = ? AND approve = ? AND complete = ?) OR ((type = ? OR type = ?) AND approve =? AND complete = ? AND cancel = ?) ' ,"Quotation",true,false,"Invoice","Bill",true,false,false).paginate(:per_page => 15, :page => params[:page])
	  else if (params[:sort] == 'custname' && params[:direction]=='desc')
		  @documents = Document.joins(:customer).searchtitle(params[:search]).order('custname' + ' ' + 'desc').where('(type = ? AND approve = ? AND complete = ?) OR ((type = ? OR type = ?) AND approve =? AND complete = ? AND cancel = ?) ' ,"Quotation",true,false,"Invoice","Bill",true,false,false).paginate(:per_page => 15, :page => params[:page])
	       else
		  @documents = Document.joins(:customer).searchtitle(params[:search]).order(sort_column + ' ' + sort_direction).where('(type = ? AND approve = ? AND complete = ?) OR ((type = ? OR type = ?) AND approve =? AND complete = ? AND cancel = ?) ' ,"Quotation",true,false,"Invoice","Bill",true,false,false).paginate(:per_page => 15, :page => params[:page])
	       end
	  end
      
# 	    @documents = Document.joins(:customer).searchtitle(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
	 else
	    if (params[:sort] == 'custname' && params[:direction]=='asc') 
	      @documents = Document.joins(:customer).search(params[:search]).order('custname' + ' ' + 'asc').where('(type = ? AND approve = ? AND complete = ?) OR ((type = ? OR type = ?) AND approve =? AND complete = ? AND cancel = ?) ' ,"Quotation",true,false,"Invoice","Bill",true,false,false).paginate(:per_page => 15, :page => params[:page])
	    else if (params[:sort] == 'custname' && params[:direction]=='desc')
		    @documents = Document.joins(:customer).search(params[:search]).order('custname' + ' ' + 'desc').where('(type = ? AND approve = ? AND complete = ?) OR ((type = ? OR type = ?) AND approve =? AND complete = ? AND cancel = ?) ' ,"Quotation",true,false,"Invoice","Bill",true,false,false).paginate(:per_page => 15, :page => params[:page])
		 else
		    @documents = Document.joins(:customer).search(params[:search]).order(sort_column + ' ' + sort_direction).where('(type = ? AND approve = ? AND complete = ?) OR ((type = ? OR type = ?) AND approve =? AND complete = ? AND cancel = ?) ' ,"Quotation",true,false,"Invoice","Bill",true,false,false).paginate(:per_page => 15, :page => params[:page])
		 end
	    end
# 	    @documents = Document.joins(:customer).search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
	 end
    end
    
    @comp=0
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @documents }
      format.json  { render :json => @documents }
    end
    end
  end
  
  
  private
  
  def sort_column
    Document.column_names.include?(params[:sort]) ? params[:sort] : "updated_at"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
  
end
