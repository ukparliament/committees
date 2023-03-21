class JointController < ApplicationController
  
  def index
    @page_title = 'Joint committees'
    
    # NOTE: how do we make this into one query?
    
    # We get all committees with a count of the Houses they belong to.
    committees = Committee.find_by_sql(
      "
        SELECT c.*, COUNT(ch.id) as committee_house_count
        FROM committees c, committee_houses ch
        WHERE c.id = ch.committee_id
        GROUP BY c.id
        ORDER BY c.name
      "
    )
    @committees = []
    
    # For each committee, in the committees array ...
    committees.each do |committee|
      
      # ... we add the committee to the committees array if they're linked to both Houses.
      @committees << committee if committee.committee_house_count == 2
    end
  end
end
