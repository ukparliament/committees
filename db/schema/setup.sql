drop table if exists paper_series_numbers;
drop table if exists committee_written_evidence_publications;
drop table if exists written_evidence_publications;
drop table if exists publication_document_files;
drop table if exists publication_documents;
drop table if exists work_package_publications;
drop table if exists publications;
drop table if exists publication_types;
drop table if exists memberships;
drop table if exists witness_positions;
drop table if exists witnesses;
drop table if exists positions;
drop table if exists organisations;
drop table if exists people;
drop table if exists oral_evidence_transcript_files;
drop table if exists committee_oral_evidence_transcripts;
drop table if exists work_package_oral_evidence_transcripts;
drop table if exists oral_evidence_transcripts;
drop table if exists event_segments;
drop table if exists committee_events;
drop table if exists committee_work_packages;
drop table if exists work_packages;
drop table if exists scrutinisings;
drop table if exists committee_committee_types;
drop table if exists committee_houses;
drop table if exists committee_types;
drop table if exists categories;
drop table if exists departments;
drop table if exists work_package_types;
drop table if exists committees;
drop table if exists parliamentary_houses;
drop table if exists events;
drop table if exists locations;
drop table if exists event_types;
drop table if exists activity_types;
drop table if exists sessions;
drop table if exists roles;



create table roles (
	id serial not null,
	name varchar(255),
	is_chair boolean default false,
	system_id int not null,
	primary key (id)
);

create table sessions (
	id serial not null,
	label varchar(255),
	system_id int not null,
	primary key (id)
);

create table activity_types (
	id serial not null,
	name varchar(255),
	primary key (id)
);

create table event_types (
	id serial not null,
	name varchar(255),
	is_visit boolean default false,
	description varchar(5000) not null,
	system_id int not null,
	primary key (id)
);

create table locations (
	id serial not null,
	name varchar(255),
	system_id int not null,
	primary key (id)
);

create table events (
	id serial not null,
	name varchar(255),
	start_at timestamp not null,
	end_at timestamp not null,
	cancelled_at timestamp,
	location_name varchar(255),
	originating_system varchar(255) not null,
	system_id int not null,
	location_id int,
	event_type_id int not null,
	constraint fk_location foreign key (location_id) references locations(id),
	constraint fk_event_type foreign key (event_type_id) references event_types(id),
	primary key (id)
);

create table work_package_types (
	id serial not null,
	name varchar(255) not null,
	description varchar(1000) not null,
	is_inquiry boolean default false,
	system_id int not null,
	primary key (id)
);

create table departments (
	id serial not null,
	name varchar(255) not null,
	system_id int not null,
	primary key (id)
);

create table parliamentary_houses (
	id serial not null,
	short_label varchar(255) not null,
	label varchar(255) not null,
	primary key (id)
);
insert into parliamentary_houses (short_label, label) values( 'Commons', 'House of Commons' );
insert into parliamentary_houses (short_label, label) values( 'Lords', 'House of Lords' );

create table categories (
	id serial not null,
	name varchar(255) not null,
	system_id int not null,
	primary key (id)
);

create table committee_types (
	id serial not null,
	name varchar(255) not null,
	system_id int not null,
	category_id int not null,
	constraint fk_category foreign key (category_id) references categories(id),
	primary key (id)
);

create table committees (
	id serial not null,
	name varchar(255) not null,
	start_on date,
	end_on date,
	commons_appointed_on date,
	lords_appointed_on date,
	lead_parliamentary_house_id int,
	address varchar(500),
	phone varchar(500),
	email varchar(500),
	contact_disclaimer varchar(500),
	is_shown_on_website boolean default false,
	legacy_url varchar(500),
	is_redirect_enabled boolean default false,
	is_lead_committee boolean default false,
	system_id int not null,
	parent_committee_id int,
	constraint fk_parent_committee foreign key (parent_committee_id) references committees(id),
	constraint fk_lead_parliamentary_house foreign key (lead_parliamentary_house_id) references parliamentary_houses(id),
	primary key (id)
);

