CREATE TABLE refsites(
    chromosome integer not null,
	position integer not null,
	refallele integer default 0,
	primary key (chromosome,position)
);

CREATE TABLE accessions(
	accession text constraint code_pk primary key,
	variety text,
	category text,
	origin text,
	latitude real,
	longitude real
);

CREATE TABLE snps(
	chromosome integer not null constraint chromosome_fk references refsites(chromosome),
	position integer not null constraint position_fk references refsites(position),
	altallele integer not null,
	accession text not null constraint accession_fk references refsites(accession),
	primary key (chromosome,position,accession)
);	