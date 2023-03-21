class HouseController < ApplicationController
  
  def index
    @page_title = 'Houses'
    @houses = ParliamentaryHouse.all.order( 'label' )
  end
  
  def show
    house = params[:house]
    @house = ParliamentaryHouse.find( house )
    @page_title = @house.label
    

    
    # NOTE: how do we make this into one query?
    
    # We get all committees associated with this House, with a count of the Houses they belong to.
    committees = Committee.find_by_sql(
      "
        SELECT c.*, COUNT(ch2.id) as committee_house_count
        FROM committees c, committee_houses ch1, committee_houses ch2
        WHERE c.id = ch1.committee_id
        AND ch1.parliamentary_house_id = #{@house.id}
        AND c.id = ch2.committee_id
        GROUP BY c.id
        ORDER BY c.name
      "
    )
    @committees = []
    
    # For each committee, in the committees array ...
    committees.each do |committee|
      
      # ... we add the committee to the committees array if they're linked to only one House.
      # This to remove any joint committees.
      @committees << committee if committee.committee_house_count == 1
    end
  end
end
