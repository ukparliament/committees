# == Schema Information
#
# Table name: positions
#
#  id              :integer          not null, primary key
#  name            :string(255)      not null
#  organisation_id :integer          not null
#
# Foreign Keys
#
#  fk_organisation  (organisation_id => organisations.id)
#
class Position < ApplicationRecord
  
  belongs_to :organisation
  
  def witnesses
    Witness.find_by_sql(
      "
        SELECT w.*, oet.published_on AS oral_evidence_transcript_published_on, oet.system_id AS oral_evidence_transcript_system_id
        FROM oral_evidence_transcripts oet, witnesses w, witness_positions wp
        WHERE oet.id = w.oral_evidence_transcript_id
        AND w.id = wp.witness_id
        AND wp.position_id =  #{self.id}
      "
    )
  end
  
  def oral_evidence_transcripts
    OralEvidenceTranscript.find_by_sql(
      "
        SELECT oet.*
        FROM oral_evidence_transcripts oet, witnesses w, witness_positions wp
        WHERE oet.id = w.oral_evidence_transcript_id
        AND w.id = wp.witness_id
        AND wp.position_id = #{self.id}
        ORDER BY oet.published_on desc
      "
    )
  end
  
  def oral_evidence_transcripts_limited
    OralEvidenceTranscript.find_by_sql(
      "
        SELECT oet.*
        FROM oral_evidence_transcripts oet, witnesses w, witness_positions wp
        WHERE oet.id = w.oral_evidence_transcript_id
        AND w.id = wp.witness_id
        AND wp.position_id = #{self.id}
        ORDER BY oet.published_on desc
        LIMIT 20
      "
    )
  end
end
