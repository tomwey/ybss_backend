class BuildingUnitHouse < ActiveRecord::Base
  belongs_to :house
  belongs_to :address
  belongs_to :building
  belongs_to :unit
end
