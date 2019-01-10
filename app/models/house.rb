class House < ActiveRecord::Base
  validates :image, :use_type, :mgr_level, presence: true
  mount_uploader :image, CoverImageUploader
  
  before_save :remove_blank_value_for_array
  def remove_blank_value_for_array
    self.house_use = self.house_use.compact.reject(&:blank?)
  end
  
  validate :require_house_use
  def require_house_use
    if house_use.empty?
      errors.add(:house_use, "房屋用途不能为空")
      return false
    end
  end
end
