class Event < ApplicationRecord
  
  belongs_to :location, optional: true
  belongs_to :event_type
end
