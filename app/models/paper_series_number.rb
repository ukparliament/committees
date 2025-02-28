# == Schema Information
#
# Table name: paper_series_numbers
#
#  id                              :integer          not null, primary key
#  number                          :string(255)      not null
#  oral_evidence_transcript_id     :integer
#  parliamentary_house_id          :integer          not null
#  publication_id                  :integer
#  session_id                      :integer          not null
#  written_evidence_publication_id :integer
#
# Foreign Keys
#
#  fk_oral_evidence_transcript      (oral_evidence_transcript_id => oral_evidence_transcripts.id)
#  fk_parliamentary_house           (parliamentary_house_id => parliamentary_houses.id)
#  fk_publication                   (publication_id => publications.id)
#  fk_session                       (session_id => sessions.id)
#  fk_written_evidence_publication  (oral_evidence_transcript_id => oral_evidence_transcripts.id)
#
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
