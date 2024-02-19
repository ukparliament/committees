class Committee < ApplicationRecord
  
  has_many :publications, -> { order( 'start_at desc' ) }
  
  def publications_limited
    Publication.find_by_sql(
      "
        SELECT *
        FROM publications
        WHERE committee_id = #{self.id}
        ORDER BY start_at DESC
        LIMIT 20
      "
    )
  end
  
  def parent_committee
    Committee.find( self.parent_committee_id ) if self.parent_committee_id
  end
  
  def sub_committees
    Committee.find_by_sql(
      "
        SELECT c1.*, sub_committees.sub_committee_count
        FROM committees c1
        
        LEFT JOIN (
          SELECT c2.parent_committee_id, count(c2.id) as sub_committee_count
          FROM committees c2
          GROUP BY c2.parent_committee_id
        ) sub_committees
        ON c1.id = sub_committees.parent_committee_id
        
        WHERE c1.parent_committee_id = #{self.id}
        ORDER BY c1.name;
      "
    )
  end
  
  def parliamentary_houses
    ParliamentaryHouse.find_by_sql(
      "
        SELECT ph.*
        FROM parliamentary_houses ph, committee_houses ch
        WHERE ph.id = ch.parliamentary_house_id
        AND ch.committee_id = #{self.id}
      "
    )
  end
  
  def lead_parliamentary_house
    ParliamentaryHouse.find( self.lead_parliamentary_house_id ) if self.lead_parliamentary_house_id
  end
  
  def committee_types
    CommitteeType.find_by_sql(
      "
        SELECT ct.*
        FROM committee_types ct, committee_committee_types cct
        WHERE ct.id = cct.committee_type_id
        AND cct.committee_id = #{self.id}
      "
    )
  end
  
  def departments
    Department.find_by_sql(
      "
        SELECT d.*
        FROM departments d, scrutinisings s
        WHERE d.id = s.department_id
        AND s.committee_id = #{self.id}
      "
    )
  end
  
  def contactable?
    contactable = false
    contactable = true if self.address || self.email || self.phone
  end
  
  def all_work_packages
    WorkPackage.find_by_sql(
      "
        SELECT wp.*
        FROM work_packages wp
      
        -- We only want work packages associated with this committee, so we inner join to committee_work_packages.
        INNER JOIN (
          SELECT cwp.work_package_id AS work_package_id
          FROM committee_work_packages cwp
          WHERE cwp.committee_id = #{self.id}
        ) committee_work_packages
        ON wp.id = committee_work_packages.work_package_id
        ORDER BY open_on desc, close_on desc;
      "
    )
  end
  
  def current_work_packages
    WorkPackage.find_by_sql(
      "
        SELECT wp.*
        FROM work_packages wp
      
        -- We only want work packages associated with this committee, so we inner join to committee_work_packages.
        INNER JOIN (
          SELECT cwp.work_package_id AS work_package_id
          FROM committee_work_packages cwp
          WHERE cwp.committee_id = #{self.id}
        ) committee_work_packages
        ON wp.id = committee_work_packages.work_package_id
        
        WHERE ( wp.close_on is NULL or wp.close_on >= '#{Date.today}' )
        ORDER BY open_on desc, close_on desc;
      "
    )
  end
  
  def current_work_packages_limited
    WorkPackage.find_by_sql(
      "
        SELECT wp.*
        FROM work_packages wp
      
        -- We only want work packages associated with this committee, so we inner join to committee_work_packages.
        INNER JOIN (
          SELECT cwp.work_package_id AS work_package_id
          FROM committee_work_packages cwp
          WHERE cwp.committee_id = #{self.id}
        ) committee_work_packages
        ON wp.id = committee_work_packages.work_package_id
        
        WHERE ( wp.close_on is NULL or wp.close_on >= '#{Date.today}' )
        ORDER BY open_on desc, close_on desc
        LIMIT 20;
      "
    )
  end
  
  def all_events
    Event.find_by_sql(
      "
        SELECT e.*, location.normalised_location_name
        FROM events e
        
        LEFT JOIN (
          SELECT l.id as location_id, l.name as normalised_location_name
          FROM locations l
        ) location
        ON e.location_id = location.location_id
        
        -- We only want events associated with this committee, so we inner join to committee_events.
        INNER JOIN (
          SELECT ce.event_id as event_id
          FROM committee_events ce
          WHERE ce.committee_id = #{self.id}
        ) committee_event
        ON e.id = committee_event.event_id
    
        ORDER BY e.start_at
      "
    )
  end
  
  def upcoming_events
    Event.find_by_sql(
      "
        SELECT e.*, location.normalised_location_name
        FROM events e
        
        LEFT JOIN (
          SELECT l.id as location_id, l.name as normalised_location_name
          FROM locations l
        ) location
        ON e.location_id = location.location_id
        
        -- We only want events associated with this committee, so we inner join to committee_events.
        INNER JOIN (
          SELECT ce.event_id as event_id
          FROM committee_events ce
          WHERE ce.committee_id = #{self.id}
        ) committee_event
        ON e.id = committee_event.event_id
        
        WHERE e.start_at >= '#{Time.now}'
        AND e.cancelled_at is NULL
    
        ORDER BY e.start_at
      "
    )
  end
  
  def oral_evidence_transcripts
    OralEvidenceTranscript.find_by_sql(
      "
        SELECT oet.*
        FROM oral_evidence_transcripts oet, committee_oral_evidence_transcripts coet
        WHERE oet.id = coet.oral_evidence_transcript_id
        AND coet.committee_id = #{self.id}
        ORDER BY oet.published_on desc
      "
    )
  end
  
  def oral_evidence_transcripts_limited
    OralEvidenceTranscript.find_by_sql(
      "
        SELECT oet.*
        FROM oral_evidence_transcripts oet, committee_oral_evidence_transcripts coet
        WHERE oet.id = coet.oral_evidence_transcript_id
        AND coet.committee_id = #{self.id}
        ORDER BY oet.published_on desc
        LIMIT 20
      "
    )
  end
  
  def all_memberships
    Membership.find_by_sql(
      "
        SELECT m.*, p.name AS person_name, r.name AS role_name
        FROM memberships m, people p, roles r
        WHERE m.person_id = p.id
        AND m.role_id = r.id
        AND m.committee_id = #{self.id}
        ORDER BY m.start_on, role_name, person_name
      "
    )
  end
  
  def current_memberships
    Membership.find_by_sql(
      "
        SELECT m.*, p.name AS person_name, r.name AS role_name
        FROM memberships m, people p, roles r
        WHERE m.person_id = p.id
        AND m.role_id = r.id
        AND m.committee_id = #{self.id}
        AND ( m.end_on IS NULL OR m.end_on > '#{Date.today}' )
        ORDER BY m.start_on, role_name, person_name
      "
    )
  end
  
  def publication_types
    PublicationType.find_by_sql(
      "
        SELECT pt.*, count(p.id) AS publication_count
        FROM publication_types pt, publications p
        WHERE p.publication_type_id = pt.id
        AND p.committee_id = #{self.id}
        GROUP BY pt.id
        ORDER BY pt.name
      "
    )
  end
  
  def publications_of_type( publication_type )
    Publication.find_by_sql(
      "
        SELECT p.*
        FROM publications p
        WHERE p.publication_type_id = #{publication_type.id}
        AND p.committee_id = #{self.id}
        ORDER BY start_at desc
      "
    )
  end
  
  def publications_of_type_limited( publication_type )
    Publication.find_by_sql(
      "
        SELECT p.*
        FROM publications p
        WHERE p.publication_type_id = #{publication_type.id}
        AND p.committee_id = #{self.id}
        ORDER BY start_at desc
        LIMIT 20
      "
    )
  end
end
