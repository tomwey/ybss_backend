class Company < ActiveRecord::Base
  belongs_to :house
  has_many :employees
  
  
  def total_employees 
    self.employees.count
  end
  
  def baoan_count
    self.employees.where("job_type = ?", "保卫人员").count
  end
  def law_man
    @law_man ||= self.employees.where("job_type = ?", "法定代表人").first
  end
  def law_man_card_no
    @law_man.try(:card_no)
  end
  def law_man_name
    @law_man.try(:name)
  end
  def law_man_phone
    @law_man.try(:telephone)
  end
end
