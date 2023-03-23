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
    

    
    #committee_lead_house = committee_item['leadHouse']
    
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
      committee.is_shown_on_website = committee_show_on_website
      committee.legacy_url = committee_website_legacy_url
      committee.is_redirect_enabled = committee_website_legacy_redirect_enabled
      committee.address = committee_address
      committee.phone = committee_phone
      committee.email = committee_email
      committee.contact_disclaimer = committee_contact_disclaimer
      committee.save
      
      
      
			#"leadHouse": {
				#"isCommons": true,
				#"isLords": false
        #},
        #"dateCommonsAppointed": "2014-06-11T00:00:00",
			#"dateLordsAppointed": "2014-06-09T00:00:00",
      #"isLeadCommittee": null
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
end