class PersonAddrTrace < ActiveRecord::Base
  validates :person_id, :address, presence: true
end
