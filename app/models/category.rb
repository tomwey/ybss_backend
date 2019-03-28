class Category < ActiveRecord::Base
  validates :name, presence: true
  
  def has_child
    Category.where(pid: self.id).count > 0
  end
end
