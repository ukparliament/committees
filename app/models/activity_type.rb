class ActivityType < ApplicationRecord
  
  belongs_to :event
  belongs_to :activity_type
end
