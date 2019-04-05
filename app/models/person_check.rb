class PersonCheck < ActiveRecord::Base
  validates :person_id, :check_status, presence: true
end
