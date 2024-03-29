Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'home#index'
  
  get 'committees' => 'home#index', :as => 'home'
  
  get 'committees/committee-categories' => 'committee_category#index', :as => 'committee_category_list'
  get 'committees/committee-categories/:committee_category' => 'committee_category#show', :as => 'committee_category_show'
  
  get 'committees/committee-types' => 'committee_type#index', :as => 'committee_type_list'
  get 'committees/committee-types/:committee_type' => 'committee_type#show', :as => 'committee_type_show'
  get 'committees/committee-types/:committee_type/current' => 'committee_type#current', :as => 'committee_type_current'
  
  get 'committees/committees' => 'committee#index', :as => 'committee_list'
  get 'committees/committees/current' => 'committee#current', :as => 'committee_current'
  get 'committees/committees/:committee' => 'committee#show', :as => 'committee_show'
  get 'committees/committees/:committee/members' => 'committee#memberships', :as => 'committee_memberships'
  get 'committees/committees/:committee/members/current' => 'committee#current_memberships', :as => 'committee_current_memberships'
  get 'committees/committees/:committee/contact' => 'committee#contact', :as => 'committee_contact'
  get 'committees/committees/:committee/work-packages' => 'committee#work_package_list', :as => 'committee_work_package_list'
  get 'committees/committees/:committee/work-packages/current' => 'committee#work_package_current', :as => 'committee_work_package_current'
  get 'committees/committees/:committee/events' => 'committee#event_list', :as => 'committee_event_list'
  get 'committees/committees/:committee/events/upcoming' => 'committee#event_upcoming', :as => 'committee_event_upcoming'
  get 'committees/committees/:committee/oral-evidence-transcripts' => 'committee#oral_evidence_transcripts', :as => 'committee_oral_evidence_transcripts'
  get 'committees/committees/:committee/publications' => 'committee#publications', :as => 'committee_publications'
  get 'committees/committees/:committee/publication-types' => 'committee#publication_type_list', :as => 'committee_publication_type_list'
  get 'committees/committees/:committee/publication-types/:publication_type' => 'committee#publication_type_show', :as => 'committee_publication_type_show'
  
  get 'committees/houses' => 'house#index', :as => 'house_list'
  get 'committees/houses/:house' => 'house#show', :as => 'house_show'
  get 'committees/houses/:house/current' => 'house#current', :as => 'house_current'
  get 'committees/houses/:house/oral-evidence-transcripts' => 'house#oral_evidence_transcripts', :as => 'house_oral_evidence_transcripts'
  
  get 'committees/joint' => 'joint#index', :as => 'joint_list'
  get 'committees/joint/current' => 'joint#current', :as => 'joint_current'
  
  get 'committees/departments' => 'department#index', :as => 'department_list'
  get 'committees/departments/:department' => 'department#show', :as => 'department_show'
  get 'committees/departments/:department/current' => 'department#current', :as => 'department_current'
  
  get 'committees/work-package-types' => 'work_package_type#index', :as => 'work_package_type_list'
  get 'committees/work-package-types/:work_package_type' => 'work_package_type#show', :as => 'work_package_type_show'
  get 'committees/work-package-types/:work_package_type/current' => 'work_package_type#current', :as => 'work_package_type_current'
  
  get 'committees/work-packages' => 'work_package#index', :as => 'work_package_list'
  get 'committees/work-packages/current' => 'work_package#current', :as => 'work_package_current'
  get 'committees/work-packages/:work_package' => 'work_package#show', :as => 'work_package_show'
  get 'committees/work-packages/:work_package/oral_evidence_transcripts' => 'work_package#oral_evidence_transcripts', :as => 'work_package_oral_evidence_transcript_list'
  get 'committees/work-packages/:work_package/publications' => 'work_package#publications', :as => 'work_package_publication_list'
  get 'committees/work-packages/:work_package/publication-types' => 'work_package#publication_type_list', :as => 'work_package_publication_type_list'
  get 'committees/work-packages/:work_package/publication-types/:publication_type' => 'work_package#publication_type_show', :as => 'work_package_publication_type_show'
  
  get 'committees/events' => 'event#index', :as => 'event_list'
  get 'committees/events/upcoming' => 'event#upcoming', :as => 'event_upcoming'
  get 'committees/events/:event' => 'event#show', :as => 'event_show'
  
  get 'committees/event-types' => 'event_type#index', :as => 'event_type_list'
  get 'committees/event-types/:event_type' => 'event_type#show', :as => 'event_type_show'
  get 'committees/event-types/:event_type/upcoming' => 'event_type#upcoming', :as => 'event_type_upcoming'
  
  get 'committees/locations' => 'location#index', :as => 'location_list'
  get 'committees/locations/:location' => 'location#show', :as => 'location_show'
  get 'committees/locations/:location/upcoming' => 'location#upcoming', :as => 'location_upcoming'
  
  get 'committees/activity-types' => 'activity_type#index', :as => 'activity_type_list'
  get 'committees/activity-types/:activity_type' => 'activity_type#show', :as => 'activity_type_show'
  get 'committees/activity-types/:activity_type/upcoming' => 'activity_type#upcoming', :as => 'activity_type_upcoming'
  
  get 'committees/event-segments' => 'event_segment#index', :as => 'event_segment_list'
  get 'committees/event-segments/upcoming' => 'event_segment#upcoming', :as => 'event_segment_upcoming'
  get 'committees/event-segments/:event_segment' => 'event_segment#show', :as => 'event_segment_show'
  
  get 'committees/oral-evidence-transcripts' => 'oral_evidence_transcript#index', :as => 'oral_evidence_transcript_list'
  get 'committees/oral-evidence-transcripts/upcoming' => 'oral_evidence_transcript#upcoming', :as => 'oral_evidence_transcript_upcoming'
  get 'committees/oral-evidence-transcripts/:oral_evidence_transcript' => 'oral_evidence_transcript#show', :as => 'oral_evidence_transcript_show'
  
  get 'committees/organisations' => 'organisation#index', :as => 'organisation_list'
  get 'committees/organisations/:organisation' => 'organisation#show', :as => 'organisation_show'
  
  get 'committees/positions' => 'position#index', :as => 'position_list'
  get 'committees/positions/:position' => 'position#show', :as => 'position_show'
  get 'committees/positions/:position/oral-evidence-transcripts' => 'position#oral_evidence_transcripts', :as => 'position_oral_evidence_transcripts'
  
  get 'committees/people' => 'person#index', :as => 'person_list'
  get 'committees/people/members' => 'person#members', :as => 'person_member_list'
  get 'committees/people/non-members' => 'person#non_members', :as => 'person_non_member_list'
  get 'committees/people/committee-members' => 'person#committee_members', :as => 'person_committee_member_list'
  get 'committees/people/:person' => 'person#show', :as => 'person_show'
  get 'committees/people/:person/oral-evidence-transcripts' => 'person#oral_evidence_transcripts', :as => 'person_oral_evidence_transcripts'
  get 'committees/people/:person/committee-memberships' => 'person#committee_memberships', :as => 'person_committee_memberships'
  
  get 'committees/memberships' => 'membership#index', :as => 'membership_list'
  get 'committees/memberships/current' => 'membership#current', :as => 'membership_current'
  get 'committees/memberships/:membership' => 'membership#show', :as => 'membership_show'
  
  get 'committees/membership-roles' => 'membership_role#index', :as => 'membership_role_list'
  get 'committees/membership-roles/:membership_role' => 'membership_role#show', :as => 'membership_role_show'
  get 'committees/membership-roles/:membership_role/current' => 'membership_role#current', :as => 'membership_role_current'
  
  get 'committees/publications' => 'publication#index', :as => 'publication_list'
  get 'committees/publications/:publication' => 'publication#show', :as => 'publication_show'
  
  get 'committees/publication-types' => 'publication_type#index', :as => 'publication_type_list'
  get 'committees/publication-types/:publication_type' => 'publication_type#show', :as => 'publication_type_show'
  
  get 'committees/meta' => 'meta#index', :as => 'meta_list'
  get 'committees/meta/schema' => 'meta#schema', :as => 'meta_schema'
end
