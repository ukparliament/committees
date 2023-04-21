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
  
  def person_display_name
    person_display_name = ''
    if self.person_name
      person_display_name = self.person_name
    else
      person_display_name = 'No witness name given'
    end
  end
end
