class ParliamentaryHouse < ApplicationRecord
  
  def committees
    Committee.find_by_sql(
      "
        SELECT c.*
        FROM committees c, committee_houses ch
        WHERE c.id = ch.committee_id
        AND ch.parliamentary_house_id = #{self.id}
      "
    )
  end
end
