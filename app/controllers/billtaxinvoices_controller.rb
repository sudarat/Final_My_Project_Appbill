class BilltaxinvoicesController < ApplicationController
      
  helper_method :run_docnumber, :sort_column, :sort_direction
  
  # GET /billtaxinvoices
  # GET /billtaxinvoices.xml
  def index
#     @billtaxinvoices = Billtaxinvoicetaxinvoice.all
    if (params[:col] == '1')
      if (params[:sort] == 'custname' && params[:direction]=='asc') 
	 @billtaxinvoices = Billtaxinvoice.joins(:customer).searchcustname(params[:search]).order('custname' + ' ' + 'asc').paginate(:per_page => 15, :page => params[:page])
      else if (params[:sort] == 'custname' && params[:direction]=='desc')
	     @billtaxinvoices = Billtaxinvoice.joins(:customer).searchcustname(params[:search]).order('custname' + ' ' + 'desc').paginate(:per_page => 15, :page => params[:page])
	  else
	     @billtaxinvoices = Billtaxinvoice.joins(:customer).searchcustname(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
	  end
      end
#       @billtaxinvoices = Billtaxinvoice.joins(:customer).searchcustname(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
    else if (params[:col] == '2')
	    if (params[:sort] == 'custname' && params[:direction]=='asc') 
	      @billtaxinvoices = Billtaxinvoice.joins(:customer).searchtitle(params[:search]).order('custname' + ' ' + 'asc').paginate(:per_page => 15, :page => params[:page])
	  else if (params[:sort] == 'custname' && params[:direction]=='desc')
		  @billtaxinvoices = Billtaxinvoice.joins(:customer).searchtitle(params[:search]).order('custname' + ' ' + 'desc').paginate(:per_page => 15, :page => params[:page])
	       else
		  @billtaxinvoices = Billtaxinvoice.joins(:customer).searchtitle(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
	       end
	  end
      
# 	    @billtaxinvoices = Billtaxinvoice.joins(:customer).searchtitle(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
	 else
	    if (params[:sort] == 'custname' && params[:direction]=='asc') 
	      @billtaxinvoices = Billtaxinvoice.joins(:customer).search(params[:search]).order('custname' + ' ' + 'asc').paginate(:per_page => 15, :page => params[:page])
	    else if (params[:sort] == 'custname' && params[:direction]=='desc')
		    @billtaxinvoices = Billtaxinvoice.joins(:customer).search(params[:search]).order('custname' + ' ' + 'desc').paginate(:per_page => 15, :page => params[:page])
		 else
		    @billtaxinvoices = Billtaxinvoice.joins(:customer).search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
		 end
	    end
# 	    @billtaxinvoices = Billtaxinvoice.joins(:customer).search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
	 end
    end
     #       @billtaxinvoices = Billtaxinvoice.customer
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @billtaxinvoices }
      format.json  { render :json => @billtaxinvoices }
    end
  end

  # GET /billtaxinvoices/1
  # GET /billtaxinvoices/1.xml
  def show
    @billtaxinvoice = Billtaxinvoice.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @billtaxinvoice }
      format.json  { render :json => @billtaxinvoice }
    end
  end

  # GET /billtaxinvoice/new
  # GET /billtaxinvoice/new.xml  
  def new
    @invoice = Invoice.find(cookies[:invoice_id])
    @billtaxinvoice = Billtaxinvoice.new
     run_docnumber
     default_cancel
    @billtaxinvoice.tax = @invoice.tax
    @billtaxinvoice.complete = false
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @billtaxinvoice }
      format.json  { render :json => @billtaxinvoice }
    end
  end
  
  
  # GET /billtaxinvoices/1/edit
  def edit
    @billtaxinvoice = Billtaxinvoice.find(params[:id])
    @invoice = Invoice.find(@billtaxinvoice.ref_id)
  end

  # POST /billtaxinvoices
  # POST /billtaxinvoices.xml
  def create
    @invoice = Invoice.find(cookies[:invoice_id])
    @billtaxinvoice = Billtaxinvoice.new(params[:billtaxinvoice])
    @billtaxinvoice.ref_id = @invoice.id
    @billtaxinvoice.title = @invoice.title
    @billtaxinvoice.customer = @invoice.customer
    @billtaxinvoice.complete = false
    @billtaxinvoice.tax = @invoice.tax
    run_docnumber
    default_cancel
    respond_to do |format|
      if @billtaxinvoice.save
	@items=Item.find(:all, :conditions => { :invoice_id => @invoice.id })
			@items.each do |item|
			  item.billtaxinvoice_id = @billtaxinvoice.id   #
			  item.update_attributes(params[:item])		
			end
	@invoice.complete=true
	@invoice.update_attributes(params[:invoice]) 
	cookies.delete :invoice_id
        format.html { redirect_to(@billtaxinvoice, :notice => 'Billtaxinvoice was successfully created.') }
        format.xml  { render :xml => @billtaxinvoice, :status => :created, :location => @billtaxinvoice }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @billtaxinvoice.errors, :status => :unprocessable_entity }
      end
    end
    
  end

  # PUT /billtaxinvoices/1
  # PUT /billtaxinvoices/1.xml
  def update
    @billtaxinvoice = Billtaxinvoice.find(params[:id])
    
    respond_to do |format|
      if @billtaxinvoice.update_attributes(params[:billtaxinvoice])
	if @billtaxinvoice.cancel == true
	  @items=Item.find(:all, :conditions => { :billtaxinvoice_id => @billtaxinvoice.id })
			@items.each do |item|
			  @i = Item.new 
			  @i.description = item.description
			  @i.quantity = item.quantity
			  @i.unit_price = item.unit_price
			  @i.billtaxinvoice_id = item.billtaxinvoice_id
			  @i.save

			  item.billtaxinvoice_id = nil  #
			  item.update_attributes(params[:item])		
			end
	  @invoice = Invoice.find(@billtaxinvoice.ref_id)
	  @invoice.complete=false
	  @invoice.update_attributes(params[:invoice]) 
	end
        format.html { redirect_to(@billtaxinvoice, :notice => 'Billtaxinvoice was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @billtaxinvoice.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /billtaxinvoices/1
  # DELETE /billtaxinvoices/1.xml
  def destroy
    @billtaxinvoice = Billtaxinvoice.find(params[:id])
    @billtaxinvoice.destroy

    respond_to do |format|
      format.html { redirect_to(billtaxinvoices_url) }
      format.xml  { head :ok }
    end
  end
  
  def printred
    @company = Company.first
    @billtaxinvoice = Billtaxinvoice.find(params[:id])
    render :layout => 'print'
  end
  
  def printwhite
    @company = Company.first
    @billtaxinvoice = Billtaxinvoice.find(params[:id])
    render :layout => 'print'
  end
  
  def printblue
    @company = Company.first
    @billtaxinvoice = Billtaxinvoice.find(params[:id])
    render :layout => 'print'
  end
  
  def nextdoc
    @billtaxinvoice = Billtaxinvoice.find(params[:id])
    cookies[:billtaxinvoice_id] = @billtaxinvoice.id
    redirect_to(new_taxinvoice_path)
  end
  
  def btwait
#     @billtaxinvoices = Billtaxinvoicetaxinvoice.all
    if (params[:col] == '1')
      if (params[:sort] == 'custname' && params[:direction]=='asc') 
	 @billtaxinvoices = Billtaxinvoice.joins(:customer).searchcustname(params[:search]).order('custname' + ' ' + 'asc').where(:complete => false,:cancel => false).paginate(:per_page => 15, :page => params[:page])
      else if (params[:sort] == 'custname' && params[:direction]=='desc')
	     @billtaxinvoices = Billtaxinvoice.joins(:customer).searchcustname(params[:search]).order('custname' + ' ' + 'desc').where(:complete => false,:cancel => false).paginate(:per_page => 15, :page => params[:page])
	  else
	     @billtaxinvoices = Billtaxinvoice.joins(:customer).searchcustname(params[:search]).order(sort_column + ' ' + sort_direction).where(:complete => false,:cancel => false).paginate(:per_page => 15, :page => params[:page])
	  end
      end
#       @billtaxinvoices = Billtaxinvoice.joins(:customer).searchcustname(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
    else if (params[:col] == '2')
	    if (params[:sort] == 'custname' && params[:direction]=='asc') 
	      @billtaxinvoices = Billtaxinvoice.joins(:customer).searchtitle(params[:search]).order('custname' + ' ' + 'asc').where(:complete => false,:cancel => false).paginate(:per_page => 15, :page => params[:page])
	  else if (params[:sort] == 'custname' && params[:direction]=='desc')
		  @billtaxinvoices = Billtaxinvoice.joins(:customer).searchtitle(params[:search]).order('custname' + ' ' + 'desc').where(:complete => false,:cancel => false).paginate(:per_page => 15, :page => params[:page])
	       else
		  @billtaxinvoices = Billtaxinvoice.joins(:customer).searchtitle(params[:search]).order(sort_column + ' ' + sort_direction).where(:complete => false,:cancel => false).paginate(:per_page => 15, :page => params[:page])
	       end
	  end
      
# 	    @billtaxinvoices = Billtaxinvoice.joins(:customer).searchtitle(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
	 else
	    if (params[:sort] == 'custname' && params[:direction]=='asc') 
	      @billtaxinvoices = Billtaxinvoice.joins(:customer).search(params[:search]).order('custname' + ' ' + 'asc').where(:complete => false,:cancel => false).paginate(:per_page => 15, :page => params[:page])
	    else if (params[:sort] == 'custname' && params[:direction]=='desc')
		    @billtaxinvoices = Billtaxinvoice.joins(:customer).search(params[:search]).order('custname' + ' ' + 'desc').where(:complete => false,:cancel => false).paginate(:per_page => 15, :page => params[:page])
		 else
		    @billtaxinvoices = Billtaxinvoice.joins(:customer).search(params[:search]).order(sort_column + ' ' + sort_direction).where(:complete => false,:cancel => false).paginate(:per_page => 15, :page => params[:page])
		 end
	    end
# 	    @billtaxinvoices = Billtaxinvoice.joins(:customer).search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
	 end
    end
     #       @billtaxinvoices = Billtaxinvoice.customer
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @billtaxinvoices }
      format.json  { render :json => @billtaxinvoices }
    end
  end
  
  def btcomplete
#     @billtaxinvoices = Billtaxinvoicetaxinvoice.all
    if (params[:col] == '1')
      if (params[:sort] == 'custname' && params[:direction]=='asc') 
	 @billtaxinvoices = Billtaxinvoice.joins(:customer).searchcustname(params[:search]).order('custname' + ' ' + 'asc').where(:complete => true,:cancel => false).paginate(:per_page => 15, :page => params[:page])
      else if (params[:sort] == 'custname' && params[:direction]=='desc')
	     @billtaxinvoices = Billtaxinvoice.joins(:customer).searchcustname(params[:search]).order('custname' + ' ' + 'desc').where(:complete => true,:cancel => false).paginate(:per_page => 15, :page => params[:page])
	  else
	     @billtaxinvoices = Billtaxinvoice.joins(:customer).searchcustname(params[:search]).order(sort_column + ' ' + sort_direction).where(:complete => true,:cancel => false).paginate(:per_page => 15, :page => params[:page])
	  end
      end
#       @billtaxinvoices = Billtaxinvoice.joins(:customer).searchcustname(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
    else if (params[:col] == '2')
	    if (params[:sort] == 'custname' && params[:direction]=='asc') 
	      @billtaxinvoices = Billtaxinvoice.joins(:customer).searchtitle(params[:search]).order('custname' + ' ' + 'asc').where(:complete => true,:cancel => false).paginate(:per_page => 15, :page => params[:page])
	  else if (params[:sort] == 'custname' && params[:direction]=='desc')
		  @billtaxinvoices = Billtaxinvoice.joins(:customer).searchtitle(params[:search]).order('custname' + ' ' + 'desc').where(:complete => true,:cancel => false).paginate(:per_page => 15, :page => params[:page])
	       else
		  @billtaxinvoices = Billtaxinvoice.joins(:customer).searchtitle(params[:search]).order(sort_column + ' ' + sort_direction).where(:complete => true,:cancel => false).paginate(:per_page => 15, :page => params[:page])
	       end
	  end
      
# 	    @billtaxinvoices = Billtaxinvoice.joins(:customer).searchtitle(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
	 else
	    if (params[:sort] == 'custname' && params[:direction]=='asc') 
	      @billtaxinvoices = Billtaxinvoice.joins(:customer).search(params[:search]).order('custname' + ' ' + 'asc').where(:complete => true,:cancel => false).paginate(:per_page => 15, :page => params[:page])
	    else if (params[:sort] == 'custname' && params[:direction]=='desc')
		    @billtaxinvoices = Billtaxinvoice.joins(:customer).search(params[:search]).order('custname' + ' ' + 'desc').where(:complete => true,:cancel => false).paginate(:per_page => 15, :page => params[:page])
		 else
		    @billtaxinvoices = Billtaxinvoice.joins(:customer).search(params[:search]).order(sort_column + ' ' + sort_direction).where(:complete => true,:cancel => false).paginate(:per_page => 15, :page => params[:page])
		 end
	    end
# 	    @billtaxinvoices = Billtaxinvoice.joins(:customer).search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
	 end
    end
     #       @billtaxinvoices = Billtaxinvoice.customer
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @billtaxinvoices }
      format.json  { render :json => @billtaxinvoices }
    end
  end
  
  private
  
  def run_docnumber
    y=(Time.now.year+543).to_s.split("25").last
      if Billtaxinvoice.find(:all).empty?
	@billtaxinvoice.doc_number = y+'0001'
      else if y != Billtaxinvoice.last.doc_number[0..1]
	      @billtaxinvoice.doc_number = y+'0001'
	   else
	      i = Billtaxinvoice.last.doc_number
	      n = i[2..5].to_i+1 
	      if n<10 
		@billtaxinvoice.doc_number = y+'000'+n.to_s 
	      else if n<100
		    @billtaxinvoice.doc_number = y+'00'+n.to_s 
		   else if n<1000 
			  @billtaxinvoice.doc_number = y+'0'+n.to_s 
			else if n<=9999
			       @billtaxinvoice.doc_number = y+n.to_s 
			     else 
			       @billtaxinvoice.doc_number = 'Do not create billtaxinvoice !!!' 
			     end  
		        end
		   end
	      end 
	    end
       end 
  end
  
  def default_cancel
    @billtaxinvoice.cancel = false
  end
  
  
  def sort_column
    Billtaxinvoice.column_names.include?(params[:sort]) ? params[:sort] : "updated_at"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
  
  
end
