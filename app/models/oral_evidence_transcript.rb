class OralEvidenceTranscript < ApplicationRecord
  
  belongs_to :event_segment, optional: true
  has_many :oral_evidence_transcript_files
  
  def committees

    Committee.find_by_sql(
      "
        SELECT c.*, sub_committees.sub_committee_count
        FROM committees c
        
        -- We only want committees associated with this oral evidence, so we inner join.
        INNER JOIN (
          SELECT coet.oral_evidence_transcript_id as oral_evidence_transcript_id, coet.committee_id as committee_id
          FROM committee_oral_evidence_transcripts coet
          WHERE coet.oral_evidence_transcript_id = #{self.id}
        ) committee_oral_evidence_transcript
        ON committee_oral_evidence_transcript.committee_id = c.id
        
        -- We want a count of sub-commitees, if any, so we left join.
        LEFT JOIN (
          SELECT c.parent_committee_id, count(c.id) as sub_committee_count
          FROM committees c
          GROUP BY c.parent_committee_id
        ) sub_committees
        ON sub_committees.parent_committee_id = c.id
        ORDER BY c.name;
      "
    )
  end
  
  def work_packages
    WorkPackage.find_by_sql(
      "
        SELECT wp.*
        FROM work_packages wp
        
        -- We only want work packages associated with this oral evidence, so we inner join.
        INNER JOIN (
          SELECT wpoet.oral_evidence_transcript_id as oral_evidence_transcript_id, wpoet.work_package_id as work_package_id
          FROM work_package_oral_evidence_transcripts wpoet
          WHERE wpoet.oral_evidence_transcript_id = #{self.id}
        ) work_package_oral_evidence_transcript
        ON work_package_oral_evidence_transcript.work_package_id = wp.id
        
        ORDER BY wp.open_on desc, wp.close_on desc
      "
    )
  end
  
  def link
    "https://committees.parliament.uk/oralevidence/#{self.system_id}/html"
  end
  
  def preferred_link
    if self.document_id
      preferred_link = link
    elsif !self.legacy_html_url.blank?
      preferred_link = self.legacy_html_url
    elsif !self.legacy_pdf_url.blank?
      preferred_link = self.legacy_pdf_url
    end
    preferred_link
  end
  
  def display_label
    display_label = self.published_on
  end
  
  def paper_series_numbers
    PaperSeriesNumber.find_by_sql(
      "
        SELECT psn.*, s.label AS session_label
        FROM paper_series_numbers psn, sessions s
        WHERE psn.session_id = s.id
        AND psn.oral_evidence_transcript_id = #{self.id}
      "
    )
  end
  
  def witnesses
    Witness.find_by_sql(
      "
        SELECT w.*
        FROM witnesses w
        WHERE oral_evidence_transcript_id = #{self.id}
      "
    )
  end
end
