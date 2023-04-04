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
  
  # A method to escape commas in locations.
  # The ICS spec makes no mention of this being necessary: https://www.kanzaki.com/docs/ical/location.html
  # But locations get trunacted on commas in Apple calendar if you don't.
  def location_display_escaped_for_ics
    self.location_display.gsub( ',', '\,')
  end
  
  def committees
    Committee.find_by_sql(
      "
        SELECT c1.*, sub_committees.sub_committee_count
        FROM committees c1
        
        -- We want a count of sub-committees, if any, so we left join.
        LEFT JOIN (
          SELECT c2.parent_committee_id, count(c2.id) as sub_committee_count
          FROM committees c2
          GROUP BY c2.parent_committee_id
        ) sub_committees
        ON c1.id = sub_committees.parent_committee_id
        
        -- We only want committees associated with this event, so we inner join to committee_events.
        INNER JOIN (
          SELECT ce.committee_id as committee_id
          FROM committee_events ce
          WHERE ce.event_id = #{self.id}
        ) committee_event
        ON c1.id = committee_event.committee_id
        
        -- We only want non-sub-committees committees, so we check parent_committee_id is null.
        WHERE c1.parent_committee_id is null
        ORDER BY c1.name;
      "
    )
  end
  
  def event_segments
    EventSegment.find_by_sql(
      "
        SELECT es.*, e.location_name as location_name, l.name as normalised_location_name, at.name AS activity_type_name
        FROM event_segments es
      
        INNER JOIN activity_types at
        ON es.activity_type_id = at.id
      
        INNER JOIN events e
        ON e.id = es.event_id
      
      
        LEFT JOIN locations l
        ON e.location_id = l.id
      
        WHERE es.event_id = #{self.id}
        ORDER BY es.start_at;
      "
    )
  end
end
