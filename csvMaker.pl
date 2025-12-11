#!/usr/bin/perl
use strict;
use warnings;

use POSIX qw(strftime);

# Usage: dump_table.pl /path/to/sqlite3 /path/to/db table_name output.csv

if (@ARGV != 4) {
    die "Usage: $0 /path/to/sqlite3 /path/to/db table_name output.csv\n";
}

my ($sql, $db, $table, $outfile) = @ARGV;

$table =~ /\A[A-Za-z_][A-Za-z0-9_]*\z/
    or die "Suspicious table name '$table'\n";

open my $outfh, '>', $outfile
    or die "Cannot open '$outfile' for writing: $!\n";

# Run sqlite3 with CSV output (header included)
open my $sqlfh, "-|", $sql, $db, "-header", "-csv", "SELECT * FROM $table;"
    or die "Failed to run sqlite3: $!\n";

# Read header
my $header = <$sqlfh>;
chomp $header;

# Split header fields
my @fields = split /,/, $header;

# Identify "Time" columns
my %time_columns;
for my $i (0 .. $#fields) {
    if ($fields[$i] =~ /time/i) {
        $time_columns{$i} = 1;
    }
    if ($fields[$i] =~ /last/i) {
        $time_columns{$i} = 1;
    }
}

# Write header as-is
print {$outfh} $header . "\n";

# Process each row
while (my $line = <$sqlfh>) {
    chomp $line;

    # Split CSV — SQLite's CSV is simple and safe to split this way
    my @cols = split /,/, $line, -1;

    ##Temporary Debugging Code
    #for my $i (sort { $a <=> $b } keys %time_columns) {
    #    warn "DEBUG: $fields[$i] => '$cols[$i]'\n";
    #}


    # Process time columns
    for my $i (keys %time_columns) {
        my $val = $cols[$i];

        if (!defined $val || $val eq "") {
            next;  # empty field stays empty
        }
        elsif ($val eq "0") {
            $cols[$i] = "";  # special case: epoch 0 becomes blank
        }
        elsif ($val =~ /^\d+$/) {
            # Convert Unix epoch → formatted timestamp
            my $formatted = strftime("%Y%m%d-%H:%M:%S", localtime($val));
            $cols[$i] = $formatted;
        }
        # Else: leave non-numeric as-is
    }

    # Reassemble and output CSV
    my $out = join(",", @cols);
    print {$outfh} $out . "\n";
}

close $outfh;
close $sqlfh or die "sqlite3 command failed (exit code " . ($? >> 8) . ")";
