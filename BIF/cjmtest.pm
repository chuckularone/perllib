# Copyright 2007 Chuck McKenna/chuckularone
#
# Testing

package cjmtest;

use strict;
use Exporter qw(import);

our $VERSION     = 0.01;
our @ISA         = qw(Exporter);
our @EXPORT_OK   = qw(justVal retVal listTable);

my $dbLoc = "/sitesdevl/sqlite";
my $scriptloc = "/hciScripts";

sub listTable  { 
	my @myIn = @_;
	my $dbName = $myIn[0];
	my $dbTable = $myIn[1];
	my @dumpVals = `$dbLoc/tableDisplay.tcl $dbName $dbTable`;
	return @dumpVals;
}

sub retVal  { 
	 my @myIn = @_;
	 my $name = $myIn[0];
     my $myLoc = $dbLoc . "/" . $name;
     my $myOut = `$scriptloc/tescjm.pl "chuck"`;
#     my $myOut = `$dbLoc/test.tcl $name`;
     return $myOut;  
}

sub justVal  { 
     my $myOut = $dbLoc;
     return $myOut;  
}

1;








# # #
# # #
# # sub dumpTables  { 
# # 	my @myIn = @_;
# # 	my $dbName = $myIn[0];
# # 	my @dumpVals = `$dbLoc/dumpTables.tcl $dbName`;
# # 	return @dumpVals;
# # }

#	
# if ($htmlFlag) {
# 	$outVals[++$#outVals] = "<tr><td>Name</td><td>Value</td><td>Comment</td></tr>";
# }

# foreach (@dumpVals) {
# 	(my $name, my $value, my $comment) = split /\|/, $_ ;
# 	chomp $comment;
# 	
# 	if ($htmlFlag) {
#         if ($name ne "") {
#            $outVals[++$#outVals] = "<tr><td>$name</td><td>$value</td><td>$comment</td></tr>";
#         }
#     } else {
# 	    if ($name ne "") {
#            $outVals[++$#outVals] = "$name|$value|$comment";
#         }
#     } 
# }



#    my @dumpVals = `/hci/qdx5.5/integrator/tcl/bin/sqlite3 /sitesdevl/sqlite/$dbName \"select * from $dbTable\"\;`;
