class HouseOfCommonsNumber < ApplicationRecord
  
  belongs_to :session
  belongs_to :oral_evidence_transcript
  
  def display_number
    display_number = self.number
    display_number += ' (' + self.session_label + ')'
    display_number
  end
end
