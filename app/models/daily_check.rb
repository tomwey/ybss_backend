class DailyCheck < ActiveRecord::Base
  validates :has_man, :check_on, :memo, presence: true
  mount_uploaders :images, CoverImageUploader
end
