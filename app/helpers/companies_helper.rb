module CompaniesHelper
  
  def comp_link
    if Company.find(:all).empty?
      new_company_path
    else
      company_path(Company.first)
    end
  end
  
end
