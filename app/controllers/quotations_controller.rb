class QuotationsController < ApplicationController 
  helper_method :run_docnumber, :sort_column, :sort_direction
  # GET /quotations
  # GET /quotations.xml
  def index
    
     @quotations = Quotation.all
     
#     Auto update Date
    @quotations.each do |quotation|
      if quotation.approve==nil && quotation.cancel==false
	  if Date.today.strftime("%d-%m-%Y")==quotation.doc_date.strftime("%d-%m-%Y")
	    quotation.cancel=true
	    quotation.approve=false
	    quotation.update_attributes(params[quotation])
	  end
	  if Date.today.year==quotation.doc_date.year && Date.today.month>quotation.doc_date.month
# 	    quotation.doc_date==Date.today
	    quotation.cancel=true
	    quotation.approve=false
	    quotation.update_attributes(params[quotation])
	  end
	  if Date.today.year==quotation.doc_date.year && Date.today.month==quotation.doc_date.month && Date.today.day>quotation.doc_date.day
# 	    quotation.doc_date==Date.today
	    quotation.cancel=true
	    quotation.approve=false 
	    quotation.update_attributes(params[quotation])
	  end
      end
    end

    if (params[:col] == '1')
      if (params[:sort] == 'custname' && params[:direction]=='asc') 
	 @quotations = Quotation.joins(:customer).searchcustname(params[:search]).order('custname' + ' ' + 'asc').paginate(:per_page => 15, :page => params[:page])
      else if (params[:sort] == 'custname' && params[:direction]=='desc')
	     @quotations = Quotation.joins(:customer).searchcustname(params[:search]).order('custname' + ' ' + 'desc').paginate(:per_page => 15, :page => params[:page])
	  else
	     @quotations = Quotation.joins(:customer).searchcustname(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
	  end
      end
#       @quotations = Quotation.joins(:customer).searchcustname(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
    else if (params[:col] == '2')
	    if (params[:sort] == 'custname' && params[:direction]=='asc') 
	      @quotations = Quotation.joins(:customer).searchtitle(params[:search]).order('custname' + ' ' + 'asc').paginate(:per_page => 15, :page => params[:page])
	  else if (params[:sort] == 'custname' && params[:direction]=='desc')
		  @quotations = Quotation.joins(:customer).searchtitle(params[:search]).order('custname' + ' ' + 'desc').paginate(:per_page => 15, :page => params[:page])
	       else
		  @quotations = Quotation.joins(:customer).searchtitle(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
	       end
	  end
      
# 	    @quotations = Quotation.joins(:customer).searchtitle(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
	 else
	    if (params[:sort] == 'custname' && params[:direction]=='asc') 
	      @quotations = Quotation.joins(:customer).search(params[:search]).order('custname' + ' ' + 'asc').paginate(:per_page => 15, :page => params[:page])
	    else if (params[:sort] == 'custname' && params[:direction]=='desc')
		    @quotations = Quotation.joins(:customer).search(params[:search]).order('custname' + ' ' + 'desc').paginate(:per_page => 15, :page => params[:page])
		 else
		    @quotations = Quotation.joins(:customer).search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
		 end
	    end
# 	    @quotations = Quotation.joins(:customer).search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
	 end
    end
    
    cookies.delete :back_doc
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @quotations }
      format.json  { render :json => @quotations }
    end
  end

  # GET /quotations/1
  # GET /quotations/1.xml
  def show
    @quotation = Quotation.find(params[:id])
    cookies[:create_inv] = 0
    cookies.delete :create
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @quotation }
      format.json  { render :json => @quotation }
    end
  end

  # GET /quotation/new
  # GET /quotation/new.xml
  def new
    @quotation = Quotation.new
    run_docnumber
    default
    @quotation.tax = false
    @quotation.doc_date= Date.today.tomorrow
    @quotation.detail=nil
    cookies[:back_doc] = 'quotation'
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @quotation }
      format.json  { render :json => @quotation }
    end
  end

  # GET /quotations/1/edit
  def edit
    @quotation = Quotation.find(params[:id])
    cookies[:create_inv] = 0
  end

  # POST /quotations
  # POST /quotations.xml
  def create
    @quotation = Quotation.new(params[:quotation])    
    run_docnumber
    default
    cookies[:create] = 1
    respond_to do |format|
      if @quotation.save
	if @quotation.doc_date==Date.today
	  @quotation.destroy
	  format.html { render :action => "new"}
	else
	  format.html { redirect_to(manageitem_quotation_path(@quotation), :notice => 'quotation was successfully created.') }
	  format.xml  { render :xml => @quotation, :status => :created, :location => @quotation }
	end
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @quotation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /quotations/1
  # PUT /quotations/1.xml
  def update
    @quotation = Quotation.find(params[:id])
        
    respond_to do |format|
      if @quotation.update_attributes(params[:quotation])
        format.html { #   CANCLE 
		      if @quotation.cancel == true
			  @quotation.approve = false
			  @quotation.update_attributes(params[@quotation])
			 @invoices = Invoice.find(:all, :conditions => { :ref_id => @quotation.id , :cancel => false})
			 @invoices.each do |invoice| 
			    invoice.cancel = true
			    invoice.update_attributes(params[:invoice])
			 end 
			  
			redirect_to(@quotation, :notice => 'quotation\'s data was successfully updated.') 
		      else if @quotation.approve == true
			      redirect_to(@quotation, :notice => 'quotation\'s data was successfully updated.') 
			   else
			      redirect_to(manageitem_quotation_path(@quotation), :notice => 'quotation\'s data was successfully updated.') 
			   end
		      end
		    }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @quotation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /quotations/1
  # DELETE /quotations/1.xml
  def destroy
    @quotation = Quotation.find(params[:id])
    @quotation.destroy

    respond_to do |format|
      format.html { redirect_to(quotations_url) }
      format.xml  { head :ok }
    end
  end
  
  def printblue
    @company = Company.first
    @quotation = Quotation.find(params[:id])
    render :layout => 'print'
  end
  
  def printred
    cookies[:tax] = params[:age]
    @company = Company.first
    @quotation = Quotation.find(params[:id])
    render :layout => 'print'
  end
  
  def printwhite
    @company = Company.first
    @quotation = Quotation.find(params[:id])
    render :layout => 'print'
  end
  
  def manageitem
    @quotation = Quotation.find(params[:id])
    cookies[:create_inv] = 0
  end
  
  def nextdoc
    @quotation = Quotation.find(params[:id])
    cookies[:quotation_id] = @quotation.id
    redirect_to(new_invoice_path)
  end
  
  def approve
    @quotation = Quotation.find(params[:id])
    redirect_to(request.url)
  end
  
  def qwait
