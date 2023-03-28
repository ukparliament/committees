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