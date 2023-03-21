class Committee < ApplicationRecord
  
  def parent_committee
    Committee.find( self.parent_committee_id ) if self.parent_committee_id
  end
  
  def sub_committees
    Committee.all.where( "parent_committee_id = ?", self ).order( 'name' )
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
end
