#!/usr/bin/perl
#
# ascii2pdf - create simple pdf file from simple text file.
# Uses the PDF::Create perl module.
# Version 0.9.1
# Released under the GNU GPL. 
# Copyright 2000 Michael Arndt
#
# 07/31/2009
# Changed regex for parens replacement from s/\)/\\)/g; -- $_=~s/\)/\)/g;  -CJM	
# 10/16/2009
# Added exporting of font size variable
# Added exporting of document title
# Added exporting of document author
# Updated error block -CJM
#
$pathToPdf = "/home/chuck/code/perllib/BIF/";
require $pathToPdf."options.pl";
use PDF::Create;
use Getopt::Required;

#use strict;

#
# vars
#
my ($prog,$output,$input,$pdf,$font,$orientation,$font_size,$root,$f1,$page);
my ($xbase,$ybase,$lmargin,$tmargin,$xpos,$ypos);
use vars qw($opt_l $opt_f $opt_p $opt_s $opt_t);


my($option) = new Getopt::Required;
if (! $option -> getOptions($options, "Usage: bifPdf.pl [options]") ) { exit(-1); }

@arrayParm = ("sfile", "tfile", "landscape", "font", "fontsize", "doctitle", "docauthor", "debug");
$debug = $option->{'switch'}{'debug'};
$input = $option->{'switch'}{'sfile'};
$output = $option->{'switch'}{'tfile'};
$landscape = $option->{'switch'}{'landscape'};
$fontname = $option->{'switch'}{'font'};
$font_size = $option->{'switch'}{'fontsize'};
$doctitle = $option->{'switch'}{'doctitle'};
$docauthor = $option->{'switch'}{'docauthor'};
#
# defaults
#
$orientation = "portrait";
$font = "Courier";
#$font_size = 10;
$lmargin = 10;
$tmargin = 30;
$prog = $0;
$prog =~ s,.*/,,g;

if ($fontname eq "h" || $fontname eq "H") {
	$font = "helvecita";
}

if ("$landscape" ) {
	$orientation = "landscape";
	$option->{'switch'}{'landscape'} = "landscape";
}else{
	$option->{'switch'}{'landscape'} = "portrait";
}

if (! $input) {
	print STDERR "\n$prog: no input file given\n\n";
	&help;
}
if ( ! -f "$input" ) {
	print STDERR "\n$prog: no such file: $input\n\n";
	&help;
}
if (! $output) {
	if ($input =~ /(.*?)\.txt/) {
		$output = $1 . ".pdf";
	} else {
		$output = $input . ".pdf";
	}
}

if ("$debug" ) {
	print "\n----------------------------\n";
		foreach $parm (@arrayParm) {
		   print "$parm:      ".$option->{'switch'}{$parm}."\n";
		   }
	print "----------------------------\n\n";
}


#
# translate file
#
&start();
$xpos = $lmargin;
$ypos = $ybase - $tmargin;
open(F, "<$input") or die "$prog: Could not open $input: $!\n";
while (<F>) {
	chomp;
	# ( or ) chars screw up the PDF encoding, we need to escape them
        $_=~s/\(/\(/g;
	$_=~s/\)/\)/g;
	#s/\(/\\(/g; - commented out and replaced above -CJM
	#s/\)/\\)/g; - commented out and replaced above -CJM
        if (/^NEWPAGE/) {
		&new_page;
		$ypos = $ybase - $tmargin;
		}
	if ($ypos <= $font_size) {
		&new_page;
		$ypos = $ybase - $tmargin;
		&print_string($_);
		$ypos = $ypos - $font_size;
	} elsif (/(.*?)\cL(.*)/) {
		&print_string($1) if ($1);
		&new_page;
		$ypos = $ybase - $tmargin;
		if ($2) {
			&print_string($2);
			$ypos = $ypos - $font_size;
		}	
	} else {
		&print_string($_);
		$ypos = $ypos - $font_size;
	}
}
close(F);
$pdf->close;

#
# subroutine to start the document
#
sub start {
	$pdf = new PDF::Create('filename'    => $output,
                           'Title'       => $doctitle,
                           'Author'      => $docauthor
                           ); 
	if ($orientation eq "portrait") {
		$root = $pdf->new_page('MediaBox' => [ 0, 0, 612, 792 ]);
		$xbase = 612;
		$ybase = 792;
	} else {
		$root = $pdf->new_page('MediaBox' => [ 0, 0, 792, 612 ]);
		$xbase = 792;
		$ybase = 612;
	}
	$f1 = $pdf->font('BaseFont' => $font);
	$page = $root->new_page;
	return 1;	
}

#
# subroutine to print a string in right spot on the page
# 
sub print_string {
	my ($string) = @_;
	$page->string($f1, $font_size, $xpos, $ypos, "$string");
	return 1;
}

#
# subroutine to start a new page
#
sub new_page {
	$page = $root->new_page;
	return 1;
}

#
# subroutine to print help page
#
sub help {
#	print "Help block";
 	print <<HELP;
Usage: $prog --sfile inputfile [options]
Where [options] are:
  --tfile	set only if the output name varies from the input name
  --landscape	set to 1 for landscape (default: portrait)
  --font	set to H for Helvetica (default: C for Courier)
  --fontsize	is the point size (default: 10)
  --doctitle	set the metadata "title"
  --docauthor	set the metadata "Author"
  --debug	set to 1 for debug info (default: off)
   
HELP
exit;
}

