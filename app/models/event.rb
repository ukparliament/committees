class Event < ApplicationRecord
  
  belongs_to :location, optional: true
  belongs_to :event_type
  
  def display_name
    self.name || 'Untitled'
  end
  
  def times
    times = self.start_at.strftime( '%A %-d %B %Y @ %H:%M') + ' - '
    times += self.end_at.strftime( '%A %-d %B %Y @ %H:%M') if self.end_at
    times
  end
  
  def location_display
    location_display = ''
    if self.normalised_location_name
      location_display = self.normalised_location_name
    else
      location_display = self.location_name
    end
    location_display
  end
end
