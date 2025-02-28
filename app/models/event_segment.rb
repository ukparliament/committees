# == Schema Information
#
# Table name: event_segments
#
#  id               :integer          not null, primary key
#  end_at           :datetime
#  is_private       :boolean          default(FALSE)
#  name             :string(255)
#  start_at         :datetime         not null
#  activity_type_id :integer          not null
#  event_id         :integer          not null
#  system_id        :integer          not null
#
# Foreign Keys
#
#  fk_activity_type  (activity_type_id => activity_types.id)
#  fk_event          (event_id => events.id)
#
class EventSegment < ApplicationRecord
  
  belongs_to :event
  belongs_to :activity_type
  
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
  
  def oral_evidence_transcripts
    OralEvidenceTranscript.find_by_sql(
      "
        SELECT oet.*
        FROM oral_evidence_transcripts oet
        WHERE oet.event_segment_id = #{self.id}
        ORDER BY oet.published_on
      "
    )
  end
end
