#!~/.perl5/perlbrew/perls/perl-5.12.4/bin/perl
#===============================================================================
#
#         FILE: blast-filter.pl
#
#        USAGE: perl blast-filter.pl -i <blast-output-xml> -e "[>|=|<]<e-value>" -o <output-file>
#
#  DESCRIPTION:
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Yogesh Pandit,
#      COMPANY:
#      VERSION: 1.0
#      CREATED: 03/28/2012 15:58:07
#     REVISION: ---
#===============================================================================

use strict;
#use warnings;
use Getopt::Long;
use Bio::SearchIO;

my ($help, $blastXML, $e_val, $outFile);

usage() if ( @ARGV < 1 or
          ! GetOptions ('i=s' => \$blastXML, 'e=s' => \$e_val, 'o=s' => \$outFile )
          or defined $help );

if ($e_val != m/^[<>=]/) {
	print STDERR "Incorrect e-Value. Either you forgot the operator [<>=] or \"\"\n\n";
	usage();
} else {
	filter(\$blastXML, \$e_val, $outFile);
}

=pod

=cut
sub usage {
	print STDERR "Usage:\tperl blast-filter.pl -i <blast-output-xml> -e \"[>|=|<]<e-value>\" -o <output-file>\n";
	print STDERR "ex: perl blast-filter.pl -i blast-out.xml -e \"<3.14e-12\" -o query-ids.txt\n";
	exit;
}

=pod

=cut
sub filter {
	my $xml = shift;
	my $eV = shift;
	my $outF = shift;
	my $e = 0;
	my $sigV = "";
	my $acc = "";
	$outFile = "";

	print STDERR "Input file - ".$$xml."\n";
	if ($$eV) {
		($e = $$eV) =~ s/^[<>=]//;
	}
	print STDERR "Threshold e-Value = ".$e."\n";

	if ($outF ne "") {
		$outFile = IO::File->new ($outF, "w");
		print STDERR "Output file - ".$outF."\n";
	}

	my $res = Bio::SearchIO->new (-format => 'blastxml', -file => $$xml);

	# One query at a time
	while (my $result = $res->next_result) {
		my $match = 0;

		if ($$eV ne "") {

			# Iterating 1-query -> All-targets
			while (my $hit = $result->next_hit) {

				# Variables for use outside the loop
				$sigV = $hit->significance;
				$acc = $hit->accession;

				if ($sigV != 0) {
					if ($$eV =~ m/^</) {
						if ($e > $sigV) {
							$match = 1;
							last;
						}
					} elsif ($$eV =~ m/^>/) {
						if ($e < $sigV) {
							$match = 1;
							last;
						}
					} elsif ($$eV =~ m/^=/) {
						if ($e == $hit->significance) {
							$match = 1;
							last;
						}
					}
				}
			}
			if ($match == 1) {
				my $res = $result->query_accession." | ".$acc." | ".$sigV."\n";
				if ($outF ne "") {
					$outFile->write($res); # Write to file
				} else {
					print STDOUT $res; # Write to STDOUT
				}
			}
		} else {
			my $res = $result->query_accession."\n";
			if ($outF ne "") {
				$outFile->write($res); # Write to file
			} else {
				print STDOUT $res; # Write to STDOUT
			}
		}
	}
	undef $outFile;
}


