class HouseUse < ActiveRecord::Base
  validates :name, :_type, :subtype, presence: true
end
