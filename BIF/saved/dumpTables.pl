#!/usr/bin/perl
$pathToFtp = "/hciScripts/bif/sql/";
use Getopt::Required;

($options) = 
{
'dbname' =>
        {
        'type'      => '=s',
        'env'       => '-',
        'default'   => '',
        'verbose'   => 'Name of the database to access',
        'order'     => 1,
        'required'     => 1,
        },
'dbtable' =>
        {
        'type'      => '=s',
        'env'       => '-',
        'default'   => '',
        'verbose'   => 'Name of the database table to list',
        'order'     => 2,
        'required'     => 1,
        },
'html' =>
        {
        'type'      => '=s',
        'env'       => '-',
        'default'   => '0',
        'verbose'   => 'if set to 1 outputs as html table',
        'order'     => 2,
        'required'     => 0,
        },
'debug' =>
        {
        'type'      => '=s',
        'env'       => '-',
        'default'   => '0',
        'verbose'   => 'debug: Turn on debug mode in most scripts',
        'order'     => 12,
        'required'     => 0,
        },
};        

my($option) = new Getopt::Required;
if (! $option -> getOptions($options, "Usage: sqlList.pl [options]") ) { exit(-1); }

@arrayParm = ("dbname", "dbtable", "html", "debug");
$debug    = $option->{'switch'}{'debug'};
$dbName   = $option->{'switch'}{'dbname'};
$htmlFlag = $option->{'switch'}{'html'};
$dbTable  = $option->{'switch'}{'dbtable'};
  
foreach $parm (@arrayParm) {
   $argHash{$parm} = $option->{'switch'}{$parm};
   # check for required options
   $optFlag = $option->isRequired($parm);
   if ( $optFlag ) {
      print "Invalid option in $0: $optFlag\n";
      exit(-1);
   }

   # print debug info if requested
   if ( $debug ) {
      print "$parm:      ".$argHash{$parm}."\n";
   }
 }
 
@outVals=();
 
@dumpVals = `/hci/qdx5.5/integrator/tcl/bin/sqlite3 /sitesdevl/sqlite/$dbName \"select * from $dbTable\"\;`;

if ($htmlFlag) {
	$outVals[++$#outVals] = "<tr><td>Name</td><td>Value</td><td>Comment</td></tr>";
}

foreach (@dumpVals) {
	(my $name, my $value, my $comment) = split /\|/, $_ ;
	chomp $comment;
	
	if ($htmlFlag) {
        if ($name ne "") {
           $outVals[++$#outVals] = "<tr><td>$name</td><td>$value</td><td>$comment</td></tr>";
        }
    } else {
	    if ($name ne "") {
           $outVals[++$#outVals] = "$name|$value|$comment";
        }
    } 
}

foreach (@outVals) {
	print $_ . "\n";
}
#return @outvals;


