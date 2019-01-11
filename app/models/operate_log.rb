class OperateLog < ActiveRecord::Base
  belongs_to :operateable, polymorphic: true
  belongs_to :user, foreign_key: :owner_id
  belongs_to :house
end