#     @quotations = Quotation.find(:all, :conditions => { :complete => false })
    if (params[:col] == '1')
      if (params[:sort] == 'custname' && params[:direction]=='asc') 
	 @quotations = Quotation.joins(:customer).searchcustname(params[:search]).order('custname' + ' ' + 'asc').where(:approve => nil).paginate(:per_page => 15, :page => params[:page])
      else if (params[:sort] == 'custname' && params[:direction]=='desc')
	     @quotations = Quotation.joins(:customer).searchcustname(params[:search]).order('custname' + ' ' + 'desc').where(:approve => nil).paginate(:per_page => 15, :page => params[:page])
	  else
	     @quotations = Quotation.joins(:customer).searchcustname(params[:search]).order(sort_column + ' ' + sort_direction).where(:approve => nil).paginate(:per_page => 15, :page => params[:page])
	  end
      end
#       @quotations = Quotation.joins(:customer).searchcustname(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
    else if (params[:col] == '2')
	    if (params[:sort] == 'custname' && params[:direction]=='asc') 
	      @quotations = Quotation.joins(:customer).searchtitle(params[:search]).order('custname' + ' ' + 'asc').where(:approve => nil).paginate(:per_page => 15, :page => params[:page])
	  else if (params[:sort] == 'custname' && params[:direction]=='desc')
		  @quotations = Quotation.joins(:customer).searchtitle(params[:search]).order('custname' + ' ' + 'desc').where(:approve => nil).paginate(:per_page => 15, :page => params[:page])
	       else
		  @quotations = Quotation.joins(:customer).searchtitle(params[:search]).order(sort_column + ' ' + sort_direction).where(:approve => nil).paginate(:per_page => 15, :page => params[:page])
	       end
	  end
