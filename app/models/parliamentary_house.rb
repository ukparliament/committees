# == Schema Information
#
# Table name: parliamentary_houses
#
#  id          :integer          not null, primary key
#  label       :string(255)      not null
#  short_label :string(255)      not null
#
class ParliamentaryHouse < ApplicationRecord
  
  def all_committees
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
        
        -- We only want committees belonging to this House, so we inner join to committee houses.
        INNER JOIN (
          SELECT ch.committee_id as committee_id
          FROM committee_houses ch
          WHERE ch.parliamentary_house_id = #{self.id}
        ) parliamentary_house
        ON c1.id = parliamentary_house.committee_id

        -- We don't want joint committees, so we left join to committee houses to get a House count ...
        LEFT JOIN (
          SELECT ch.committee_id as committee_id, COUNT(ch.id) AS house_count
          FROM committee_houses ch
          GROUP BY ch.committee_id
        ) parliamentary_house_count
        ON c1.id = parliamentary_house_count.committee_id
        
        -- ... and only bring back committees belonging to one House.
        WHERE parliamentary_house_count.house_count = 1
        
        -- We only want non-sub-committees committees, so we check parent_committee_id is null.
        AND c1.parent_committee_id is null
        ORDER BY c1.name;
      "
    )
  end
  
  def current_committees
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
        
        -- We only want committees belonging to this House, so we inner join to committee houses.
        INNER JOIN (
          SELECT ch.committee_id as committee_id
          FROM committee_houses ch
          WHERE ch.parliamentary_house_id = #{self.id}
        ) parliamentary_house
        ON c1.id = parliamentary_house.committee_id

        -- We don't want joint committees, so we left join to committee houses to get a House count ...
        LEFT JOIN (
          SELECT ch.committee_id as committee_id, COUNT(ch.id) AS house_count
          FROM committee_houses ch
          GROUP BY ch.committee_id
        ) parliamentary_house_count
        ON c1.id = parliamentary_house_count.committee_id
        
        -- ... and only bring back committees belonging to one House.
        WHERE parliamentary_house_count.house_count = 1
        
        -- We only want current committees so we check for a NULL end date or an end date in the future.
        AND ( c1.end_on is NULL OR c1.end_on >= '#{Date.today}' )
        
        -- We only want non-sub-committees committees, so we check parent_committee_id is null.
        AND  c1.parent_committee_id is null
        
        AND c1.end_on is null
        ORDER BY c1.name;
      "
    )
  end
  
  def oral_evidence_transcripts
    OralEvidenceTranscript.find_by_sql(
      "
        SELECT oet.*
        FROM oral_evidence_transcripts oet, committee_oral_evidence_transcripts coet, committees c, committee_houses ch
        WHERE oet.id = coet.oral_evidence_transcript_id
        AND coet.committee_id = c.id
        AND c.id = ch.committee_id
        AND ch.parliamentary_house_id = #{self.id}
        GROUP BY oet.id
        ORDER BY oet.published_on desc, oet.start_on desc;
      "
    )
  end
  
  def oral_evidence_transcripts_limited
    OralEvidenceTranscript.find_by_sql(
      "
        SELECT oet.*
        FROM oral_evidence_transcripts oet, committee_oral_evidence_transcripts coet, committees c, committee_houses ch
        WHERE oet.id = coet.oral_evidence_transcript_id
        AND coet.committee_id = c.id
        AND c.id = ch.committee_id
        AND ch.parliamentary_house_id = #{self.id}
        GROUP BY oet.id
        ORDER BY oet.published_on desc, oet.start_on desc
        LIMIT 20;
      "
    )
  end
end
