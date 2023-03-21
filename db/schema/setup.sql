drop table if exists committee_committee_types;
drop table if exists committee_houses;
drop table if exists committees;
drop table if exists committee_types;
drop table if exists categories;
drop table if exists parliamentary_houses;

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
	system_id int not null,
	parent_committee_id int,
	constraint fk_parent_committee foreign key (parent_committee_id) references committees(id),
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