# 	    @quotations = Quotation.joins(:customer).searchtitle(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
	 else
	    if (params[:sort] == 'custname' && params[:direction]=='asc') 
	      @quotations = Quotation.joins(:customer).search(params[:search]).order('custname' + ' ' + 'asc').where(:approve => nil).paginate(:per_page => 15, :page => params[:page])
	    else if (params[:sort] == 'custname' && params[:direction]=='desc')
		    @quotations = Quotation.joins(:customer).search(params[:search]).order('custname' + ' ' + 'desc').where(:approve => nil).paginate(:per_page => 15, :page => params[:page])
		 else
		    @quotations = Quotation.joins(:customer).search(params[:search]).order(sort_column + ' ' + sort_direction).where(:approve => nil).paginate(:per_page => 15, :page => params[:page])
		 end
	    end
# 	    @quotations = Quotation.joins(:customer).search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
	 end
    end
    
#     @quotationswait = Quotation.find(:all, :conditions => { :approve => nil })
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @quotations }
      format.json  { render :json => @quotations }
    end
  end

  
  def qcomplete
#     @quotations = Quotation.find(:all, :conditions => { :complete => false })
    if (params[:col] == '1')
      if (params[:sort] == 'custname' && params[:direction]=='asc') 
	 @quotations = Quotation.joins(:customer).searchcustname(params[:search]).order('custname' + ' ' + 'asc').where(:approve => true ,:complete => true).paginate(:per_page => 15, :page => params[:page])
      else if (params[:sort] == 'custname' && params[:direction]=='desc')
	     @quotations = Quotation.joins(:customer).searchcustname(params[:search]).order('custname' + ' ' + 'desc').where(:approve => true ,:complete => true).paginate(:per_page => 15, :page => params[:page])
	  else
	     @quotations = Quotation.joins(:customer).searchcustname(params[:search]).order(sort_column + ' ' + sort_direction).where(:approve => true ,:complete => true).paginate(:per_page => 15, :page => params[:page])
	  end
      end
#       @quotations = Quotation.joins(:customer).searchcustname(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
    else if (params[:col] == '2')
	    if (params[:sort] == 'custname' && params[:direction]=='asc') 
	      @quotations = Quotation.joins(:customer).searchtitle(params[:search]).order('custname' + ' ' + 'asc').where(:approve => true ,:complete => true).paginate(:per_page => 15, :page => params[:page])
	  else if (params[:sort] == 'custname' && params[:direction]=='desc')
		  @quotations = Quotation.joins(:customer).searchtitle(params[:search]).order('custname' + ' ' + 'desc').where(:approve => true ,:complete => true).paginate(:per_page => 15, :page => params[:page])
	       else
		  @quotations = Quotation.joins(:customer).searchtitle(params[:search]).order(sort_column + ' ' + sort_direction).where(:approve => true ,:complete => true).paginate(:per_page => 15, :page => params[:page])
	       end
	  end
# 	    @quotations = Quotation.joins(:customer).searchtitle(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
	 else
	    if (params[:sort] == 'custname' && params[:direction]=='asc') 
	      @quotations = Quotation.joins(:customer).search(params[:search]).order('custname' + ' ' + 'asc').where(:approve => true ,:complete => true).paginate(:per_page => 15, :page => params[:page])
	    else if (params[:sort] == 'custname' && params[:direction]=='desc')
		    @quotations = Quotation.joins(:customer).search(params[:search]).order('custname' + ' ' + 'desc').where(:approve => true ,:complete => true).paginate(:per_page => 15, :page => params[:page])
		 else
		    @quotations = Quotation.joins(:customer).search(params[:search]).order(sort_column + ' ' + sort_direction).where(:approve => true ,:complete => true).paginate(:per_page => 15, :page => params[:page])
		 end
	    end
# 	    @quotations = Quotation.joins(:customer).search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
	 end
    end
    
#     @quotationscomplete = Quotation.find(:all, :conditions => { :approve => true ,:complete => true })
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @quotations }
      format.json  { render :json => @quotations }
    end
  end
  
  def qnotcomplete
