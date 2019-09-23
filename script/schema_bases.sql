-- this schema encodes SNPs as [ACGT] (ref), [ACGT] (het), [ACGT] (homo alt)

CREATE TABLE refsites(
    refsite_id integer not null constraint refsite_pk primary key,
    chromosome integer not null,
	position integer not null,
	refallele text not null
);

CREATE TABLE accessions(
    accession_id integer not null constraint accession_pk primary key,
    label text,
    botanical_variety text,
    status text,
    country text,
    latitude real,
    longitude real
);

CREATE TABLE snps(
    snp_id integer not null constraint snp_pk primary key,
    refsite_id integer not null constraint refsite_fk references refsites(refsite_id),
    accession_id integer not null constraint accession_fk references accessions(accession_id),
	altallele_hom text not null,
	altallele_het text not null
);