create table committee_houses (
	id serial not null,
	committee_id int not null,
	parliamentary_house_id int not null,
	constraint fk_committee foreign key (committee_id) references committees(id),
	constraint fk_parliamentary_house foreign key (parliamentary_house_id) references parliamentary_houses(id),
	primary key (id)
);

create table committee_committee_types (
	id serial not null,
	committee_id int not null,
	committee_type_id int not null,
	constraint fk_committee foreign key (committee_id) references committees(id),
	constraint fk_committee_type foreign key (committee_type_id) references committee_types(id),
	primary key (id)
);

create table scrutinisings (
	id serial not null,
	committee_id int not null,
	department_id int not null,
	constraint fk_committee foreign key (committee_id) references committees(id),
	constraint fk_department foreign key (department_id) references departments(id),
	primary key (id)
);

create table work_packages (
	id serial not null,
	title varchar(1000) not null,
	open_on date not null,
	close_on date,
	system_id int not null,
	work_package_type_id int not null,
	constraint fk_work_package_type foreign key (work_package_type_id) references work_packages(id),
	primary key (id)
);

create table committee_work_packages (
	id serial not null,
	committee_id int not null,
	work_package_id int not null,
	constraint fk_committee foreign key (committee_id) references committees(id),
	constraint fk_work_package foreign key (work_package_id) references work_packages(id),
	primary key (id)
);

create table committee_events (
	id serial not null,
	committee_id int not null,
	event_id int not null,
	constraint fk_committee foreign key (committee_id) references committees(id),
	constraint fk_event foreign key (event_id) references events(id),
	primary key (id)
);

create table event_segments (
	id serial not null,
	name varchar(255),
	start_at timestamp not null,
	end_at timestamp,
	is_private boolean default false,
	system_id int not null,
	event_id int not null,
	activity_type_id int not null,
	constraint fk_event foreign key (event_id) references events(id),
	constraint fk_activity_type foreign key (activity_type_id) references activity_types(id),
	primary key (id)
);

create table oral_evidence_transcripts (
	id serial not null,
	start_on date not null,
	meeting_on date,
	published_on date not null,
	legacy_html_url varchar(255),
	legacy_pdf_url varchar(255),
	document_id int,
	system_id int not null,
	event_segment_id int,
	constraint fk_event_segment foreign key (event_segment_id) references event_segments(id),
	primary key (id)
);

create table committee_oral_evidence_transcripts (
	id serial not null,
	committee_id int not null,
	oral_evidence_transcript_id int not null,
	constraint fk_committee foreign key (committee_id) references committees(id),
	constraint fk_oral_evidence_transcript foreign key (oral_evidence_transcript_id) references oral_evidence_transcripts(id),
	primary key (id)
);

create table work_package_oral_evidence_transcripts (
	id serial not null,
	work_package_id int not null,
	oral_evidence_transcript_id int not null,
	constraint fk_work_package foreign key (work_package_id) references work_packages(id),
	constraint fk_oral_evidence_transcript foreign key (oral_evidence_transcript_id) references oral_evidence_transcripts(id),
	primary key (id)
);

create table oral_evidence_transcript_files (
	id serial not null,
	name varchar(255) not null,
	size int not null,
	format varchar(255) not null,
	url varchar(1000),
	oral_evidence_transcript_id int not null,
	constraint fk_oral_evidence_transcript foreign key (oral_evidence_transcript_id) references oral_evidence_transcripts(id),
	primary key (id)
);

create table people (
	id serial not null,
	name varchar(1000) not null,
	system_id int,
	mnis_id int,
	primary key (id)
);

create table organisations (
	id serial not null,
	name varchar(1000) not null,
	idms_id varchar(255),
	system_id int not null,
	primary key (id)
);

create table positions (
	id serial not null,
	name varchar(255) not null,
	organisation_id int not null,
	constraint fk_organisation foreign key (organisation_id) references organisations(id),
	primary key (id)
);

create table witnesses (
	id serial not null,
	person_name varchar(3000),
	system_id int,
	person_id int,
	oral_evidence_transcript_id int not null,
	constraint fk_person foreign key (person_id) references people(id),
	constraint fk_oral_evidence_transcript foreign key (oral_evidence_transcript_id) references oral_evidence_transcripts(id),
	primary key (id)
);

