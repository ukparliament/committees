# # A module for importing for the committee system API.
module IMPORT
  
  # ## A method to import committee types.
  def import_committee_types
    puts "Importing committee types"
    
    # We set the URL to import from.
    url = "https://committees-api.parliament.uk/api/CommitteeType"
    
    # We get the JSON.
    json = JSON.load( URI.open( url ) )
    
    # For each committee type item in the feed ...
    json.each do |committee_type_item|
      
      # ... we store the returned values.
      committee_type_item_system_id = committee_type_item['id']
      committee_type_item_name = committee_type_item['name']
      committee_type_item_category_system_id = committee_type_item['committeeCategory']['id']
      committee_type_item_category_name = committee_type_item['committeeCategory']['name']
      
      # We attempt to find the committee category.
      category = Category.find_by_system_id( committee_type_item_category_system_id )
      
      # If we don't find the committee category ...
      unless category
        
        # ... we create a new category.
        category = Category.new
        category.system_id = committee_type_item_category_system_id
        category.name = committee_type_item_category_name
        category.save
      end
      
      # We attempt to find the committee type.
      committee_type = CommitteeType.find_by_system_id( committee_type_item_system_id )
      
      # If we don't find the committee type ...
      unless committee_type
        
        # ... we create a new committee type.
        committee_type = CommitteeType.new
        committee_type.system_id = committee_type_item_system_id
        committee_type.name = committee_type_item_name
        committee_type.category = category
        committee_type.save
      end
    end
  end
  
  # A method to import all committees.
  def import_committees( skip )
    puts "importing committees"
    
    # We set the URL to import from.
    url = "https://committees-api.parliament.uk/api/Committees?CommitteeStatus=all&take=30&skip=#{skip}"
    
    # We get the JSON.
    json = JSON.load( URI.open( url ) )
    
    # For each committee item in the feed ....
    json['items'].each do |committee_item|
      
      # ... we import or update the committee.
      import_or_update_committee( committee_item )
    end
    
    # We get the total results count from the API.
    total_results = json['totalResults']
    
    # If the total results count is greater than the number of results skipped ...
    if total_results > skip
      
      # ... we call this method again, incrementing the skip by by 30 results.
      import_committees( skip + 30 )
    end
  end
  
  # A method to import all work package types.
  def import_work_package_types
    puts "Importing work package types"
    
    # We set the URL to import from.
    url = "https://committees-api.parliament.uk/api/CommitteeBusinessType"
    
    # We get the JSON.
    json = JSON.load( URI.open( url ) )
    
    # For each business type item in the feed ...
    json.each do |business_type_item|
      
      # ... we store the returned values.
      business_type_item_system_id = business_type_item['id']
      business_type_item_name = business_type_item['name']
      business_type_item_is_inquiry = business_type_item['isInquiry']
      business_type_item_description = business_type_item['description']
      
      # We attempt to find the work package type.
      work_package_type = WorkPackageType.find_by_system_id( business_type_item_system_id )
      
      # If we don't find work package type ...
      unless work_package_type
        
        # ... we create it.
        work_package_type = WorkPackageType.new
        work_package_type.name = business_type_item_name
        work_package_type.description = business_type_item_description
        work_package_type.is_inquiry = business_type_item_is_inquiry
        work_package_type.system_id = business_type_item_system_id
        work_package_type.save
      end
    end
  end
  
  
  
  # NOTE: should we creating work packages in link_committees_to_work_packages?
  # A method to import all work packages.
  def import_work_packages( skip )
    puts "importing work packages"
    
    # We set the URL to import from.
    url = "https://committees-api.parliament.uk/api/CommitteeBusiness?take=30&skip=#{skip}"
    
    # We get the JSON.
    json = JSON.load( URI.open( url ) )
    
    # For each work package item in the feed ....
    json['items'].each do |work_package|
      
      # ... we import or update the work package.
      import_or_update_work_package( work_package )
    end
    
    # We get the total results count from the API.
    total_results = json['totalResults']
    
    # If the total results count is greater than the number of results skipped ...
    if total_results > skip
      
      # ... we call this method again, incrementing the skip by by 30 results.
      import_work_packages( skip + 30 )
    end
  end
  
  # A method to get work packages for committees.
  def link_committees_to_work_packages
    puts "importing links between committees and work packages"
    
    # We get all the committeees.
    committees = Committee.all
    
    # For each committee ...
    committees.each do |committee|
      
      # ... we get the work packages.
      get_work_packages_for_committee( committee, 0 )
    end
  end
  
  # A method to get work packages for a committee.
  def get_work_packages_for_committee( committee, skip )
    
    # We set the URL to import from.
    url = "https://committees-api.parliament.uk/api/CommitteeBusiness?CommitteeId=#{committee.system_id}&take=30&skip=#{skip}"
    
    
    # We get the JSON.
    json = JSON.load( URI.open( url ) )
    
    # For each work package item in the feed ....
    json['items'].each do |work_package_item|
      
      # ... we associate the work package with the committee.
      associate_work_package_with_committee( committee, work_package_item )
    end
    
    # We get the total results count from the API.
    total_results = json['totalResults']
    
    # If the total results count is greater than the number of results skipped ...
    if total_results > skip
      
      # ... we call this method again, incrementing the skip by by 30 results.
      get_work_packages_for_committee( committee, skip + 30 )
    end
  end
  
  # A method to import all events.
  def import_events( skip )
    puts "importing events"
    
    # We set the URL to import from.
    url = "https://committees-api.parliament.uk/api/Events/Activities?take=30&skip=#{skip}"
    
    # We get the JSON.
    json = JSON.load( URI.open( url ) )
    
    # For each event item in the feed ....
    json['items'].each do |event_item|
      
      # ... we import or update the event.
      import_or_update_event( event_item )
    end
    
    # We get the total results count from the API.
    total_results = json['totalResults']
    
    # If the total results count is greater than the number of results skipped ...
    if total_results > skip
      
      # ... we call this method again, incrementing the skip by by 30 results.
      import_events( skip + 30 )
    end
  end
  
  
  
  
  
  
  # A method to import an event.
  def import_or_update_event( event_item )
    
    # We store the returned values.
    event_system_id = event_item['id']
    event_name = event_item['name']
    event_start_at = event_item['startDate']
    event_end_at = event_item['endDate']
    event_cancelled_at = event_item['cancelledDate']
    event_location_id = event_item['locationId']
    event_location_name = event_item['location']
    event_originating_system = event_item['eventSource']
    event_event_type_system_id = event_item['eventType']['id']
    event_event_type_name = event_item['eventType']['name']
    event_event_type_is_visit = event_item['eventType']['isVisit']
    event_event_type_description = event_item['eventType']['description']
    
    # NOTE: todo
		#"childEvents": null, < appears to be empty unless it requires some parameter
		#"nextActivity": null < appears to be populated
    
    # We attempt to find the event type.
    event_type = EventType.find_by_system_id( event_event_type_system_id )
    
    # Unless we find the event type ...
    unless event_type
      
      # ... we create a new event type.
      event_type = EventType.new
      event_type.name = event_event_type_name
      event_type.is_visit = event_event_type_is_visit
      event_type.description = event_event_type_description
      event_type.system_id = event_event_type_system_id
      event_type.save
    end
    
    # We attempt to find the event.
    event = Event.find_by_system_id( event_system_id )
    
    # Unless we find the event ...
    unless event
      
      # ... we create the event.
      event = Event.new
    end
    
    # We assign or update attributes.
    event.name = event_name
    event.start_at = event_start_at
    event.end_at = event_end_at
    event.cancelled_at = event_cancelled_at
    event.system_id = event_system_id
    event.location_name = event_location_name if event_location_name
    event.originating_system = event_originating_system
    event.event_type = event_type
    
    # Checked that all events have at least one associated committee. This is the case.
    # For each committee item assigned to the event ...
    event_item['committees'].each do |committee_item|
      
      # ... we store the returned values.
      committee_system_id = committee_item['id']
      
      # We find the committee.
      committee = Committee.find_by_system_id( committee_system_id )
      
      # ... we create a new committee event.
      committee_event = CommitteeEvent.new
      committee_event.committee = committee
      committee_event.event = event
      committee_event.save
    end
    
    # If the event has a location ID ...
    if event_location_id
      
      # ... we attempt to find the location.
      location = Location.find_by_system_id( event_location_id )
      
      # If we don't find the location ...
      unless location
        
        # ... we create a new location.
        location = Location.new
        location.name = event_location_name
        location.system_id = event_location_id
        location.save
      end
      
      # We associate the event with the location.
      event.location = location
    end
    
    # We save the event.
    event.save
  end
  
  # A method to import or update a work package.
  def import_or_update_work_package( work_package )
    
    # We store the returned values.
    work_package_system_id = work_package['id']
    work_package_title = work_package['title']
    work_package_work_package_type_system_id = work_package['type']['id']
    work_package_open_on = work_package['openDate']
    work_package_close_on = work_package['closeDate']
    
    # We attempt to find the work package.
    work_package = WorkPackage.find_by_system_id( work_package_system_id )
    
    # If we don't find the work package ...
    unless work_package
      
      # ... we create a new work package.
      work_package = WorkPackage.new
    end
    
    # We find the work package type.
    work_package_type = WorkPackageType.find_by_system_id( work_package_work_package_type_system_id )
    
    # We assign attributes to the work package.
    work_package.title = work_package_title
    work_package.open_on = work_package_open_on
    work_package.close_on = work_package_close_on
    work_package.system_id = work_package_system_id
    work_package.work_package_type = work_package_type
    work_package.save
    
	
		#	"latestReport": null,
		#	"openSubmissionPeriods": [

		#	],
		#	"closedSubmissionPeriods": [
    #
		#	],
		#	"nextOralEvidenceSession": null,
		#	"contact": null
		#},
    
  end
  
  # A method to import or update a committee.
  def import_or_update_committee( committee_item )
    
    # We store the returned values.
    committee_system_id = committee_item['id']
    committee_name = committee_item['name']
    committee_parent_committee_system_id = committee_item['parentCommittee']['id'] if committee_item['parentCommittee']
    committee_committee_types = committee_item['committeeTypes']
    committee_scrutinising_departments = committee_item['scrutinisingDepartments']
    committee_house = committee_item['house']
    committee_show_on_website = committee_item['showOnWebsite']
    committee_website_legacy_url = committee_item['websiteLegacyUrl']
    committee_website_legacy_redirect_enabled = committee_item['websiteLegacyRedirectEnabled']
    committee_start_on = committee_item['startDate']
    committee_end_on = committee_item['endDate']
    committee_address = committee_item['contact']['address']
    committee_phone = committee_item['contact']['phone']
    committee_email = committee_item['contact']['email']
    committee_contact_disclaimer = committee_item['contact']['contactDisclaimer']
    committee_commons_appointed_on = committee_item['dateCommonsAppointed']
    committee_lords_appointed_on = committee_item['dateLordsAppointed']
    committee_is_lead_committee = committee_item['isLeadCommittee']
    committee_lead_house = committee_item['leadHouse']
    
    # If the committee has a parent committee ...
    if committee_parent_committee_system_id
      
      # ... we attempt to find the parent committee.
      parent_committee = Committee.find_by_system_id( committee_parent_committee_system_id )
    end
    
    # If the committee has no parent committtee or if we've found the parent committee ...
    if committee_parent_committee_system_id.nil? || parent_committee
    
      # ... we attempt to find the committee.
      committee = Committee.find_by_system_id( committee_system_id )
      
      # NOTE: committee 352 - Education, Skills and the Economy Sub-Committee - declares its parent as committee 9 - Business, Innovation and Skills Committee - but the latter doesn't exist in the API.
      # Because we don't create a committee with a parent committee until we've created its parent, in this case we can create neither parent nor child.
    
      # If we fail to find the committee ...
      unless committee
      
        # ... we create the committee.
        committee = Committee.new
        committee.name = committee_name
        committee.system_id = committee_system_id
        committee.parent_committee_id = parent_committee.id if parent_committee
        
        # We associate the committee with a House or Houses.
        associate_committee_with_house( committee, committee_house )
        
        # We associate the committee with its types.
        associate_committee_with_type( committee, committee_committee_types )
        
        # We associate the committee with the departments it scrutinises.
        associate_committee_with_departments( committee, committee_scrutinising_departments )
      end
      
      # Regardless of whether we found the committee or created it, we update its attributes.
      committee.start_on = committee_start_on
      committee.end_on = committee_end_on
      committee.commons_appointed_on = committee_commons_appointed_on if committee_commons_appointed_on
      committee.lords_appointed_on = committee_lords_appointed_on if committee_lords_appointed_on
      committee.is_shown_on_website = committee_show_on_website
      committee.legacy_url = committee_website_legacy_url
      committee.is_redirect_enabled = committee_website_legacy_redirect_enabled
      committee.address = committee_address
      committee.phone = committee_phone
      committee.email = committee_email
      committee.contact_disclaimer = committee_contact_disclaimer
      committee.is_lead_committee = committee_is_lead_committee
      
      # If the committee is a joint committee it should have a lead house.
      # ... if there's a lead House.
      if committee_lead_house
        
        # ... if the Commons is marked as the lead House ...
        if committee_lead_house['isCommons']
          
          # ... we find the Commons.
          house = ParliamentaryHouse.find_by_short_label( 'Commons' )
          
        # If the Lords is the lead House ...
        elsif committee_lead_house['isLords']
          
          # ... we find the Lords.
          house = ParliamentaryHouse.find_by_short_label( 'Lords' )
        end
        
        # We associate the committee with the lead House.
        committee.lead_parliamentary_house_id = house.id
      end
      committee.save
    end
  end
  
  # A method to associate a committee with a House or Houses.
  def associate_committee_with_house( committee, committee_house )
    
    # We check which House or Houses the committee belongs to.
    case committee_house
      
    # If the committee is a Commons committee ...
    when 'Commons'
      
      # ... we find the Commons ...
      parliamentary_house = ParliamentaryHouse.find_by_short_label( 'Commons' )
      
      # ... and create a new association to the Commons.
      committee_house = CommitteeHouse.new
      committee_house.committee = committee
      committee_house.parliamentary_house = parliamentary_house
      committee_house.save
    
    # If the committee is a Lords committee ...
    when 'Lords'
      
      # ... we find the Lords ...
      parliamentary_house = ParliamentaryHouse.find_by_short_label( 'Lords' )
      
      # ... and create a new association to the Lords.
      committee_house = CommitteeHouse.new
      committee_house.committee = committee
      committee_house.parliamentary_house = parliamentary_house
      committee_house.save
    
    # If the committee is a joint committee ...
    when 'Joint'
      
      # ... we find the Commons ...
      parliamentary_house = ParliamentaryHouse.find_by_short_label( 'Commons' )
      
      # ... and create a new association to the Commons.
      committee_house = CommitteeHouse.new
      committee_house.committee = committee
      committee_house.parliamentary_house = parliamentary_house
      committee_house.save
      
      # We find the Lords ...
      parliamentary_house = ParliamentaryHouse.find_by_short_label( 'Lords' )
      
      # ... and create a new association to the Lords.
      committee_house = CommitteeHouse.new
      committee_house.committee = committee
      committee_house.parliamentary_house = parliamentary_house
      committee_house.save
    end
  end
  
  # A method associate a committee with its type or types.
  def associate_committee_with_type( committee, committee_committee_types )
    
    # For each committee type item in the committee's committee types ....
    committee_committee_types.each do |committee_type_item|
      
      # ... we store the returned values.
      committee_type_id = committee_type_item['id']
      
      # We find the committee type.
      committee_type = CommitteeType.find_by_system_id( committee_type_id )
      
      # We create a new association between the committee and its committee type.
      committee_committee_type = CommitteeCommitteeType.new
      committee_committee_type.committee = committee
      committee_committee_type.committee_type = committee_type
      committee_committee_type.save
    end
  end
  
  # A method to associate the committee with the departments it scrutinises.
  def associate_committee_with_departments( committee, committee_scrutinising_departments )
    
    # For each department item in the committee's scrutinising departments ...
    committee_scrutinising_departments.each do |department_item|
      
      # ... we store the variables returned.
      department_system_id = department_item['departmentId']
      department_name = department_item['name']
      
      # We attempt to find the department.
      department = Department.find_by_system_id( department_system_id )
      
      # Unless we find the department ...
      unless department
        
        # ... we create a new department
        department = Department.new
        department.system_id = department_system_id
        department.name = department_name
        department.save
      end
      
      # We create the association between the committee and the department it scrutinises.
      scrutinising = Scrutinising.new
      scrutinising.committee = committee
      scrutinising.department = department
      scrutinising.save
    end
  end
  
  # A methof to associate a committee with a work package.
  def associate_work_package_with_committee( committee, work_package_item )
    
    # We store the variables returned.
    work_package_system_id = work_package_item['id']
    
    # We find the work package.
    work_package = WorkPackage.find_by_system_id( work_package_system_id )
    
    # We create a new committee work package.
    committee_work_package = CommitteeWorkPackage.new
    committee_work_package.committee = committee
    committee_work_package.work_package = work_package
    committee_work_package.save
  end
end