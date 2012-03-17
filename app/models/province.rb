class Province < ActiveRecord::Base
    has_many :companies
    has_many :customers
end
