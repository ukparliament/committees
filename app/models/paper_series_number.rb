class PaperSeriesNumber < ApplicationRecord
  
  belongs_to :oral_evidence_transcript, optional: true
  belongs_to :written_evidence_publication, optional: true
  belongs_to :publication, optional: true
  belongs_to :session
  belongs_to :parliamentary_house
  
  def display_number
    display_number = self.number
    display_number += ' (' + self.session_label + ')'
    display_number
  end
end