create table witness_positions (
	id serial not null,
	witness_id int not null,
	position_id int not null,
	constraint fk_witness foreign key (witness_id) references witnesses(id),
	constraint fk_position foreign key (position_id) references positions(id),
	primary key (id)
);

create table memberships (
	id serial not null,
	start_on date not null,
	end_on date,
	is_lay_member boolean default false,
	is_ex_officio boolean default false,
	is_alternate boolean default false,
	is_co_opted boolean default false,
	system_id int not null,
	person_id int not null,
	committee_id int not null,
	role_id int not null,
	constraint fk_committee foreign key (committee_id) references committees(id),
	constraint fk_person foreign key (person_id) references people(id),
	constraint fk_role foreign key (role_id) references Roles(id),
	primary key (id)
);

create table publication_types (
	id serial not null,
	name varchar(255) not null,
	plural_name varchar(255) not null,
	description text not null,
	government_can_respond boolean default false,
	can_be_response boolean default false,
	icon_key varchar(255),
	system_id int not null,
	primary key (id)
);

create table publications (
	id serial not null,
	description text not null,
	start_at timestamp not null,
	end_at timestamp,
	additional_content_url varchar(500),
	additional_content_url_2 varchar(500),
	system_id int not null,
	committee_id int not null,
	publication_type_id int not null,
	responded_to_publication_id int,
	department_id int,
	constraint fk_committee foreign key (committee_id) references committees(id),
	constraint fk_publication_type foreign key (publication_type_id) references publication_types(id),
	constraint fk_responded_to_publication_type foreign key (responded_to_publication_id) references publication_types(id),
	constraint fk_department foreign key (department_id) references departments(id),
	primary key (id)
);

create table work_package_publications (
	id serial not null,
	work_package_id int not null,
	publication_id int not null,
	constraint fk_work_package foreign key (work_package_id) references work_packages(id),
	constraint fk_publication foreign key (publication_id) references publications(id),
	primary key (id)
);

create table publication_documents (
	id serial not null,
	publication_id int not null,
	system_id int not null,
	constraint fk_publication foreign key (publication_id) references publications(id),
	primary key (id)
);

create table publication_document_files (
	id serial not null,
	name text not null,
	size int not null,
	format varchar(255) not null,
	url varchar(1000),
	publication_document_id int not null,
	constraint fk_publication_document foreign key (publication_document_id) references publication_documents(id),
	primary key (id)
);

create table written_evidence_publications (
	id serial not null,
	submission_id varchar(255) not null,
	internal_reference varchar(255) not null,
	published_at timestamp not null,
	legacy_html_url varchar(255),
	legacy_pdf_url varchar(255),
	is_anonymous boolean default false,
	anonymous_witness_text varchar(255),
	work_package_id int not null,
	system_id int not null,
	constraint fk_work_package foreign key (work_package_id) references work_packages(id),
	primary key (id)
);

create table committee_written_evidence_publications (
	id serial not null,
	committee_id int not null,
	written_evidence_publication_id int not null,
	constraint fk_committee foreign key (committee_id) references committees(id),
	constraint fk_written_evidence_publication foreign key (written_evidence_publication_id) references written_evidence_publications(id),
	primary key (id)
);

create table paper_series_numbers (
	id serial not null,
	number varchar(255) not null,
	session_id int not null,
	parliamentary_house_id int not null,
	oral_evidence_transcript_id int,
	publication_id int,
	written_evidence_publication_id int,
	constraint fk_session foreign key (session_id) references sessions(id),
	constraint fk_parliamentary_house foreign key (parliamentary_house_id) references parliamentary_houses(id),
	constraint fk_oral_evidence_transcript foreign key (oral_evidence_transcript_id) references oral_evidence_transcripts(id),
	constraint fk_written_evidence_publication foreign key (oral_evidence_transcript_id) references oral_evidence_transcripts(id),
	constraint fk_publication foreign key (publication_id) references publications(id),
	primary key (id)
);