#     @quotations = Quotation.find(:all, :conditions => { :complete => false })
    if (params[:col] == '1')
      if (params[:sort] == 'custname' && params[:direction]=='asc') 
	 @quotations = Quotation.joins(:customer).searchcustname(params[:search]).order('custname' + ' ' + 'asc').where(:approve => true ,:complete => false ).paginate(:per_page => 15, :page => params[:page])
      else if (params[:sort] == 'custname' && params[:direction]=='desc')
	     @quotations = Quotation.joins(:customer).searchcustname(params[:search]).order('custname' + ' ' + 'desc').where(:approve => true ,:complete => false ).paginate(:per_page => 15, :page => params[:page])
	  else
	     @quotations = Quotation.joins(:customer).searchcustname(params[:search]).order(sort_column + ' ' + sort_direction).where(:approve => true ,:complete => false ).paginate(:per_page => 15, :page => params[:page])
	  end
      end
#       @quotations = Quotation.joins(:customer).searchcustname(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
    else if (params[:col] == '2')
	    if (params[:sort] == 'custname' && params[:direction]=='asc') 
	      @quotations = Quotation.joins(:customer).searchtitle(params[:search]).order('custname' + ' ' + 'asc').where(:approve => true ,:complete => false ).paginate(:per_page => 15, :page => params[:page])
	  else if (params[:sort] == 'custname' && params[:direction]=='desc')
		  @quotations = Quotation.joins(:customer).searchtitle(params[:search]).order('custname' + ' ' + 'desc').where(:approve => true ,:complete => false ).paginate(:per_page => 15, :page => params[:page])
	       else
		  @quotations = Quotation.joins(:customer).searchtitle(params[:search]).order(sort_column + ' ' + sort_direction).where(:approve => true ,:complete => false ).paginate(:per_page => 15, :page => params[:page])
	       end
	  end
# 	    @quotations = Quotation.joins(:customer).searchtitle(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
	 else
	    if (params[:sort] == 'custname' && params[:direction]=='asc') 
	      @quotations = Quotation.joins(:customer).search(params[:search]).order('custname' + ' ' + 'asc').where(:approve => true ,:complete => false ).paginate(:per_page => 15, :page => params[:page])
	    else if (params[:sort] == 'custname' && params[:direction]=='desc')
		    @quotations = Quotation.joins(:customer).search(params[:search]).order('custname' + ' ' + 'desc').where(:approve => true ,:complete => false ).paginate(:per_page => 15, :page => params[:page])
		 else
		    @quotations = Quotation.joins(:customer).search(params[:search]).order(sort_column + ' ' + sort_direction).where(:approve => true ,:complete => false ).paginate(:per_page => 15, :page => params[:page])
		 end
	    end
# 	    @quotations = Quotation.joins(:customer).search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 15, :page => params[:page])
	 end
    end
    
#     @quotationsnotcomplete = Quotation.find(:all, :conditions => { :approve => true ,:complete => false })
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @quotations }
      format.json  { render :json => @quotations }
    end
  end
  
  private
  
  def run_docnumber
    y=(Time.now.year+543).to_s.split("25").last
      if Quotation.find(:all).empty?
	@quotation.doc_number = y+'0001'
      else if y != Quotation.last.doc_number[0..1]
	      @quotation.doc_number = y+'0001'
	   else
	      i = Quotation.last.doc_number
	      n = i[2..5].to_i+1 
	      if n<10 
		@quotation.doc_number = y+'000'+n.to_s 
	      else if n<100
		    @quotation.doc_number = y+'00'+n.to_s 
		   else if n<1000 
			  @quotation.doc_number = y+'0'+n.to_s 
			else if n<=9999
			       @quotation.doc_number = y+n.to_s 
			     else 
			       @quotation.doc_number = 'Do not create quotation !!!' 
			     end  
		        end
		   end
	      end 
	    end
       end 
  end
  
  def default
    @quotation.cancel = false
    @quotation.complete = false
  end

  def sort_column
    Quotation.column_names.include?(params[:sort]) ? params[:sort] : "updated_at"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
  
end
