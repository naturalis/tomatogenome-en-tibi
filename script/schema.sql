CREATE TABLE refsites (
    chromosome integer not null,
	position integer not null,
	refallele text not null,
	primary key (chromosome,position)
);

CREATE TABLE accessions (
	accession text constraint code_pk primary key,
	variety text,
	category text,
	origin text,
	latitude real,
	longitude real
);

CREATE TABLE snps (
	chromosome integer constraint chromosome_fk references refsites(chromosome),
	position integer constraint position_fk references refsites(position),
	altallele text not null,
	accession text constraint accession_fk references refsites(accession)
);	