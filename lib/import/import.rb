# # A module for importing for the committee system API.
module IMPORT
  
  # ## Import top up methods run as rake tasks on Heroku.
  
  # ### A method to import committee types.
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
        puts "creating new category: #{committee_type_item_category_name}"
        category = Category.new
        category.system_id = committee_type_item_category_system_id
        category.name = committee_type_item_category_name
        category.save!
      end
      
      # We attempt to find the committee type.
      committee_type = CommitteeType.find_by_system_id( committee_type_item_system_id )
      
      # If we don't find the committee type ...
      unless committee_type
        
        # ... we create a new committee type.
        puts "creating new committee type: #{committee_type_item_name}"
        committee_type = CommitteeType.new
        committee_type.system_id = committee_type_item_system_id
        committee_type.name = committee_type_item_name
        committee_type.category = category
        committee_type.save!
      end
    end
  end
  
  # ### A method to import all work package types.
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
        puts "creating new work package type: #{business_type_item_name}"
        work_package_type = WorkPackageType.new
        work_package_type.system_id = business_type_item_system_id
      end
      
      # We create or update the work package type attributes.
      work_package_type.name = business_type_item_name
      work_package_type.description = business_type_item_description
      work_package_type.is_inquiry = business_type_item_is_inquiry
      work_package_type.save!
    end
  end
  
  # ### A method to import current committees.
  def import_current_committees( skip )
    puts "importing current committees"
    
    # We set the URL to import from.
    url = "https://committees-api.parliament.uk/api/Committees?CommitteeStatus=current&ShowOnWebsiteOnly=false&take=30&skip=#{skip}"
    
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
      import_current_committees( skip + 30 )
    end
  end
  
  # ### A method to import work packages for current committees.
  def import_work_packages_for_current_committees
    puts "importing work packages for current committees"
    
    # We get all current committees.
    committees = Committee.all.where( "end_on IS NOT NULL AND end_on < ?", Date.today )
    
    # For each committee ...
    committees.each do |committee|
      
      # ... we get the work packages.
      get_work_packages_for_committee( committee, 0 )
    end
  end
  
  # ### A method to import upcoming events.
  def import_upcoming_events( skip )
    puts "importing upcoming events"
    
    # We set the URL to import from.
    url = "https://committees-api.parliament.uk/api/Events/Activities?StartDateFrom=#{Date.today}&take=30&skip=#{skip}"
    
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
      import_upcoming_events( skip + 30 )
    end
  end
  
  # ### A method to import recent oral evidence sessions.
  def import_recent_oral_evidence_transcripts( skip )
    puts "importing recent oral evidence transcripts"
    
    # We define recent as from 2 days ago in the hope we don't miss any.
    start_date = Date.today - 2
    
    # We set the URL to import from.
    url = "https://committees-api.parliament.uk/api/OralEvidence?StartDate=#{start_date}&take=30&skip=#{skip}"
    
    # We get the JSON.
    json = JSON.load( URI.open( url ) )
    
    # For each oral evidence transcript item in the feed ....
    json['items'].each do |oral_evidence_transcript_item|
      
      # ... we import or update the oral evidence transcript.
      import_or_update_oral_evidence_transcript( oral_evidence_transcript_item )
    end
    
    # We get the total results count from the API.
    total_results = json['totalResults']
    
    # If the total results count is greater than the number of results skipped ...
    if total_results > skip
      
      # ... we call this method again, incrementing the skip by by 30 results.
      import_recent_oral_evidence_transcripts( skip + 30 )
    end
  end
  
  # ## A method to import memberships from current committees.
  def import_memberships_from_current_committees
    puts "importing memberships from current committees"
    
    # We get all current committees.
    committees = Committee.all.where( "end_on IS NOT NULL AND end_on < ?", Date.today )
    
    # For each committee ...
    committees.each do |committee|
      
      # ... we import its memberships.
      get_memberships_for_committee( committee, 0 )
    end
  end
  
  # ### A method to import all publication types.
  def import_all_publication_types
    puts "importing publication types"
    
    # We set the URL to import from.
    url = "https://committees-api.parliament.uk/api/PublicationType"
    
    # We get the JSON.
    json = JSON.load( URI.open( url ) )
    
    # For each publication type item in the feed ....
    json.each do |publication_type_item|
      
      # ... we store the returned values.
      publication_type_item_system_id = publication_type_item['id']
      publication_type_item_name = publication_type_item['name']
      publication_type_item_plural_name = publication_type_item['pluralVersion']
      publication_type_item_description = publication_type_item['description']
      publication_type_item_government_can_respond = publication_type_item['governmentCanRespond']
      publication_type_item_can_be_response = publication_type_item['canBeResponse']
      publication_type_item_icon_key = publication_type_item['iconKey']
      
      # We attempt to find the publication type.
      publication_type = PublicationType.find_by_system_id( publication_type_item_system_id )
      
      # Unless we find the publication type ....
      unless publication_type
        
        # ... we create a new publication type.
        publication_type = PublicationType.new
        publication_type.system_id = publication_type_item_system_id
      end
      
      # We set or update the publication type attributes.
      publication_type.name = publication_type_item_name
      publication_type.plural_name = publication_type_item_plural_name
      publication_type.description = publication_type_item_description
      publication_type.government_can_respond = publication_type_item_government_can_respond
      publication_type.can_be_response = publication_type_item_can_be_response
      publication_type.icon_key = publication_type_item_icon_key
      publication_type.save!
    end
  end
  
  # ### A method to import recent publications.
  def import_recent_publications( skip )
    puts "importing recent publications"
    
    # We define recent as from 2 days ago in the hope we don't miss any.
    start_date = Date.today - 2
    
    # We set the URL to import from.
    url = "https://committees-api.parliament.uk/api/Publications?StartDate=#{start_date}&take=30&skip=#{skip}"
    
    # We get the JSON.
    json = JSON.load( URI.open( url ) )
    
    # For each publication item in the feed ....
    json['items'].each do |publication_item|
      
      # ... we import or update the publication.
      import_or_update_publication( publication_item )
    end
    
    # We get the total results count from the API.
    total_results = json['totalResults']
    
    # If the total results count is greater than the number of results skipped ...
    if total_results > skip
      
      # ... we call this method again, incrementing the skip by by 30 results.
      import_recent_publications( skip + 30 )
    end
  end
  
  
  
  # ## Helper methods.
  
  # ### A method to import or update a committee.
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
      
      # We flag an error if we don't find the parent committee.
      puts "Committee #{committee_system_id} has parent committee #{committee_parent_committee_system_id} - not loaded into database" unless parent_committee
    end
    
    # If the committee has no parent committtee or if we've found the parent committee ...
    if committee_parent_committee_system_id.nil? || parent_committee
    
      # ... we attempt to find the committee.
      committee = Committee.find_by_system_id( committee_system_id )
    
      # If we fail to find the committee ...
      unless committee
      
        # ... we create the committee.
        puts "creating new committee: #{committee_name}"
        committee = Committee.new
        committee.system_id = committee_system_id
      end
      
      # Regardless of whether we found the committee or created it, we update its attributes.
      committee.name = committee_name
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
      committee.parent_committee_id = parent_committee.id if parent_committee
      
      # We associate the committee with a House or Houses.
      associate_committee_with_houses( committee, committee_house )
      
      # We associate the committee with its types.
      associate_committee_with_type( committee, committee_committee_types )
      
      # We associate the committee with the departments it scrutinises.
      associate_committee_with_departments( committee, committee_scrutinising_departments )
      
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
      committee.save!
    end
  end
  
  # ### A method to associate a committee with a House or Houses.
  def associate_committee_with_houses( committee, committee_house )
    
    # We check which House or Houses the committee belongs to.
    case committee_house
      
    # If the committee is a Commons committee ...
    when 'Commons'
      
      # ... we find the Commons ...
      parliamentary_house = ParliamentaryHouse.find_by_short_label( 'Commons' )
      
      # ... and create a new association to the Commons.
      associate_committee_with_a_house( committee, parliamentary_house )
    
    # If the committee is a Lords committee ...
    when 'Lords'
      
      # ... we find the Lords ...
      parliamentary_house = ParliamentaryHouse.find_by_short_label( 'Lords' )
      
      # ... and create a new association to the Lords.
      associate_committee_with_a_house( committee, parliamentary_house )
    
    # If the committee is a joint committee ...
    when 'Joint'
      
      # ... we find the Commons ...
      parliamentary_house = ParliamentaryHouse.find_by_short_label( 'Commons' )
      
      # ... and create a new association to the Commons.
      associate_committee_with_a_house( committee, parliamentary_house )
      
      # We find the Lords ...
      parliamentary_house = ParliamentaryHouse.find_by_short_label( 'Lords' )
      
      # ... and create a new association to the Commons.
      associate_committee_with_a_house( committee, parliamentary_house )
    end
  end
  
  # ### A method to associate a committee to a House.
  def associate_committee_with_a_house( committee, parliamentary_house )
    
    # We attempt to find an association between the committee and the House.
    committee_house = CommitteeHouse.all.where( "committee_id = ?", committee.id ).where( "parliamentary_house_id = ?", parliamentary_house.id).first
    
    # If we don't find an assocation between the committee and the House ...
    unless committee_house
      
      # ... we create an association between the committee and the House.
      puts "creating committee house association"
      committee_house = CommitteeHouse.new
      committee_house.committee = committee
      committee_house.parliamentary_house = parliamentary_house
      committee_house.save!
    end
  end
  
  # ### A method associate a committee with its type or types.
  def associate_committee_with_type( committee, committee_committee_types )
    
    # For each committee type item in the committee's committee types ....
    committee_committee_types.each do |committee_type_item|
      
      # ... we store the returned values.
      committee_type_id = committee_type_item['id']
      
      # We find the committee type.
      committee_type = CommitteeType.find_by_system_id( committee_type_id )
      
      # We attempt to find an association between the committee and its type.
      committee_committee_type = CommitteeCommitteeType.all.where( "committee_id = ?", committee.id ).where( "committee_type_id = ?", committee_type.id).first
      
      # Unless we find an association between the committee and its type ...
      unless committee_committee_type
        
        # ... we create a new association between the committee and its committee type.
        puts "creating committee committee type association"
        committee_committee_type = CommitteeCommitteeType.new
        committee_committee_type.committee = committee
        committee_committee_type.committee_type = committee_type
        committee_committee_type.save!
      end
    end
  end
  
  # ### A method to associate the committee with the departments it scrutinises.
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
        puts "creating department: #{department_name}"
        department = Department.new
        department.system_id = department_system_id
      end
      
      # We create or update the department attributes.
      department.name = department_name
      department.save!
      
      # We attempt to find a scrutinising.
      scrutinising = Scrutinising.all.where( "committee_id = ?", committee.id ).where( "department_id = ?", department.id ).first
      
      # Unless we find a scrutinising ...
      unless scrutinising
      
        # ... we create the association between the committee and the department it scrutinises.
        puts "creating a new scrutiny association"
        scrutinising = Scrutinising.new
        scrutinising.committee = committee
        scrutinising.department = department
        scrutinising.save!
      end
    end
  end
  
  # ### A method to get work packages for a committee.
  def get_work_packages_for_committee( committee, skip )
    
    # We set the URL to import from.
    url = "https://committees-api.parliament.uk/api/CommitteeBusiness?CommitteeId=#{committee.system_id}&take=30&skip=#{skip}"
    
    # We get the JSON.
    json = JSON.load( URI.open( url ) )
    
    # For each work package item in the feed ....
    json['items'].each do |work_package_item|
      
      # ... we import or update the work package ...
      import_or_update_work_package( work_package_item )
      
      # ... and associate the work package with the committee.
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
  
  # ### A method to import or update a work package.
  def import_or_update_work_package( work_package )
    
    # We store the returned values.
    work_package_system_id = work_package['id']
    work_package_title = work_package['title']
    work_package_work_package_type_system_id = work_package['type']['id']
    work_package_open_on = work_package['openDate']
    work_package_close_on = work_package['closeDate']
    
    # We find the work package type.
    work_package_type = WorkPackageType.find_by_system_id( work_package_work_package_type_system_id )
    
    # We attempt to find the work package.
    work_package = WorkPackage.find_by_system_id( work_package_system_id )
    
    # If we don't find the work package ...
    unless work_package
      
      # ... we create a new work package.
      puts "creating new work package: #{work_package_title}"
      work_package = WorkPackage.new
      work_package.system_id = work_package_system_id
    end
    
    # We assign attributes to the work package.
    work_package.title = work_package_title
    work_package.open_on = work_package_open_on
    work_package.close_on = work_package_close_on
    work_package.work_package_type = work_package_type
    work_package.save!
    
	
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
  
  # ### A method to associate a committee with a work package.
  def associate_work_package_with_committee( committee, work_package_item )
    
    # We store the variables returned.
    work_package_system_id = work_package_item['id']
    
    # We find the work package.
    work_package = WorkPackage.find_by_system_id( work_package_system_id )
    
    # We try to find the committee work package.
    committee_work_package = CommitteeWorkPackage.all.where( "committee_id = ?", committee.id).where( "work_package_id = ?", work_package.id ).first
    
    # Unless the committee work package exists ...
    unless committee_work_package
      
      # ... we create a new committee work package.
      puts "creating committee work package association"
      committee_work_package = CommitteeWorkPackage.new
      committee_work_package.committee = committee
      committee_work_package.work_package = work_package
      committee_work_package.save!
    end
  end
  
  # ### A method to import or update an event.
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
    event_segments = event_item['activities']
    
    # NOTE: todo
		#"childEvents": null, < appears to be empty unless it requires some parameter
		#"nextActivity": null < appears to be populated
    
    # We attempt to find the event type.
    event_type = EventType.find_by_system_id( event_event_type_system_id )
    
    # Unless we find the event type ...
    unless event_type
      
      # ... we create a new event type.
      puts "creating a new event type: #{event_event_type_name}"
      event_type = EventType.new
      event_type.system_id = event_event_type_system_id
    end
    
    # We create or update the event type attributes.
    event_type.name = event_event_type_name
    event_type.is_visit = event_event_type_is_visit
    event_type.description = event_event_type_description
    event_type.save!
    
    # We attempt to find the event.
    event = Event.find_by_system_id( event_system_id )
    
    # Unless we find the event ...
    unless event
      
      # ... we create the event.
      puts "creating a new event: #{event_name}"
      event = Event.new
      event.system_id = event_system_id
    end
    
    # We assign or update attributes.
    event.name = event_name
    event.start_at = event_start_at
    event.end_at = event_end_at
    event.cancelled_at = event_cancelled_at
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
      
      # We attempt to find the committee event association.
      committee_event = CommitteeEvent.all
        .where( "committee_id = ?", committee.id )
        .where( "event_id = ?", event.id )
        .first
        
      # Unless we find the committee event assocation ...
      unless committee_event
      
        # ... we create a new committee event association.
        puts "associating an event with a committee"
        committee_event = CommitteeEvent.new
        committee_event.committee = committee
        committee_event.event = event
        committee_event.save!
      end
    end
    
    # If the event has a location ID ...
    if event_location_id
      
      # ... we attempt to find the location.
      location = Location.find_by_system_id( event_location_id )
      
      # If we don't find the location ...
      unless location
        
        # ... we create a new location.
        puts "creating new location: #{event_location_name}"
        location = Location.new
        location.system_id = event_location_id
      end
      
      # We assign or update event attributes.
      location.name = event_location_name
      location.save!
      
      # We associate the event with the location.
      event.location = location
    end
    
    # We save the event.
    event.save!
    
    # If the event has segments ...
    unless event_segments.empty?
    
      # ... for each event segment item ...
      event_segments.each do |event_segment_item|
        
        # ... we store the returned values.
        event_segment_item_system_id = event_segment_item['id']
        event_segment_item_name = event_segment_item['name']
        event_segment_item_start_at = event_segment_item['startDate']
        event_segment_item_end_at = event_segment_item['endDate']
        event_segment_item_is_private = event_segment_item['isPrivate']
        event_segment_item_activity_type = event_segment_item['activityType']
        
        # We try to find the activity type.
        activity_type = ActivityType.find_by_name( event_segment_item_activity_type )
        
        # If we don't find the activity type ...
        unless activity_type
          
          # ... we create a new activity type.
          puts "creating new activity type #{event_segment_item_activity_type}"
          activity_type = ActivityType.new
        end
        
        # We assign or update activity type attributes.
        activity_type.name = event_segment_item_activity_type
        activity_type.save!
        
        # We try to find the event segment.
        event_segment = EventSegment.find_by_system_id( event_segment_item_system_id )
        
        # Unless we find the event segment ...
        unless event_segment
          
          # ... we create a new event segment.
          puts "creating a new event segment #{event_segment_item_name}"
          event_segment = EventSegment.new
          event_segment.system_id = event_segment_item_system_id
        end
        
        # We assign or update attributes.
        event_segment.name = event_segment_item_name
        event_segment.start_at = event_segment_item_start_at
        event_segment.end_at = event_segment_item_end_at
        event_segment.is_private = event_segment_item_is_private
        event_segment.event = event
        event_segment.activity_type = activity_type
        event_segment.save!
      end
    end
  end
  
  # ### A method to import or update an oral evidence transcript.
  def import_or_update_oral_evidence_transcript( oral_evidence_transcript_item )
    
    # We store the returned values.
    oral_evidence_transcript_system_id = oral_evidence_transcript_item['id']
    oral_evidence_transcript_event_segment_system_id = oral_evidence_transcript_item['activityId']
    oral_evidence_transcript_start_on = oral_evidence_transcript_item['activityStartDate']
    oral_evidence_transcript_meeting_on = oral_evidence_transcript_item['meetingDate']
    oral_evidence_transcript_legacy_html_url = oral_evidence_transcript_item['legacyHtmlUrl']
    oral_evidence_transcript_legacy_pdf_url = oral_evidence_transcript_item['legacyPdfUrl']
    oral_evidence_transcript_published_on = oral_evidence_transcript_item['publicationDate']
    oral_evidence_transcript_house_of_commons_numbers = oral_evidence_transcript_item['hcNumbers']
    oral_evidence_transcript_witnesses = oral_evidence_transcript_item['witnesses']
    oral_evidence_transcript_work_packages = oral_evidence_transcript_item['committeeBusinesses']
    oral_evidence_transcript_committees = oral_evidence_transcript_item['committees']
    
    # if the oral evidence transcript item has a document ...
    if oral_evidence_transcript_item['document']
      
      # ... we get the document ID and an array of files.
      oral_evidence_transcript_document_id = oral_evidence_transcript_item['document']['documentId']
      oral_evidence_transcript_document_files = oral_evidence_transcript_item['document']['files']
    end
    
    # We find the associated event segment.
    event_segment = EventSegment.find_by_system_id( oral_evidence_transcript_event_segment_system_id )
    
    # We attempt to find the oral evidence transcript.
    oral_evidence_transcript = OralEvidenceTranscript.find_by_system_id( oral_evidence_transcript_system_id )
    
    # If we don't find the oral evidence transcript ...
    unless oral_evidence_transcript
      
      # ... we create a new oral evidence transcript.
      puts "creating new oral evidence transcript published: #{oral_evidence_transcript_published_on}"
      oral_evidence_transcript = OralEvidenceTranscript.new
      oral_evidence_transcript.system_id = oral_evidence_transcript_system_id
    end
    
    # We assign or update attributes.
    oral_evidence_transcript.start_on = oral_evidence_transcript_start_on
    oral_evidence_transcript.meeting_on = oral_evidence_transcript_meeting_on
    oral_evidence_transcript.legacy_html_url = oral_evidence_transcript_legacy_html_url
    oral_evidence_transcript.legacy_pdf_url = oral_evidence_transcript_legacy_pdf_url
    oral_evidence_transcript.published_on = oral_evidence_transcript_published_on
    oral_evidence_transcript.document_id = oral_evidence_transcript_document_id
    # NOTE: the najority of oral evidence sessions are associated with an event segment. A minority are not.
    # Missing event segments are: 11373, 11399, 12490, 12497, 12514, 12529, 12535, 12571, 12572, 12588, 12601, 12635, 12643, 12645, 12721, 12760, 19417, 19419, 19420
    # Oral evidence sessions with no event segment are: 4535, 4561, 5652, 5659, 5676, 5691, 5697, 5733, 5734, 5750, 5763, 5797, 5805, 5807, 5883, 5922, 10872, 10874, 10875
    oral_evidence_transcript.event_segment = event_segment if event_segment
    oral_evidence_transcript.save!
    
    # Unless the oral evidence is not associated with any files ...
    if oral_evidence_transcript_document_files
      
      # ... we associate the oral evidence transcript with its files.
      associate_oral_evidence_transcript_with_files( oral_evidence_transcript, oral_evidence_transcript_document_files )
    end
    
    # Unless the oral evidence is not associated with any work packages ...
    unless oral_evidence_transcript_work_packages.empty?
      
      # ... we attempt to associate the oral evidence transcript with its work packages.
      associate_oral_evidence_transcript_with_work_packages( oral_evidence_transcript, oral_evidence_transcript_work_packages )
    end
    
    # Unless the oral evidence is not associated with any committees ...
    unless oral_evidence_transcript_committees.empty?
      
      # ... we attempt to associate the oral evidence transcript with its committees.
      associate_oral_evidence_transcript_with_committees( oral_evidence_transcript, oral_evidence_transcript_committees )
    end
    
    # Unless the oral evidence transcript has no House of Commons numbers ...
    if oral_evidence_transcript_house_of_commons_numbers
      
      # ... we attempt to associate the oral evidence transcript with its paper series numbers.
      associate_oral_evidence_transcript_with_paper_series_numbers( oral_evidence_transcript, oral_evidence_transcript_house_of_commons_numbers, 'Commons' )
    end
    
    # For each oral evidence transcript witness item ...
    oral_evidence_transcript_witnesses.each do |oral_evidence_transcript_witness_item|
      
      # ... we store the returned values.
      oral_evidence_transcript_witness_person_name = oral_evidence_transcript_witness_item['name']
      oral_evidence_transcript_witness_person_system_id = oral_evidence_transcript_witness_item['personId']
      oral_evidence_transcript_witness_submitter_type = oral_evidence_transcript_witness_item['submitterType']
      oral_evidence_transcript_witness_context = oral_evidence_transcript_witness_item['additionalContext']
      oral_evidence_transcript_witness_organisations = oral_evidence_transcript_witness_item['organisations']
      oral_evidence_transcript_witness_system_id = oral_evidence_transcript_witness_item['id']
      oral_evidence_transcript_witness_mnis_id = nil
      oral_evidence_transcript_witness_mnis_name = nil
      
      # If the witness is a Member ...
      if oral_evidence_transcript_witness_item['memberInfo']
        
        # ... we store their MNIS ID and name.
        oral_evidence_transcript_witness_mnis_id = oral_evidence_transcript_witness_item['memberInfo']['mnisId']
        oral_evidence_transcript_witness_mnis_name = oral_evidence_transcript_witness_item['memberInfo']['displayAs']
      end
      
      # We set a person name, being either the MNIS name or the CIS name.
      person_name = oral_evidence_transcript_witness_mnis_name || oral_evidence_transcript_witness_person_name
      
      # NOTE: people have either a CIS ID, a MNIS ID or neither.
      # If the witness item has a MNIS id ...
      if oral_evidence_transcript_witness_mnis_id
        
        # ... we attempt to find the person by their MNIS ID.
        person = Person.find_by_mnis_id( oral_evidence_transcript_witness_mnis_id )
      
        # Unless we find the person ...
        unless person
          
          # ... we create a new person.
          puts "creating person: #{person_name}"
          person = Person.new
          person.mnis_id = oral_evidence_transcript_witness_mnis_id
        end
        
        # We set or update the person attributes
        person.name = person_name
        person.save!
        
      # Otherwise, if the witness item has a CIS person ID ...
      elsif oral_evidence_transcript_witness_person_system_id
        
        # ... we attempt to find the person by the CIS ID.
        person = Person.find_by_system_id( oral_evidence_transcript_witness_person_system_id )
      
        # Unless we find the person ...
        unless person
          
          # ... we create a new person.
          puts "creating person: #{person_name}"
          person = Person.new
          person.system_id = oral_evidence_transcript_witness_person_system_id
        end
        
        # We set or update the person attributes
        person.name = person_name
        person.save!
      end
      
      # Some witnesses have a CIS ID of 0.
      # If the witness ID is 0 ...
      if oral_evidence_transcript_witness_system_id == 0
        
        # ... we attempt to find the witness.
        witness = Witness.all
          .where( "oral_evidence_transcript_id =?", oral_evidence_transcript.id )
          .where( 'person_name = ?', oral_evidence_transcript_witness_person_name )
          .first
      
        # Unless we find the witness ...
        unless witness
        
          # ... we create a new witness.
          puts "creating witness: #{oral_evidence_transcript_witness_person_name}"
          witness = Witness.new
          witness.oral_evidence_transcript = oral_evidence_transcript
          witness.person = person if person
          witness.person_name = oral_evidence_transcript_witness_person_name
          witness.save!
        end
        
        
      # If the witness ID is not 0 ...
      else
      
        # ... we attempt to find the witness.
        witness = Witness.find_by_system_id( oral_evidence_transcript_witness_system_id )
      
        # Unless we find the witness ...
        unless witness
      
          # ... we create a new witness.
          puts "creating witness: #{oral_evidence_transcript_witness_person_name}"
          witness = Witness.new
          witness.system_id = oral_evidence_transcript_witness_system_id
          witness.oral_evidence_transcript = oral_evidence_transcript
          witness.person = person if person
        end
        
        # We set or update the witness attributes.
        witness.person_name = oral_evidence_transcript_witness_person_name
        witness.save!
      end
        
      # For each organisation item ...
      oral_evidence_transcript_witness_organisations.each do |organisation_item|
        
        # ... we store the returned values.
        organisation_name = organisation_item['name']
        organisation_role = organisation_item['role']
        organisation_idms_id = organisation_item['idmsId']
        organisation_system_id = organisation_item['cisId']
        
        # We attempt to find the organisation.
        organisation = Organisation.find_by_system_id ( organisation_system_id )
        
        # Unless we find the organisation ...
        unless organisation
          
          # ... we create the organisation.
          puts "creating organisation: #{organisation_name}"
          organisation = Organisation.new
          organisation.idms_id = organisation_idms_id
          organisation.system_id = organisation_system_id
        end
        
        # We set or update the organisation attributes.
        organisation.name = organisation_name
        organisation.save!
        
        # We attempt to find the position.
        position = Position
          .all
          .where( "name = ?", organisation_role )
          .where( "organisation_id = ?", organisation.id )
          .first
          
        # Unless we find the position ...
        unless position
          
          # ... we create a new position.
          puts "creating position: #{organisation_role}"
          position = Position.new
          position.organisation = organisation
        end
        
        # We set or update the position attributes.
        position.name = organisation_role
        position.save!
        
        # We attempt to find the witness position.
        witness_position = WitnessPosition.all
          .where( "witness_id = ?", witness.id )
          .where( "position_id = ?", position.id )
          .first
          
        # If we don't find the witness position ...
        unless witness_position
          
          # ... we create the witness position.
          puts "creating witness position"
          witness_position = WitnessPosition.new
          witness_position.witness = witness
          witness_position.position = position
          witness_position.save!
        end
      end
    end
  end
  
  # ### A method to associate an oral evidence transcript with its files.
  def associate_oral_evidence_transcript_with_files( oral_evidence_transcript, oral_evidence_transcript_document_files )
    
    # For each file assoicated with the oral evidence transcript...
    oral_evidence_transcript_document_files.each do |file_item|
      
      # We store the returned values.
      file_item_name = file_item['fileName']
      file_item_size = file_item['fileSize']
      file_item_format = file_item['fileDataFormat']
      file_item_url = file_item['url']
      
      # We attempt to find the file.
      file = OralEvidenceTranscriptFile.all.where( "name = ?", file_item_name ).where( "size = ?", file_item_size ).where( "format = ?", file_item_format ).where( "oral_evidence_transcript_id = ?", oral_evidence_transcript.id ).first
      
      # If we don't find the file ...
      unless file
        
        # ... we create the file.
        puts "creating an oral evidence transcript file"
        file = OralEvidenceTranscriptFile.new
        file.name = file_item_name
        file.size = file_item_size
        file.format = file_item_format
        file.url = file_item_url
        file.oral_evidence_transcript = oral_evidence_transcript
        file.save
      end
    end
  end
  
  # ### A method to associate an oral evidence transcript with its work packages.
  def associate_oral_evidence_transcript_with_work_packages( oral_evidence_transcript, oral_evidence_transcript_work_packages )
    
    # For each work package item associated with the oral evidence ...
    oral_evidence_transcript_work_packages.each do |work_package_item|
      
      # ... we get the ID of the work package.
      work_package_item_system_id = work_package_item['id']
      
      # We find the work package.
      work_package = WorkPackage.find_by_system_id( work_package_item_system_id )
      
      # We attempt to find an existing work package oral evidence transcript.
      work_package_oral_evidence_transcript = WorkPackageOralEvidenceTranscript.all.where( "work_package_id = ?", work_package.id ).where( "oral_evidence_transcript_id = ?", oral_evidence_transcript.id ).first
      
      # Unless the work package oral evidence transcript exists ...
      unless work_package_oral_evidence_transcript
        
        # ... we create a new work package oral evidence transcript.
        puts "creating work package oral evidence transcript association"
        work_package_oral_evidence_transcript = WorkPackageOralEvidenceTranscript.new
        work_package_oral_evidence_transcript.work_package = work_package
        work_package_oral_evidence_transcript.oral_evidence_transcript = oral_evidence_transcript
        work_package_oral_evidence_transcript.save!
      end
    end
  end
  
  # ### A method to associate an oral evidence transcript with its committees.
  def associate_oral_evidence_transcript_with_committees( oral_evidence_transcript, oral_evidence_transcript_committees )
    
    # For each committee item associated with the oral evidence ...
    oral_evidence_transcript_committees.each do |committee_item|
      
      # ... we get the ID of the committee.
      committee_item_system_id = committee_item['id']
      
      # We attempt to find the committee.
      committee = Committee.find_by_system_id( committee_item_system_id )
      
      # If we find the committee ...
      if committee
      
        # ... we attempt to find an existing committee oral evidence transcript.
        committee_oral_evidence_transcript = CommitteeOralEvidenceTranscript.all.where( "committee_id = ?", committee.id ).where( "oral_evidence_transcript_id = ?", oral_evidence_transcript.id ).first
      
        # Unless the committee oral evidence transcript exists ...
        unless committee_oral_evidence_transcript
        
          # ... we create a new work package oral evidence transcript.
          puts "creating a committee oral evidence transcript association"
          committee_oral_evidence_transcript = CommitteeOralEvidenceTranscript.new
          committee_oral_evidence_transcript.committee = committee
          committee_oral_evidence_transcript.oral_evidence_transcript = oral_evidence_transcript
          committee_oral_evidence_transcript.save!
        end
      end
    end
  end
  
  # ### A method to associate an oral evidence transcript with its paper series numbers.
  def associate_oral_evidence_transcript_with_paper_series_numbers( oral_evidence_transcript, oral_evidence_transcript_paper_series_numbers, house )
    
    # For each paper series number associated with the oral evidence transcript...
    oral_evidence_transcript_paper_series_numbers.each do |paper_series_number|
      
      # We store the returned values.
      paper_series_number_number = paper_series_number['number']
      paper_series_number_session_id = paper_series_number['sessionId']
      paper_series_number_session_label = paper_series_number['sessionDescription']
      
      # We attempt to find the session.
      session = Session.find_by_system_id( paper_series_number_session_id )
      
      # Unless we find the session ...
      unless session
        
        # ... we create a new session.
        puts "creating session #{house_of_commons_number_session_label}"
        session = Session.new
        session.system_id = house_of_commons_number_session_id
      end
      
      # We create or update the session description.
      session.label = paper_series_number_session_label
      session.save
      
      # We find the parliamentary House.
      parliamentary_house = ParliamentaryHouse.find_by_short_label( house )
      
      # We attempt to find this paper number.
      paper_series_number = PaperSeriesNumber
        .all
        .where( "session_id = ?", session.id )
        .where( "oral_evidence_transcript_id = ?", oral_evidence_transcript.id )
        .where( "number = ?", paper_series_number_number )
        .where( "parliamentary_house_id = ?", parliamentary_house.id )
        .first
        
      # Unless this paper series number exists ...
      unless paper_series_number
        
        # ... we create the paper series number.
        puts "creating paper series number #{paper_series_number_number}"
        paper_series_number = PaperSeriesNumber.new
        paper_series_number.number = paper_series_number_number
        paper_series_number.oral_evidence_transcript = oral_evidence_transcript
        paper_series_number.session = session
        paper_series_number.parliamentary_house = parliamentary_house
        paper_series_number.save
      end
    end
  end
  
  # ### A method to associate a publication with its paper series numbers.
  def associate_publication_with_paper_series_number( publication, publication_paper_series_numbers, house )
    
    # We store the returned values.
    paper_series_number_number = publication_paper_series_numbers['number']
    paper_series_number_session_id = publication_paper_series_numbers['sessionId']
    paper_series_number_session_label = publication_paper_series_numbers['sessionDescription']
      
    # We attempt to find the session.
    session = Session.find_by_system_id( paper_series_number_session_id )
      
    # Unless we find the session ...
    unless session
        
      # ... we create a new session.
      puts "creating session #{paper_series_number_session_label}"
      session = Session.new
      session.system_id = paper_series_number_session_id
    end
      
    # We create or update the session description.
    session.label = paper_series_number_session_label
    session.save
      
    # We find the parliamentary House.
    parliamentary_house = ParliamentaryHouse.find_by_short_label( house )
      
    # We attempt to find this paper number.
    paper_series_number = PaperSeriesNumber
      .all
      .where( "session_id = ?", session.id )
      .where( "publication_id = ?", publication.id )
      .where( "number = ?", paper_series_number_number )
      .where( "parliamentary_house_id = ?", parliamentary_house.id )
      .first
        
    # Unless this paper series number exists ...
    unless paper_series_number
        
      # ... we create the paper series number.
      puts "creating paper series number #{paper_series_number_number}"
      paper_series_number = PaperSeriesNumber.new
      paper_series_number.number = paper_series_number_number
      paper_series_number.publication = publication
      paper_series_number.session = session
      paper_series_number.parliamentary_house = parliamentary_house
      paper_series_number.save
    end
  end
  
  # ## A method to get memberships for a committee.
  def get_memberships_for_committee( committee, skip )
    puts "importing memberships for committee: #{committee.name}"
    
    # We set the URL to import from.
    url = "https://committees-api.parliament.uk/api/Committees/#{committee.system_id}/Members?MembershipStatus=all&ShowOnWebsiteOnly=false&take=30&skip=#{skip}"
    
    # We get the JSON.
    json = JSON.load( URI.open( url ) )
    
    # For each member item in the feed ...
    json['items'].each do |member_item|
      
      # ... we import or uopdate the membership.
      import_or_update_membership( committee, member_item)
    end
    
    # We get the total results count from the API.
    total_results = json['totalResults']
    
    # If the total results count is greater than the number of results skipped ...
    if total_results > skip
      
      # ... we call this method again, incrementing the skip by by 30 results.
      get_memberships_for_committee( committee, skip + 30 )
    end
  end
  
  # ## A method to import or update a membership.
  def import_or_update_membership( committee, member_item )
    
    # We import or update a person.
    person = import_or_update_person( member_item )
    
    # We store the returned values.
    member_item_system_id = member_item['id']
    member_item_is_lay_member = member_item['isLayMember']
    member_item_roles = member_item['roles']
    
    # For each role in the member item ...
    member_item_roles.each do |member_item_role|
      
      # ... we import or update the role.
      role = import_or_update_role( member_item_role['role'] )
      
      # We store the returned variables.
      membership_start_on = member_item_role['startDate']
      membership_end_on = member_item_role['endDate']
      membership_is_ex_officio = member_item_role['exOfficio']
      membership_is_alternate = member_item_role['alternate']
      membership_is_co_opted = member_item_role['coOpted']
      
      # We attempt to find the membership.
      membership = Membership.all
        .where( "system_id = ?", member_item_system_id )
        .where( "start_on = ?", membership_start_on )
        .where( "committee_id = ?", committee.id )
        .where( "person_id = ?", person.id )
        .where( "role_id = ?", role.id )
        .first
      
      # Unless we find the membership ...
      unless membership
        
        # We create a new membership.
        puts "creating membership of #{person.name} on #{committee.name} in role #{role.name}"
        membership = Membership.new
        membership.system_id = member_item_system_id
        membership.start_on = membership_start_on
        membership.committee = committee
        membership.person = person
        membership.role = role
      end
      
      # We update the membership attributes.
      membership.end_on = membership_end_on
      membership.is_lay_member = member_item_is_lay_member
      membership.is_ex_officio = membership_is_ex_officio
      membership.is_alternate = membership_is_alternate
      membership.is_co_opted = membership_is_co_opted
      
      # We save the membership.
      membership.save
    end
  end 
  
  # ## A method to import or update a person.
  def import_or_update_person( person_item )
    
    # We store the returned variables.
    person_item_person_id = person_item['personId']
    person_item_person_name = person_item['name']
    person_item_mnis_id = nil
    person_item_mnis_name = nil
    
    # If the person is a Member ...
    if person_item['memberInfo']
        
      # ... we store their MNIS ID and name.
      person_item_mnis_id = person_item['memberInfo']['mnisId']
      person_item_mnis_name = person_item['memberInfo']['displayAs']
    end
      
    # We set a person name, being either the MNIS name or the CIS name.
    person_name = person_item_mnis_name || person_item_person_name
    
    # If the person item has a MNIS id ...
    if person_item_mnis_id
      
      # ... we attempt to find the person by their MNIS ID.
      person = Person.find_by_mnis_id( person_item_mnis_id )
    
      # Unless we find the person ...
      unless person
        
        # ... we create a new person.
        puts "creating person: #{person_name}"
        person = Person.new
        person.mnis_id = person_item_mnis_id
      end
      
      # We set or update the person attributes
      person.name = person_name
      person.save!
      
    # Otherwise, if the witness item has a CIS person ID ...
    elsif person_item_person_id
      
      # ... we attempt to find the person by the CIS ID.
      person = Person.find_by_system_id( person_item_person_id )
    
      # Unless we find the person ...
      unless person
        
        # ... we create a new person.
        puts "creating person: #{person_name}"
        person = Person.new
        person.system_id = person_item_person_id
      end
      
      # We set or update the person attributes
      person.name = person_name
      person.save!
    end
    
    # We return the person.
    person
  end
  
  # ## A method to import or update a role
  def import_or_update_role( member_item_role )
    
    # We store the returned variables.
    role_system_id = member_item_role['id']
    role_name = member_item_role['name']
    role_is_chair = member_item_role['isChair']
    
    # We attempt to find the role.
    role = Role.find_by_system_id( role_system_id )
    
    # Unless we find the role ...
    unless role
      
      # ... we create a new role.
      puts "creating new role: #{role_name}"
      role = Role.new
      role.name = role_name
      role.is_chair = role_is_chair
      role.system_id = role_system_id
      role.save
    end
    
    # We return the role.
    role
  end
  
  # ## A method to import or update a written evidence item.
  def import_or_update_written_evidence( written_evidence_item )
    
    # We store the returned variables.
    written_evidence_publication_system_id = written_evidence_item['id']
    written_evidence_publication_submission_id = written_evidence_item['submissionId']
    written_evidence_publication_internal_reference = written_evidence_item['internalReference']
    written_evidence_publication_legacy_html_url = written_evidence_item['legacyHtmlUrl']
    written_evidence_publication_legacy_pdf_url = written_evidence_item['legacyPdfUrl']
    written_evidence_publication_is_anonymous = written_evidence_item['anonymous']
    written_evidence_publication_anonymous_witness_text = written_evidence_item['anonymousWitnessText']
    written_evidence_publication_published_at = written_evidence_item['publicationDate']
    written_evidence_publication_work_package_system_id = written_evidence_item['committeeBusiness']['id']
    
    # We try to find the work package.
    work_package = WorkPackage.find_by_system_id( written_evidence_publication_work_package_system_id )
    
    # We try to find the written evidence item.
    written_evidence_publication = WrittenEvidencePublication.find_by_system_id( written_evidence_publication_system_id )
    
    # Unless we find the written evidence item ...
    unless written_evidence_publication
    
      # ... we create a new written evidence publication.
      puts "creating a new written evidence publication #{written_evidence_publication_system_id} - for work package #{written_evidence_publication_work_package_system_id}"
      written_evidence_publication = WrittenEvidencePublication.new
      written_evidence_publication.system_id = written_evidence_publication_system_id
    end
    
    # We update the written evidence item attributes.
    written_evidence_publication.submission_id = written_evidence_publication_submission_id
    written_evidence_publication.internal_reference = written_evidence_publication_internal_reference
    written_evidence_publication.legacy_html_url = written_evidence_publication_legacy_html_url
    written_evidence_publication.legacy_pdf_url = written_evidence_publication_legacy_pdf_url
    written_evidence_publication.is_anonymous = written_evidence_publication_is_anonymous
    written_evidence_publication.anonymous_witness_text = written_evidence_publication_anonymous_witness_text
    written_evidence_publication.published_at = written_evidence_publication_published_at
    written_evidence_publication.work_package = work_package
    written_evidence_publication.save!
    
    # For each committee associated with a written evidence publication ...
    written_evidence_item['committees'].each do |committee|
      
      # ... we get the committee ID ...
      committee_id = committee['id']
      
      # ... and find the committee.
      committee = Committee.find( committee_id )
      
      # We attempt to find a committee written evidence publication.
      committee_written_evidence_publication = CommitteeWrittenEvidencePublication
        .where( "committee_id = ?", committee.id )
        .where( "written_evidence_publication_id = ?", written_evidence_publication.id)
        .first
        
      # Unless we've found a committee written evidence publication ...
      unless committee_written_evidence_publication
        
        # ... we create a new committee written evidence publication.
        puts "creating a new committee written evidence publication"
        committee_written_evidence_publication = CommitteeWrittenEvidencePublication.new
        committee_written_evidence_publication.committee = committee
        committee_written_evidence_publication.written_evidence_publication = written_evidence_publication
        committee_written_evidence_publication.save!
      end
    end
    
    
    
    
    #written_evidence_item_house_of_commons_number = written_evidence_item['hcNumber']
    
    
  
    
    #puts written_evidence_item_house_of_commons_number if written_evidence_item_house_of_commons_number
  end
  
  # ## A method to import or update a publication.
  def import_or_update_publication( publication_item )
    
    # We store the returned variables.
    publication_item_system_id = publication_item['id']
    publication_item_description = publication_item['description']
    publication_item_start_at = publication_item['publicationStartDate']
    publication_item_end_at = publication_item['publicationEndDate']
    publication_item_additional_content_url = publication_item['additionalContentUrl']
    publication_item_additional_content_url_2 = publication_item['additionalContentUrl2']
    publication_item_reponse_to_publication_id = publication_item['response_to_publication_id']
    publication_item_publication_type_system_id = publication_item['type']['id']
    publication_item_committee_system_id = publication_item['committee']['id']
    publication_item_department_system_id = publication_item['respondingDepartment']['id'] if publication_item['respondingDepartment']
    publication_item_documents = publication_item['documents']
    publication_item_house_of_commons_paper_number = publication_item['hcNumber']
    publication_item_house_of_lords_paper_number = publication_item['hlPaper']
    
    # We attempt to find the publication type.
    publication_type = PublicationType.find_by_system_id( publication_item_publication_type_system_id )
    
    # We attempt to find the committee.
    committee = Committee.find_by_system_id( publication_item_committee_system_id )
    
    # We attempt to find the publication this publication is in response to.
    responded_to_publication = Publication.find_by_system_id( publication_item_reponse_to_publication_id )
    
    # We attempt to find the publication.
    publication = Publication.find_by_system_id( publication_item_system_id )
    
    # If the publication has a responding department ...
    if publication_item_department_system_id
      
      # ... we attempt to find the department.
      department = Department.find_by_system_id( publication_item_department_system_id )
    end
    
    # Unless we find the publication ...
    unless publication
      
      # ... we create a new publication.
      #puts "Creating a new publication: #{publication_item_description}"
      publication = Publication.new
      publication.system_id = publication_item_system_id
    end
    
    # We assign or update the publication's attributes.
    publication.description = publication_item_description
    publication.start_at = publication_item_start_at
    publication.end_at = publication_item_end_at
    publication.additional_content_url = publication_item_additional_content_url
    publication.additional_content_url_2 = publication_item_additional_content_url_2
    publication.publication_type = publication_type
    publication.committee = committee
    publication.responded_to_publication_id = responded_to_publication.id if publication_item_reponse_to_publication_id
    publication.department = department if department
    publication.save!
    
    # If the publication item has a House of Commons paper number ...
    if publication_item_house_of_commons_paper_number
      
      # ... we associate the publication with its House of Commons paper series number.
      associate_publication_with_paper_series_number( publication, publication_item_house_of_commons_paper_number, 'Commons' )
    end
    
    # If the publication item has a House of Lords paper number ...
    if publication_item_house_of_lords_paper_number
      
      # ... we associate the publication with its House of Lords paper series number.
      associate_publication_with_paper_series_number( publication, publication_item_house_of_lords_paper_number, 'Lords' )
    end
    
    # For each 'business' the publication refers to ...
    publication_item['businesses'].each do |work_package_item|
      
      # ... we attempt to find the work package.
      work_package = WorkPackage.find_by_system_id( work_package_item['id'] )
      
      # We check if the work package publication link exists.
      work_package_publication = WorkPackagePublication
        .all
        .where( "work_package_id = ?", work_package.id )
        .where( "publication_id = ?", publication.id )
        .first
        
      # If the work package publication link does not exist ...
      unless work_package_publication
      
        # ... we create a work package publication.
        puts "Creating a new publication to work package link"
        work_package_publication = WorkPackagePublication.new
        work_package_publication.work_package = work_package
        work_package_publication.publication = publication
        work_package_publication.save!
      end
    end
    
    # For each document attached to the publication ...
    publication_item_documents.each do |publication_document_item|
    
      # ... we store the returned variables.
      publication_document_item_system_id = publication_document_item['documentId']
      
      # We check if there's a publication document with this ID.
      publication_document = PublicationDocument.find_by_system_id( publication_document_item_system_id )
      
      # Unless we find a publication document ...
      unless publication_document
        
        # ... we create a new publication document.
        #puts "Creating a new publication document: #{publication_document_item_system_id}"
        publication_document = PublicationDocument.new
        publication_document.system_id = publication_document_item_system_id
        publication_document.publication = publication
        publication_document.save!
      end
      
      # For each publication document file attached to the publication document ...
      publication_document_item['files'].each do |publication_document_file_item|
    
        # We store the returned variables.
        publication_document_file_item_name = publication_document_file_item['fileName']
        publication_document_file_item_size = publication_document_file_item['fileSize']
        publication_document_file_item_format = publication_document_file_item['fileDataFormat']
        publication_document_file_item_url = publication_document_file_item['url']
        
        # We attempt to find this publication document file ...
        publication_document_file = PublicationDocumentFile
          .all
          .where( "name = ?", publication_document_file_item_name )
          .where( "size =? ", publication_document_file_item_size )
          .where( "format =?", publication_document_file_item_format )
          .where( "url = ?", publication_document_file_item_url )
          .where( "publication_document_id = ?", publication_document.id )
          .first
          
        # Unless the publication document file exists ...
        unless publication_document_file
        
          # ... we create a new publication document file.
          puts "Creating a new publication document file: #{publication_document_file_item_name}"
          publication_document_file = PublicationDocumentFile.new
          publication_document_file.name = publication_document_file_item_name
          publication_document_file.size = publication_document_file_item_size
          publication_document_file.format = publication_document_file_item_format
          publication_document_file.url = publication_document_file_item_url
          publication_document_file.publication_document = publication_document
          publication_document_file.save!
        end
      end
    end
  end
  
  
  
  # ## Mass import methods run a one off set ups.
  
  # ### A method to import all committees.
  def import_committees( skip )
    puts "importing committees"
    
    # We set the URL to import from.
    url = "https://committees-api.parliament.uk/api/Committees?CommitteeStatus=all&ShowOnWebsiteOnly=false&take=30&skip=#{skip}"
    
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
  
  # ### A method to import all work packages.
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
  
  # ### A method to get work packages for committees.
  def link_committees_to_work_packages
    puts "importing links between committees and work packages"
    
    # We get all the committees.
    committees = Committee.all
    
    # For each committee ...
    committees.each do |committee|
      
      # ... we get the work packages.
      get_work_packages_for_committee( committee, 0 )
    end
  end
  
  # ### A method to import all events.
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
  
  # ### A method to import all oral evidence sessions.
  def import_all_oral_evidence_transcripts( skip )
    puts "importing oral evidence transcripts"
    
    # We set the URL to import from.
    url = "https://committees-api.parliament.uk/api/OralEvidence?take=30&skip=#{skip}"
    
    # We get the JSON.
    json = JSON.load( URI.open( url ) )
    
    # For each oral evidence transcript item in the feed ....
    json['items'].each do |oral_evidence_transcript_item|
      
      # ... we import or update the oral evidence transcript.
      import_or_update_oral_evidence_transcript( oral_evidence_transcript_item )
    end
    
    # We get the total results count from the API.
    total_results = json['totalResults']
    
    # If the total results count is greater than the number of results skipped ...
    if total_results > skip
      
      # ... we call this method again, incrementing the skip by by 30 results.
      import_all_oral_evidence_transcripts( skip + 30 )
    end
  end
  
  # ### A method to import all memberships.
  def import_all_memberships
    puts "importing all memberships"
    
    # We get all the committees.
    committees = Committee.all
    
    # For each committee ...
    committees.each do |committee|
      
      # ... we import its memberships.
      get_memberships_for_committee( committee, 0 )
    end
  end
  
  # ### A method to import all written evidence.
  def import_all_written_evidence( skip )
    puts "importing written evidence"
    
    # We set the URL to import from.
    url = "https://committees-api.parliament.uk/api/WrittenEvidence?ShowOnWebsiteOnly=false&take=30&skip=#{skip}"
    
    # We get the JSON.
    json = JSON.load( URI.open( url ) )
    
    # For each written evidence transcript item in the feed ....
    json['items'].each do |written_evidence_item|
      
      # ... we import or update the written evidence.
      import_or_update_written_evidence( written_evidence_item )
    end
    
    # We get the total results count from the API.
    total_results = json['totalResults']
    
    # If the total results count is greater than the number of results skipped ...
    if total_results > skip
      
      # ... we call this method again, incrementing the skip by by 30 results.
      import_written_evidence( skip + 30 )
    end
  end
  
  # ### A method to import all written evidence.
  def import_all_publications( skip )
    puts "importing all publications"
    
    # We set the URL to import from.
    url = "https://committees-api.parliament.uk/api/Publications?take=30&skip=#{skip}"
    
    # We get the JSON.
    json = JSON.load( URI.open( url ) )
    
    # For each publication item in the feed ....
    json['items'].each do |publication_item|
      
      # ... we import or update the publication.
      import_or_update_publication( publication_item )
    end
    
    # We get the total results count from the API.
    total_results = json['totalResults']
    
    # If the total results count is greater than the number of results skipped ...
    if total_results > skip
      
      # ... we call this method again, incrementing the skip by by 30 results.
      import_all_publications( skip + 30 )
    end
  end
end