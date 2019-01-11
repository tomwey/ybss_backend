class Company < ActiveRecord::Base
  belongs_to :house
  has_many :employees
end
