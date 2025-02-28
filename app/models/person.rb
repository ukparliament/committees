# == Schema Information
#
# Table name: people
#
#  id        :integer          not null, primary key
#  name      :string(1000)     not null
#  mnis_id   :integer
#  system_id :integer
#
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
  
  def oral_evidence_transcripts
    OralEvidenceTranscript.find_by_sql(
      "
        SELECT oet.*
        FROM oral_evidence_transcripts oet, witnesses w
        WHERE oet.id = w.oral_evidence_transcript_id
        AND w.person_id = #{self.id}
        ORDER BY oet.published_on desc
        LIMIT 20
      "
    )
  end
  
  def committee_memberships
    Membership.find_by_sql(
      "
        SELECT m.*, c.name AS committee_name, c.system_id AS committee_system_id, r.name AS role_name
        FROM memberships m, committees c, roles r
        WHERE m.person_id = #{self.id}
        AND m.committee_id = c.id
        AND m.role_id = r.id
        ORDER BY m.start_on desc, m.end_on desc, role_name
      "
    )
  end
end
