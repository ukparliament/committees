class Position < ApplicationRecord
  
  belongs_to :organisation
  
  def witnesses
    Witness.find_by_sql(
      "
        SELECT w.*, oet.published_on as oral_evidence_transcript_published_on
        FROM oral_evidence_transcripts oet, witnesses w, witness_positions wp
        WHERE oet.id = w.oral_evidence_transcript_id
        AND w.id = wp.witness_id
        AND wp.position_id =  #{self.id}
      "
    )
  end
end
