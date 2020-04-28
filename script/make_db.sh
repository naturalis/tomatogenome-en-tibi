#!/bin/bash
DB=$HOME/EnTibiBases.db
dbicdump -o dump_directory=$HOME/tomatogenome-en-tibi/lib Bio::EnTibiBases dbi:SQLite:$DB
