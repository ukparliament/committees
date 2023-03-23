drop table if exists scrutinisings;
drop table if exists committee_committee_types;
drop table if exists committee_houses;
drop table if exists committees;
drop table if exists committee_types;
drop table if exists categories;
drop table if exists parliamentary_houses;
drop table if exists departments;

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