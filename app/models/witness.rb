class Witness < ApplicationRecord
  
  belongs_to :oral_evidence_transcript
  belongs_to :person, optional: true
  
  def positions
    Position.find_by_sql(
      "
        SELECT p.*, o.name AS organisation_name
        FROM positions p, organisations o, witness_positions wp
        WHERE p.organisation_id = o.id
        AND p.id = wp.position_id
        AND wp.witness_id = #{self.id}
      "
    )
  end
end
