class WorkPackage < ApplicationRecord
  
  belongs_to :work_package_type
  
  def dates
    dates = self.open_on.strftime( '%A %-d %B %Y') + ' - '
    dates += self.close_on.strftime( '%A %-d %B %Y') if self.close_on
    dates
  end
end
