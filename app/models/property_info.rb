class PropertyInfo < ActiveRecord::Base
  validates :_type, :house_id, presence: true
  belongs_to :house
end
