inlist=/usr/bin/sqlite3 /opt/cloverleaf/cis20.1/integrator/epic_adt1/exec/hcimonitord/mdstatsdb.sdb "SELECT name FROM sqlite_master WHERE type='table' ORDER by name;"
for item in $inlist; do
    echo "tableDump.pl /usr/bin/sqlite3 /opt/cloverleaf/cis20.1/integrator/epic_adt1/exec/hcimonitord/mdstatsdb.sdb $item $item.csv"
    tableDump.pl /usr/bin/sqlite3 /opt/cloverleaf/cis20.1/integrator/epic_adt1/exec/hcimonitord/mdstatsdb.sdb $item $item.csv
done
