class Address < ActiveRecord::Base
  validates :name, :addr_id, presence: true
  validates_uniqueness_of :addr_id
  
  belongs_to :house
  
  def self.valid_addresses
    where(has_child: true).where(house_id: nil)
  end
end
