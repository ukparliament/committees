class Committee < ApplicationRecord
  
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
end
