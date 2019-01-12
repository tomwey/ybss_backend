class OperateLog < ActiveRecord::Base
  belongs_to :operateable, polymorphic: true
  belongs_to :user, foreign_key: :owner_id
  belongs_to :house
  
  def format_title
    if operateable_type == "House"
      self.title
    else
      case operateable_type
      when "PropertyInfo" then "#{self.action}产权人信息"
      when "Person" then "#{self.action}实有人口"
      when "Company" then "#{self.action}实有单位"
      when "Employee" then "#{self.action}从业人员"
      when "DailyCheck" then "#{self.action}从业人员"
      else self.title
      end
    end
  end
end
