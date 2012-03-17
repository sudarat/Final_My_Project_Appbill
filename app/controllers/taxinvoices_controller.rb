class TaxinvoicesController < ApplicationController 
  
  helper_method :run_docnumber, :sort_column, :sort_direction
  # GET /taxinvoices
  # GET /taxinvoices.xml
  def index
#     @taxinvoices = Taxinvoice.all
#     @taxinvoices = Taxinvoice.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
    if (params[:col] == '1')
      if (params[:sort] == 'custname' && params[:direction]=='asc') 
	 @taxinvoices = Taxinvoice.joins(:customer).searchcustname(params[:search]).order('custname' + ' ' + 'asc').paginate(:per_page => 15, :page => params[:page])
      else if (params[:sort] == 'custname' && params[:direction]=='desc')
	     @taxinvoices = Taxinvoice.joins(:customer).searchcustname(params[:search]).order('custname' + ' ' + 'desc').paginate(:per_page => 15, :page => params[:page])
	  else
	     @taxinvoices = Taxinvoice.joins(:customer).searchcustname(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
	  end
      end
#       @taxinvoices = Taxinvoice.joins(:customer).searchcustname(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
    else if (params[:col] == '2')
	    if (params[:sort] == 'custname' && params[:direction]=='asc') 
	      @taxinvoices = Taxinvoice.joins(:customer).searchtitle(params[:search]).order('custname' + ' ' + 'asc').paginate(:per_page => 15, :page => params[:page])
	  else if (params[:sort] == 'custname' && params[:direction]=='desc')
		  @taxinvoices = Taxinvoice.joins(:customer).searchtitle(params[:search]).order('custname' + ' ' + 'desc').paginate(:per_page => 15, :page => params[:page])
	       else
		  @taxinvoices = Taxinvoice.joins(:customer).searchtitle(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
	       end
	  end
      
# 	    @taxinvoices = Taxinvoice.joins(:customer).searchtitle(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
	 else
	    if (params[:sort] == 'custname' && params[:direction]=='asc') 
	      @taxinvoices = Taxinvoice.joins(:customer).search(params[:search]).order('custname' + ' ' + 'asc').paginate(:per_page => 15, :page => params[:page])
	    else if (params[:sort] == 'custname' && params[:direction]=='desc')
		    @taxinvoices = Taxinvoice.joins(:customer).search(params[:search]).order('custname' + ' ' + 'desc').paginate(:per_page => 15, :page => params[:page])
		 else
		    @taxinvoices = Taxinvoice.joins(:customer).search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
		 end
	    end
# 	    @taxinvoices = Taxinvoice.joins(:customer).search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
	 end
    end
    
    cookies.delete :back_doc
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @taxinvoices }
      format.json  { render :json => @taxinvoices }
    end
  end

  # GET /taxinvoices/1
  # GET /taxinvoices/1.xml
  def show
    @taxinvoice = Taxinvoice.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @taxinvoice }
    end
  end

  # GET /taxinvoice/new
  # GET /taxinvoice/new.xml
  def new
    @bill = Bill.find(cookies[:bill_id])
    @taxinvoice = Taxinvoice.new
    run_docnumber
    default_cancel
    @taxinvoice.tax = @bill.tax
    @taxinvoice.complete = false
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @taxinvoice }
    end
  end

  # GET /taxinvoices/1/edit
  def edit
    @taxinvoice = Taxinvoice.find(params[:id])
    @bill = Bill.find(@taxinvoice.ref_id)
  end

  # POST /taxinvoices
  # POST /taxinvoices.xml
  def create
    @bill = Bill.find(cookies[:bill_id])
    @taxinvoice = Taxinvoice.new(params[:taxinvoice])
    @taxinvoice.ref_id = @bill.id
    @taxinvoice.title = @bill.title
    @taxinvoice.customer = @bill.customer
    @taxinvoice.complete = false
    @taxinvoice.tax = @bill.tax
    run_docnumber
    default_cancel
    respond_to do |format|
      if @taxinvoice.save
	@items=Item.find(:all, :conditions => { :bill_id => @bill.id })
			@items.each do |item|
			  item.taxinvoice_id = @taxinvoice.id   #
			  item.update_attributes(params[:item])		
			end
	@bill.complete=true
	@bill.update_attributes(params[:invoice]) 
	cookies.delete :bill_id
        format.html { redirect_to(@taxinvoice, :notice => 'Taxinvoice was successfully created.') }
        format.xml  { render :xml => @taxinvoice, :status => :created, :location => @taxinvoice }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @taxinvoice.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /taxinvoices/1
  # PUT /taxinvoices/1.xml
  def update
    @taxinvoice = Taxinvoice.find(params[:id])
    
    respond_to do |format|
      if @taxinvoice.update_attributes(params[:taxinvoice])
	if @taxinvoice.cancel == true
	  @items=Item.find(:all, :conditions => { :taxinvoice_id => @taxinvoice.id })
			@items.each do |item|
			  @i = Item.new 
			  @i.description = item.description
			  @i.quantity = item.quantity
			  @i.unit_price = item.unit_price
			  @i.taxinvoice_id = item.taxinvoice_id
			  @i.save

			  item.taxinvoice_id = nil  #
			  item.update_attributes(params[:item])		
			end
	  @bill = Bill.find(@taxinvoice.ref_id)
	  @bill.complete=false
	  @bill.update_attributes(params[:bill]) 
	end
        format.html { redirect_to(@taxinvoice, :notice => 'Taxinvoice was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @taxinvoice.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /taxinvoices/1
  # DELETE /taxinvoices/1.xml
  def destroy
    @taxinvoice = Taxinvoice.find(params[:id])
    @taxinvoice.destroy

    respond_to do |format|
      format.html { redirect_to(taxinvoices_url) }
      format.xml  { head :ok }
    end
  end
  
  def printblue
    @company = Company.first
    @taxinvoice = Taxinvoice.find(params[:id])
    render :layout => 'print'
  end
  
  def printred
    @company = Company.first
    @taxinvoice = Taxinvoice.find(params[:id])
    render :layout => 'print'
  end
  
  def printwhite
    @company = Company.first
    @taxinvoice = Taxinvoice.find(params[:id])
    render :layout => 'print'
  end
  
  def twait
#     @taxinvoices = Taxinvoice.all
#     @taxinvoices = Taxinvoice.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
    if (params[:col] == '1')
      if (params[:sort] == 'custname' && params[:direction]=='asc') 
	 @taxinvoices = Taxinvoice.joins(:customer).searchcustname(params[:search]).order('custname' + ' ' + 'asc').where(:complete => false,:cancel => false).paginate(:per_page => 15, :page => params[:page])
      else if (params[:sort] == 'custname' && params[:direction]=='desc')
	     @taxinvoices = Taxinvoice.joins(:customer).searchcustname(params[:search]).order('custname' + ' ' + 'desc').where(:complete => false,:cancel => false).paginate(:per_page => 15, :page => params[:page])
	  else
	     @taxinvoices = Taxinvoice.joins(:customer).searchcustname(params[:search]).order(sort_column + ' ' + sort_direction).where(:complete => false,:cancel => false).paginate(:per_page => 15, :page => params[:page])
	  end
      end
#       @taxinvoices = Taxinvoice.joins(:customer).searchcustname(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
    else if (params[:col] == '2')
	    if (params[:sort] == 'custname' && params[:direction]=='asc') 
	      @taxinvoices = Taxinvoice.joins(:customer).searchtitle(params[:search]).order('custname' + ' ' + 'asc').where(:complete => false,:cancel => false).paginate(:per_page => 15, :page => params[:page])
	  else if (params[:sort] == 'custname' && params[:direction]=='desc')
		  @taxinvoices = Taxinvoice.joins(:customer).searchtitle(params[:search]).order('custname' + ' ' + 'desc').where(:complete => false,:cancel => false).paginate(:per_page => 15, :page => params[:page])
	       else
		  @taxinvoices = Taxinvoice.joins(:customer).searchtitle(params[:search]).order(sort_column + ' ' + sort_direction).where(:complete => false,:cancel => false).paginate(:per_page => 15, :page => params[:page])
	       end
	  end
      
# 	    @taxinvoices = Taxinvoice.joins(:customer).searchtitle(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
	 else
	    if (params[:sort] == 'custname' && params[:direction]=='asc') 
	      @taxinvoices = Taxinvoice.joins(:customer).search(params[:search]).order('custname' + ' ' + 'asc').where(:complete => false,:cancel => false).paginate(:per_page => 15, :page => params[:page])
	    else if (params[:sort] == 'custname' && params[:direction]=='desc')
		    @taxinvoices = Taxinvoice.joins(:customer).search(params[:search]).order('custname' + ' ' + 'desc').where(:complete => false,:cancel => false).paginate(:per_page => 15, :page => params[:page])
		 else
		    @taxinvoices = Taxinvoice.joins(:customer).search(params[:search]).order(sort_column + ' ' + sort_direction).where(:complete => false,:cancel => false).paginate(:per_page => 15, :page => params[:page])
		 end
	    end
# 	    @taxinvoices = Taxinvoice.joins(:customer).search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
	 end
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @taxinvoices }
      format.json  { render :json => @taxinvoices }
    end
  end
  
  def tcomplete
#     @taxinvoices = Taxinvoice.all
#     @taxinvoices = Taxinvoice.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
    if (params[:col] == '1')
      if (params[:sort] == 'custname' && params[:direction]=='asc') 
	 @taxinvoices = Taxinvoice.joins(:customer).searchcustname(params[:search]).order('custname' + ' ' + 'asc').where(:complete => true,:cancel => false).paginate(:per_page => 15, :page => params[:page])
      else if (params[:sort] == 'custname' && params[:direction]=='desc')
	     @taxinvoices = Taxinvoice.joins(:customer).searchcustname(params[:search]).order('custname' + ' ' + 'desc').where(:complete => true,:cancel => false).paginate(:per_page => 15, :page => params[:page])
	  else
	     @taxinvoices = Taxinvoice.joins(:customer).searchcustname(params[:search]).order(sort_column + ' ' + sort_direction).where(:complete => true,:cancel => false).paginate(:per_page => 15, :page => params[:page])
	  end
      end
#       @taxinvoices = Taxinvoice.joins(:customer).searchcustname(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
    else if (params[:col] == '2')
	    if (params[:sort] == 'custname' && params[:direction]=='asc') 
	      @taxinvoices = Taxinvoice.joins(:customer).searchtitle(params[:search]).order('custname' + ' ' + 'asc').where(:complete => true,:cancel => false).paginate(:per_page => 15, :page => params[:page])
	  else if (params[:sort] == 'custname' && params[:direction]=='desc')
		  @taxinvoices = Taxinvoice.joins(:customer).searchtitle(params[:search]).order('custname' + ' ' + 'desc').where(:complete => true,:cancel => false).paginate(:per_page => 15, :page => params[:page])
	       else
		  @taxinvoices = Taxinvoice.joins(:customer).searchtitle(params[:search]).order(sort_column + ' ' + sort_direction).where(:complete => true,:cancel => false).paginate(:per_page => 15, :page => params[:page])
	       end
	  end
      
# 	    @taxinvoices = Taxinvoice.joins(:customer).searchtitle(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
	 else
	    if (params[:sort] == 'custname' && params[:direction]=='asc') 
	      @taxinvoices = Taxinvoice.joins(:customer).search(params[:search]).order('custname' + ' ' + 'asc').where(:complete => true,:cancel => false).paginate(:per_page => 15, :page => params[:page])
	    else if (params[:sort] == 'custname' && params[:direction]=='desc')
		    @taxinvoices = Taxinvoice.joins(:customer).search(params[:search]).order('custname' + ' ' + 'desc').where(:complete => true,:cancel => false).paginate(:per_page => 15, :page => params[:page])
		 else
		    @taxinvoices = Taxinvoice.joins(:customer).search(params[:search]).order(sort_column + ' ' + sort_direction).where(:complete => true,:cancel => false).paginate(:per_page => 15, :page => params[:page])
		 end
	    end
# 	    @taxinvoices = Taxinvoice.joins(:customer).search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
	 end
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @taxinvoices }
      format.json  { render :json => @taxinvoices }
    end
  end
  
  private
  
  def run_docnumber
    y=(Time.now.year+543).to_s.split("25").last
      if Taxinvoice.find(:all).empty?
	@taxinvoice.doc_number = y+'0001'
      else if y != Taxinvoice.last.doc_number[0..1]
	      @taxinvoice.doc_number = y+'0001'
	   else
	      i = Taxinvoice.last.doc_number
	      n = i[2..5].to_i+1 
	      if n<10 
		@taxinvoice.doc_number = y+'000'+n.to_s 
	      else if n<100
		    @taxinvoice.doc_number = y+'00'+n.to_s 
		   else if n<1000 
			  @taxinvoice.doc_number = y+'0'+n.to_s 
			else if n<=9999
			       @taxinvoice.doc_number = y+n.to_s 
			     else 
			       @taxinvoice.doc_number = 'Do not create taxinvoice !!!' 
			     end  
		        end
		   end
	      end 
	    end
       end 
  end
  
  def default_cancel
    @taxinvoice.cancel = false
  end
  
  def sort_column
    Taxinvoice.column_names.include?(params[:sort]) ? params[:sort] : "updated_at"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
end

