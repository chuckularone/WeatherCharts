#!/usr/bin/perl
use strict;
use warnings;
use DBI;

# Map input files to their respective table names
my $data_dir = '/scriptdir/weathercharts/data';

my %file_map = (
    "$data_dir/outpress.raw"  => 'pressure',
    "$data_dir/outtemp.raw"   => 'temperature',
    "$data_dir/outhumid.raw"  => 'humidity',
    "$data_dir/outspeed.raw"  => 'windspeed',
    "$data_dir/outgust.raw"   => 'gusts',
);

my $db_file = "/scriptdir/weathercharts/data/weather.sqlite";

# Connect to the SQLite database
my $dbh = DBI->connect(
    "dbi:SQLite:dbname=$db_file",
    "", "",
    {
        RaiseError       => 1,
        AutoCommit       => 0,   # We'll commit per-file for efficiency
        sqlite_unicode   => 1,
    }
) or die "Cannot connect to $db_file: $DBI::errstr\n";

for my $file (sort keys %file_map) {
    my $table = $file_map{$file};

    unless (-f $file) {
        warn "WARNING: File '$file' not found, skipping.\n";
        next;
    }

    open(my $fh, '<', $file) or do {
        warn "WARNING: Cannot open '$file': $!, skipping.\n";
        next;
    };

    my $sth = $dbh->prepare(
        "INSERT INTO $table (date, time, value, unit) VALUES (?, ?, ?, ?)"
    );

    my $line_num  = 0;
    my $inserted  = 0;
    my $skipped   = 0;

    while (my $line = <$fh>) {
        $line_num++;
        chomp $line;

        # Skip blank lines and the header row
        next if $line =~ /^\s*$/;
        next if $line =~ /^\s*date\s*,/i;

        # Split on comma, trim whitespace from each field
        my @fields = map { s/^\s+|\s+$//gr } split(/,/, $line);

        if (@fields != 4) {
            warn "WARNING: $file line $line_num: expected 4 fields, got "
                 . scalar(@fields) . " — skipping: '$line'\n";
            $skipped++;
            next;
        }

        my ($date, $time, $value, $unit) = @fields;

        # Basic validation
        unless ($date =~ /^\d{4}-\d{2}-\d{2}$/) {
            warn "WARNING: $file line $line_num: bad date '$date' — skipping.\n";
            $skipped++;
            next;
        }
        unless ($time =~ /^\d{2}:\d{2}:\d{2}$/) {
            warn "WARNING: $file line $line_num: bad time '$time' — skipping.\n";
            $skipped++;
            next;
        }
        unless ($value =~ /^-?\d+(\.\d+)?$/) {
            warn "WARNING: $file line $line_num: bad value '$value' — skipping.\n";
            $skipped++;
            next;
        }

        $sth->execute($date, $time, $value, $unit);
        $inserted++;
    }

    close($fh);
    $dbh->commit;

    printf "%-15s -> %-12s : %4d inserted, %d skipped\n",
           $file, $table, $inserted, $skipped;
}

$dbh->disconnect;
print "\nDone. Database: $db_file\n";

