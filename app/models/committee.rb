# == Schema Information
#
# Table name: committees
#
#  id                          :integer          not null, primary key
#  address                     :string(500)
#  commons_appointed_on        :date
#  contact_disclaimer          :string(500)
#  email                       :string(500)
#  end_on                      :date
#  is_lead_committee           :boolean          default(FALSE)
#  is_redirect_enabled         :boolean          default(FALSE)
#  is_shown_on_website         :boolean          default(FALSE)
#  legacy_url                  :string(500)
#  lords_appointed_on          :date
#  name                        :string(255)      not null
#  phone                       :string(500)
#  start_on                    :date
#  lead_parliamentary_house_id :integer
#  parent_committee_id         :integer
#  system_id                   :integer          not null
#
# Foreign Keys
#
#  fk_lead_parliamentary_house  (lead_parliamentary_house_id => parliamentary_houses.id)
#  fk_parent_committee          (parent_committee_id => committees.id)
#
class Committee < ApplicationRecord
  
  has_many :publications, -> { order( 'start_at desc' ) }
  
  def publications_limited
    Publication.find_by_sql([
      "
        SELECT *
        FROM publications
        WHERE committee_id = ?
        ORDER BY start_at DESC
        LIMIT 20
      ", id
    ])
  end
  
  def parent_committee
    Committee.find( self.parent_committee_id ) if self.parent_committee_id
  end
  
  def sub_committees
    Committee.find_by_sql([
      "
        SELECT c1.*, sub_committees.sub_committee_count
        FROM committees c1
        
        LEFT JOIN (
          SELECT c2.parent_committee_id, count(c2.id) as sub_committee_count
          FROM committees c2
          GROUP BY c2.parent_committee_id
        ) sub_committees
        ON c1.id = sub_committees.parent_committee_id
        
        WHERE c1.parent_committee_id = ?
        ORDER BY c1.name;
      ", id
    ])
  end
  
  def parliamentary_houses
    ParliamentaryHouse.find_by_sql([
      "
        SELECT ph.*
        FROM parliamentary_houses ph, committee_houses ch
        WHERE ph.id = ch.parliamentary_house_id
        AND ch.committee_id = ?
      ", id
    ])
  end
  
  def lead_parliamentary_house
    ParliamentaryHouse.find( self.lead_parliamentary_house_id ) if self.lead_parliamentary_house_id
  end
  
  def committee_types
    CommitteeType.find_by_sql([
      "
        SELECT ct.*
        FROM committee_types ct, committee_committee_types cct
        WHERE ct.id = cct.committee_type_id
        AND cct.committee_id = ?
      ", id
    ])
  end
  
  def departments
    Department.find_by_sql([
      "
        SELECT d.*
        FROM departments d, scrutinisings s
        WHERE d.id = s.department_id
        AND s.committee_id = ?
      ", id
    ])
  end
  
  def contactable?
    contactable = false
    contactable = true if self.address || self.email || self.phone
  end
  
  def all_work_packages
    WorkPackage.find_by_sql([
      "
        SELECT wp.*
        FROM work_packages wp
      
        -- We only want work packages associated with this committee, so we inner join to committee_work_packages.
        INNER JOIN (
          SELECT cwp.work_package_id AS work_package_id
          FROM committee_work_packages cwp
          WHERE cwp.committee_id = ?
        ) committee_work_packages
        ON wp.id = committee_work_packages.work_package_id
        ORDER BY open_on desc, close_on desc;
      ", id
    ])
  end
  
  def current_work_packages
    WorkPackage.find_by_sql([
      "
        SELECT wp.*
        FROM work_packages wp
      
        -- We only want work packages associated with this committee, so we inner join to committee_work_packages.
        INNER JOIN (
          SELECT cwp.work_package_id AS work_package_id
          FROM committee_work_packages cwp
          WHERE cwp.committee_id = ?
        ) committee_work_packages
        ON wp.id = committee_work_packages.work_package_id
        
        WHERE ( wp.close_on is NULL or wp.close_on >= CURRENT_DATE )
        ORDER BY open_on desc, close_on desc;
      ", id
    ])
  end
  
  def current_work_packages_limited
    WorkPackage.find_by_sql([
      "
        SELECT wp.*
        FROM work_packages wp
      
        -- We only want work packages associated with this committee, so we inner join to committee_work_packages.
        INNER JOIN (
          SELECT cwp.work_package_id AS work_package_id
          FROM committee_work_packages cwp
          WHERE cwp.committee_id = ?
        ) committee_work_packages
        ON wp.id = committee_work_packages.work_package_id
        
        WHERE ( wp.close_on is NULL or wp.close_on >= CURRENT_DATE )
        ORDER BY open_on desc, close_on desc
        LIMIT 20;
      ", id
    ])
  end
  
  def all_events
    Event.find_by_sql([
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
          WHERE ce.committee_id = ?
        ) committee_event
        ON e.id = committee_event.event_id
    
        ORDER BY e.start_at
      ", id
    ])
  end
  
  def upcoming_events
    Event.find_by_sql([
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
          WHERE ce.committee_id = ?
        ) committee_event
        ON e.id = committee_event.event_id
        
        WHERE e.start_at >= NOW()
        AND e.cancelled_at is NULL
    
        ORDER BY e.start_at
      ", id
    ])
  end
  
  def oral_evidence_transcripts
    OralEvidenceTranscript.find_by_sql([
      "
        SELECT oet.*
        FROM oral_evidence_transcripts oet, committee_oral_evidence_transcripts coet
        WHERE oet.id = coet.oral_evidence_transcript_id
        AND coet.committee_id = ?
        ORDER BY oet.published_on desc
      ", id
    ])
  end
  
  def oral_evidence_transcripts_limited
    OralEvidenceTranscript.find_by_sql([
      "
        SELECT oet.*
        FROM oral_evidence_transcripts oet, committee_oral_evidence_transcripts coet
        WHERE oet.id = coet.oral_evidence_transcript_id
        AND coet.committee_id = ?
        ORDER BY oet.published_on desc
        LIMIT 20
      ", id
    ])
  end
  
  def all_memberships
    Membership.find_by_sql([
      "
        SELECT m.*, p.name AS person_name, r.name AS role_name
        FROM memberships m, people p, roles r
        WHERE m.person_id = p.id
        AND m.role_id = r.id
        AND m.committee_id = ?
        ORDER BY m.start_on, role_name, person_name
      ", id
    ])
  end
  
  def current_memberships
    Membership.find_by_sql([
      "
        SELECT m.*, p.name AS person_name, r.name AS role_name
        FROM memberships m, people p, roles r
        WHERE m.person_id = p.id
        AND m.role_id = r.id
        AND m.committee_id = ?
        AND ( m.end_on IS NULL OR m.end_on > CURRENT_DATE )
        ORDER BY m.start_on, role_name, person_name
      ", id
    ])
  end
  
  def publication_types
    PublicationType.find_by_sql([
      "
        SELECT pt.*, count(p.id) AS publication_count
        FROM publication_types pt, publications p
        WHERE p.publication_type_id = pt.id
        AND p.committee_id = ?
        GROUP BY pt.id
        ORDER BY pt.name
      ", id
    ])
  end
  
  def publications_of_type( publication_type )
    Publication.find_by_sql([
      "
        SELECT p.*
        FROM publications p
        WHERE p.publication_type_id = #{publication_type.id}
        AND p.committee_id = ?
        ORDER BY start_at desc
      ", id
    ])
  end
  
  def publications_of_type_limited( publication_type )
    Publication.find_by_sql([
      "
        SELECT p.*
        FROM publications p
        WHERE p.publication_type_id = :publication_type_id
        AND p.committee_id = :committee_id
        ORDER BY start_at desc
        LIMIT 20
      ", committee_id: id, publication_type_id: publication_type.id
    ])
  end
end
