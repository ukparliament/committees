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
end
