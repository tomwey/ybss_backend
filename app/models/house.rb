class House < ActiveRecord::Base
  validates :image, :use_type, :mgr_level, presence: true
  mount_uploader :image, ImageUploader
  
  has_one :address
  has_many :people
  has_many :companies
  has_many :operate_logs, -> { where.not(title: "扫码查询地址").order('id desc') }
  has_many :property_infos
  has_many :daily_checks
  
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
  
  def self.valid_houses
    house_ids = Address.where.not(house_id: nil).pluck(:house_id)
    # house_ids += BuildingUnitHouse.where.not(house_id: nil).pluck(:house_id)
    where.not(id: house_ids)
  end
end
