Appbill::Application.routes.draw do
  
  resources :provinces

  resources :docs

#   get "home/index"
  
  get "alert/index"
  
  get "documents/dwait" #รอ
  get "documents/dcomplete" #ออกใบส่งของครบ
  get "documents/dnotcomplete" #ออกใบส่งของไม่ครบ
  
  get "quotations/qwait" #รอผลอนุมัติ
  get "quotations/qcomplete" #ออกใบส่งของครบ
  get "quotations/qnotcomplete" #ออกใบส่งของไม่ครบ
  
  get "invoices/iwait" #รอจ่ายเงิน
  get "invoices/icomplete" #ออกบิลแล้ว
  get "invoices/inotcomplete" #ยังไม่ออกบิล
  
  get "bills/bwait" #รอส่งลูกค้า
  get "bills/bcomplete" #ออกใบกำกับภาษีแล้ว
  get "bills/bnotcomplete" #ยังไม่ออกใบกำกับภาษี
  
  get "taxinvoices/twait" #รอส่งลูกค้า
  get "taxinvoices/tcomplete" #ส่งใบให้ลูกค้าแล้ว
  
  get "billtaxinvoices/btwait" #รอส่งลูกค้า
  get "billtaxinvoices/btcomplete" #ส่งใบให้ลูกค้าแล้ว
  
  get "receipts/rwait" #รอส่งลูกค้า
  get "receipts/rcomplete" #ส่งใบให้ลูกค้าแล้ว
  
  resources :companies
  resources :customers
  
  resources :documents

  
  resources :quotations do
    resources :items do 
      member do
	get 'additeminvoice'
	get 'cancleiteminvoice'
      end
    end
    member do
#       get 'print'
      get 'printred'
      get 'printwhite'
      get 'printblue'
      get 'manageitem'
      get 'nextdoc'
#       get 'quotationnotcomplete'
    end
  end
  
  resources :invoices do
    resources :items 
    member do
      get 'changedoc'
      get 'printred'
      get 'printwhite'
      get 'printblue'
      get 'manageitem'
      get 'nextbill'
      get 'nextbilltaxinvoice'
    end
  end
  
  resources :bills do
    resources :items
    member do
      get 'changecolor'
      get 'printred'
      get 'printwhite'
      get 'printblue'
      get 'manageitem'
      get 'nextdoc'
    end
  end
  
  resources :taxinvoices do
    resources :items 
    member do
      get 'printred'
      get 'printwhite'
      get 'printblue'
      get 'manageitem'
      get 'nextdoc'
    end
  end
  
  resources :billtaxinvoices do
    resources :items 
    member do
      get 'printred'
      get 'printwhite'
      get 'printblue'
      get 'manageitem'
      get 'nextdoc'
    end
  end
  
  resources :receipts do
     resources :items 
    member do
      get 'printred'
      get 'printwhite'
      get 'printblue'
      get 'manageitem'
      get 'nextdoc'
    end
  end

  

  

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  
  root :to => "documents#index"
  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
