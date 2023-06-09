class WorkPackage < ApplicationRecord
  
  belongs_to :work_package_type
  
  def dates
    dates = self.open_on.strftime( '%A %-d %B %Y') + ' - '
    dates += self.close_on.strftime( '%A %-d %B %Y') if self.close_on
    dates
  end
  
  def committees
    Committee.find_by_sql(
      "
        SELECT c1.*, sub_committees.sub_committee_count
        FROM committees c1
        
        -- We want a count of sub-commitees, if any, so we left join.
        LEFT JOIN (
          SELECT c2.parent_committee_id, count(c2.id) as sub_committee_count
          FROM committees c2
          GROUP BY c2.parent_committee_id
        ) sub_committees
        ON c1.id = sub_committees.parent_committee_id
        
        -- We only want committees associated with this work package, so we inner join to committee_work_packages.
        INNER JOIN (
          SELECT cwp.committee_id AS committee_id
          FROM committee_work_packages cwp
          WHERE cwp.work_package_id = #{self.id}
        ) committee_work_packages
        ON c1.id = committee_work_packages.committee_id
        ORDER BY c1.name;
      "
    )
  end
  
  def oral_evidence_transcripts
    OralEvidenceTranscript.find_by_sql(
      "
        SELECT oet.*
        FROM oral_evidence_transcripts oet
        
        -- We only want oral evidence transcripts associated with this work package, so we inner join to work_package_oral_evidence_transcripts.
        INNER JOIN (
          SELECT wpoet.oral_evidence_transcript_id AS oral_evidence_transcript_id
          FROM work_package_oral_evidence_transcripts wpoet
          WHERE wpoet.work_package_id = #{self.id}
        ) work_package_oral_evidence_transcript
        ON oet.id = work_package_oral_evidence_transcript.oral_evidence_transcript_id
        ORDER BY oet.published_on desc, oet.start_on desc;
      "
    )
  end
end
