package sqlDo;
use strict;
use Exporter qw(import);

our $VERSION     = 0.01;
our @ISA         = qw(Exporter);
our @EXPORT_OK   = qw( dumpDbTables listTable listTableSortBy insertItem deleteItem modifyItem getVal makeDb makeDbTable returnThree);

#my $dbLoc  = "/hci/qdx5.5/integrator/sqliteCchs";
my $sqlite = "/usr/bin/sqlite3";

sub dumpDbTables {
	my @myIn     = @_;
	my $dbName   = shift;
	# SELECT name FROM sqlite_master WHERE type='table' ORDER BY name;
	#my $command  =  "$sqlite $dbLoc/$dbName \"SELECT name FROM sqlite_master WHERE type='table' ORDER BY name\"\;";
	my $command  =  "$sqlite $dbName \"SELECT name FROM sqlite_master WHERE type='table' ORDER BY name\"\;";
	my @outVals = `$command`;
	return @outVals;
}
sub listTable  { 
	my @myIn     = @_;
	my $dbName   = shift;
	my $dbTable  = shift;
	#my $command  =  "$sqlite $dbLoc/$dbName \"select * from $dbTable\"\;";
	my $command  =  "$sqlite $dbName \"select * from $dbTable\"\;";
	my $outVals = `$command`;
	return $outVals;
}
sub listTableSortBy  { 
	my @myIn     = @_;
	my $dbName   = shift;
	my $dbTable  = shift;
        my $sortBy = shift;
	my $command  =  "$sqlite $dbName \"select * from $dbTable ORDER by $sortBy ASC\"\;";
	my $outVals = `$command`;
	return $outVals;
}
sub deleteItem  { 
	my @myIn     = @_;
	my $dbName   = shift;
	my $dbTable  = shift;
	my $colName  = shift;
	#my $command  =  "$sqlite $dbLoc/$dbName \"delete from $dbTable where name='$colName'\"\;";
	my $command  =  "$sqlite $dbName \"delete from $dbTable where name='$colName'\"\;";
	my $dumpVals = `$command`;
    my $outVals  = " -- " . $command;
	return $outVals;
}
sub insertItem  { 
	my @myIn = @_;
	my $dbName   = shift;
	my $dbTable  = shift;
	my $colName  = shift;
	my $colVal   = shift;
	my $colComm  = shift;
	# Test for existing	
	#my $command  = "$sqlite $dbLoc/$dbName \"select val from $dbTable where name like '$colName'\"\;"; 
	my $command  = "$sqlite $dbName \"select val from $dbTable where name like '$colName'\"\;"; 
    my $flag = `$command`;
    my $dumpVals = "";
    # Check for value
	if (!$flag) {
		#$command  = "$sqlite $dbLoc/$dbName \"insert into $dbTable values ('$colName', '$colVal', '$colComm|')\"\;";
		$command  = "$sqlite $dbName \"insert into $dbTable values ('$colName', '$colVal', '$colComm|')\"\;";
        $dumpVals = `$command`;
    } else {
		$dumpVals = "Name-Value Pair Exists: $colName = $flag\nPlease, delete a record and re-add it to make a change";
    }
	$dumpVals = " ++ " . $command;
	return $dumpVals;
}
sub modifyItem  { 
	my @myIn = @_;
	my $dbName   = shift;
	my $dbTable  = shift;
	my $colName  = shift;
	my $colVal   = shift;
	my $colComm  = shift;
	# Test for existing	
	#my $command  = "$sqlite $dbLoc/$dbName \"select val from $dbTable where name like '$colName'\"\;";
	my $command  = "$sqlite $dbName \"select val from $dbTable where name like '$colName'\"\;"; 
    my $flag = `$command`;
    my $delComm;
    my $delVals;
    my $dumpVals;
    # Check for value
	if ($flag) {
		#$delComm  = "$sqlite $dbLoc/$dbName \"delete from $dbTable where name like '$colName'\"\;";
		$delComm  = "$sqlite $dbName \"delete from $dbTable where name like '$colName'\"\;";
		$delVals = `$delComm`;
		#$command  = "$sqlite $dbLoc/$dbName \"insert into $dbTable values ('$colName', '$colVal', '$colComm|')\"\;";
		$command  = "$sqlite $dbName \"insert into $dbTable values ('$colName', '$colVal', '$colComm|')\"\;";
        $delVals = $delVals . `$command`;
    } else {
		$dumpVals = "Value $colName did not exist";
    }
	$dumpVals = " -+ " . $command;
	return $dumpVals;
}
sub getVal  { 
	my @myIn     = @_;
	my $dbName   = shift;
	my $dbTable  = shift;
	my $selectFor= shift;   
	#my $command  =  "$sqlite $dbLoc/$dbName \"select val from $dbTable where name like '$selectFor'\"\;";
	my $command  =  "$sqlite $dbName \"select val from $dbTable where name like '$selectFor'\"\;";
	my $dumpVals = `$command`;
	return $dumpVals;
}
sub makeDbTable {
	my @myIn    = @_;
	my $dbName  = shift;
	my $dbTable = shift;
	#my $command  =  "$sqlite $dbLoc/$dbName \"drop table $dbTable\"\;";
	my $command  =  "$sqlite $dbName \"drop table $dbTable\"\;";
	my $dumpVals = `$command`;
	   #$command  =  "$sqlite $dbLoc/$dbName \"create table $dbTable (name text, val text, comment text)\"\;";
	   $command  =  "$sqlite $dbName \"create table $dbTable (name text, val text, comment text)\"\;";
	   $dumpVals = $dumpVals . `$command`;
	return $dumpVals;
}
sub returnThree  { 
	my @myIn     = @_;
	my $dbName   = shift;
	my $dbTable  = shift;
	#my $command  =  "$sqlite $dbLoc/$dbName \"select name, val, comment from $dbTable\"\;";
	my $command  =  "$sqlite $dbName \"select name, val, comment from $dbTable\"\;";
	my @dumpVals = `$command`;
	return  @dumpVals;
}	

# the 1 should be at the very end
1;
