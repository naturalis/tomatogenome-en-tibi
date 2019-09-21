#!/bin/bash
DB=$HOME/Dropbox/documents/projects/dropbox-projects/tomatogenome-en-tibi/data/snps.db
dbicdump -o dump_directory=../lib Bio::EnTibi dbi:SQLite:$DB
