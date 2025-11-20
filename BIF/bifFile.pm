package bifFile;
use strict;
use Exporter qw(import);

our $VERSION     = 0.01;
our @ISA         = qw(Exporter);
our @EXPORT_OK   = qw( slurp slurpUndef logWrite nowTime);

sub slurp {
	my @myIn     = @_;
	my $fileName = shift;
    open (my $fh, '<', $fileName)||die "Failed to open $fileName for read: $!\n";
	my @lines = <$fh>;	    
    return <@lines>;
    # $fh goes out of scope, file closed automatically
}
sub slurpUndef {
	my @myIn     = @_;
	my $fileName = shift;
    open (my $fh, '<', $fileName)||die "Failed to open $fileName for read: $!\n";
    local $/ = undef;
    return <$fh>;
    # $fh goes out of scope, file closed automatically
}
sub logWrite {
	my @myIn     = @_;
	my $fileName = shift;
	my $logValue = shift;
	my $whoDunIt = shift;
	my @dtData   = nowTime();
    open (my $fh, '>>', $fileName)||die "Failed to open $fileName for write: $!\n";
    print $fh "$dtData[0] $dtData[1] - $whoDunIt $logValue\n";
    print $fh "- - - - - - - - - - - - - - - - - - - - - - - -\n";
    close $fh;
}
sub nowTime {
	# Get the current time and format the hour, minutes and seconds.  Add    #
	# 1900 to the year to get the full 4 digit year.                         #
	(my $sec, my $min, my $hour, my $mday, my $mon,my $year) = (localtime(time))[0,1,2,3,4,5];
	my $time = sprintf("%02d%02d%02d",$hour,$min,$sec);
	$year += 1900;
	my $date = sprintf("%04d%02d%02d",$year,$mon+1,$mday); 
    my @dtg=($date, $time);
    return @dtg;
}
    
    
1;
