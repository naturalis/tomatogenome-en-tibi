-- creates the appropriate indexes to create a searchable database to speed up creating the snp matrices.
CREATE INDEX "accession_fk" ON "snps" ( "accession_id" )
CREATE INDEX "accession_id" ON "accessions" ( "accession_id" )
CREATE UNIQUE INDEX "accession_refsite_snp" ON "snps" ( "snp_id", "refsite_id", "accession_id" )
CREATE INDEX "refsite_fk" ON "snps" ( "refsite_id" )
CREATE UNIQUE INDEX "refsite_id" ON "refsites" ( "refsite_id" )