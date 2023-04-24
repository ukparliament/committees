class Person < ApplicationRecord
  
  def witnesses
    Witness.find_by_sql(
      "
        SELECT w.*, oet.published_on AS oral_evidence_transcript_published_on, oet.system_id AS oral_evidence_transcript_system_id
        FROM oral_evidence_transcripts oet, witnesses w
        WHERE oet.id = w.oral_evidence_transcript_id
        AND w.person_id =  #{self.id}
      "
    )
  end
end
