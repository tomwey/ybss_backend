class Article < ActiveRecord::Base
  validates :title, presence: true
  mount_uploader :cover, AvatarUploader
  validate :body_or_body_url_not_blank
  def body_or_body_url_not_blank
    if body.blank? and body_url.blank?
      errors.add(:base, '文章内容或文章地址至少一个必填')
      return false
    end
  end
end
