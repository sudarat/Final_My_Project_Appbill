class ItemsController < ApplicationController
  
  def show
    @quotation = Quotation.find(params[:quotation_id])
    @item = @quotation.items.find(params[:id])
  end
  
  def new
    if ((request.url).split('http://localhost:3000/').last).split('/').first == 'quotations'
      @quotation = Quotation.find(params[:quotation_id])
      @item = @quotation.items.new
    else 
      if ((request.url).split('http://localhost:3000/').last).split('/').first == 'receipts'
	@receipt = Receipt.find(params[:receipt_id])
	@item = @receipt.items.new
      end
    end  
    
  end
  
  def create
    if ((request.url).split('http://localhost:3000/').last).split('/').first == 'quotations'
      @quotation = Quotation.find(params[:quotation_id])
      @item = @quotation.items.create(params[:item])
      respond_to do |format|
      if @item.save
        format.html { if @quotation.complete == nil
			@quotation.complete = false
			@quotation.update_attributes(params[:quotation])
			@quotation.complete = nil
			@quotation.update_attributes(params[:quotation])
		      end
		      redirect_to manageitem_quotation_path(@quotation), :notice => 'Item was successfully created.' }
#         format.xml  { render :xml => @quotation, :status => :created, :location => @quotation }
      else
        format.html { render :action => "new" }
#         format.xml  { render :xml => @quotation.errors, :status => :unprocessable_entity }
      end
    end
    
    else 
      if ((request.url).split('http://localhost:3000/').last).split('/').first == 'receipts'
	@receipt = Receipt.find(params[:receipt_id])
	@item = @receipt.items.create(params[:item])
	respond_to do |format|
      if @item.save
        format.html { redirect_to manageitem_receipt_path(@receipt), :notice => 'Item was successfully created.' }
#         format.xml  { render :xml => @quotation, :status => :created, :location => @quotation }
      else
        format.html { render :action => "new" }
#         format.xml  { render :xml => @quotation.errors, :status => :unprocessable_entity }
      end
    end
      end
    end  
      
#     @item = @quotation.items.create(params[:item])
    
    
  end
  
  def edit
    if (request.url)["quotation"] != nil
      @quotation = Quotation.find(params[:quotation_id])
      @item = @quotation.items.find(params[:id])
    else 
      @receipt = Receipt.find(params[:receipt_id])
      @item = @receipt.items.find(params[:id])
    end  
#     @item = @quotation.items.find(params[:id])
  end
  
  def update
    if (request.url)["quotation"] != nil
      @quotation = Quotation.find(params[:quotation_id])
      @item = @quotation.items.find(params[:id])
    else 
      @receipt = Receipt.find(params[:receipt_id])
      @item = @receipt.items.find(params[:id])
    end 

    respond_to do |format|
      if @item.update_attributes(params[:item])
        format.html { if (request.url)["quotation"] != nil
			if @quotation.complete == nil
			  @quotation.complete = false
			  @quotation.update_attributes(params[:quotation])
			  @quotation.complete = nil
			  @quotation.update_attributes(params[:quotation])
			end	
			redirect_to manageitem_quotation_path(@quotation), :notice => 'Item was successfully updated.'
		      else 
			if @receipt.complete == nil
			  @receipt.complete = false
			  @receipt.update_attributes(params[:receipt])
			  @receipt.complete = nil
			  @receipt.update_attributes(params[:receipt])
			end	
			redirect_to manageitem_receipt_path(@receipt), :notice => 'Item was successfully updated.'
		      end 
		      	}
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    if ((request.url).split('http://localhost:3000/').last).split('/').first == 'quotations'
      @quotation = Quotation.find(params[:quotation_id])
      @item = @quotation.items.find(params[:id])
      @item.destroy
    
      if @quotation.complete == nil
	@quotation.complete = false
	@quotation.update_attributes(params[:quotation])
	@quotation.complete = nil
	@quotation.update_attributes(params[:quotation])
      end	            

      redirect_to manageitem_quotation_path(@quotation)
    else 
      if ((request.url).split('http://localhost:3000/').last).split('/').first == 'receipts'
      @receipt = Receipt.find(params[:receipt_id])
      @item = @receipt.items.find(params[:id])
      @item.destroy            

      redirect_to manageitem_receipt_path(@receipt)
      end
    end
    
  end
  
   def additeminvoice
     
     @invoice = Invoice.find(cookies[:invoice_id])
     @quotation = Quotation.find(@invoice.ref_id)
     @item = @quotation.items.find(params[:id])
     @item.invoice_id = @invoice.id   
     respond_to do |format|
       if @item.update_attributes(params[:item])
         format.html { if @invoice.complete == nil || @invoice.complete == false
			@invoice.complete = nil
			@invoice.update_attributes(params[:quotation])
			@invoice.complete = false
			@invoice.update_attributes(params[:quotation])
		       end
		       cookies.delete :invoice_id
		       redirect_to(manageitem_invoice_path(@invoice), :notice => 'Item was successfully updated.') }
         format.xml  { head :ok }
       else
         format.html { render :action => "edit" }
         format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
       end
     end
   end
   
   def cancleiteminvoice
     
     @invoice = Invoice.find(cookies[:invoice_id])
     @quotation = Quotation.find(@invoice.ref_id)
     @item = @quotation.items.find(params[:id])
     @item.invoice_id = nil   
     
     
     respond_to do |format|
       if @item.update_attributes(params[:item])
         format.html { if @invoice.complete == nil || @invoice.complete == false
			@invoice.complete = nil
			@invoice.update_attributes(params[:quotation])
			@invoice.complete = false
			@invoice.update_attributes(params[:quotation])
		       end
		       cookies.delete :invoice_id
		       redirect_to(manageitem_invoice_path(@invoice), :notice => 'Item was successfully updated.') }
         format.xml  { head :ok }
       else
         format.html { render :action => "edit" }
         format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
       end
     end
   end
  
end
