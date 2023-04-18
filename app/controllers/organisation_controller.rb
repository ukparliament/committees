class OrganisationController < ApplicationController
  
  def index
    @page_title = 'Organisations'
    @organisations = Organisation.find_by_sql(
      "
        SELECT o.*, COUNT(p.id) AS position_count
        FROM organisations o, positions p
        WHERE o.id = p.organisation_id
        GROUP BY o.id
        ORDER BY o.name
      "
    )
  end
  
  def show
    organisation = params[:organisation]
    @organisation = Organisation.find_by_system_id( organisation )
    @page_title = @organisation.name
  end
end
