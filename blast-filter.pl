#!~/.perl5/perlbrew/perls/perl-5.12.4/bin/perl
#===============================================================================
#
#         FILE: blast-filter.pl
#
#        USAGE: perl blast-filter.pl -i <blast-output-xml> -e <e-value> -o <output-file>
#
#  DESCRIPTION:
#
#      OPTIONS: ---
# REQUIREMENTS: Bio::SearchIO
#       AUTHOR: Yogesh Pandit
#      COMPANY: dictyBase.org
#      CREATED: 03/28/2012 15:58:07
#===============================================================================

use strict;
use Getopt::Long;
use Bio::SearchIO;

my ($help, $blastXML, $e_val, $outFile);

usage() if ( @ARGV < 1 or
          ! GetOptions ('i=s' => \$blastXML, 'e=s' => \$e_val, 'o=s' => \$outFile )
          or defined $help );

new_filter($blastXML, $e_val, $outFile);

=pod

=cut
sub usage {
	print STDERR "Usage:\tperl blast-filter.pl -i <blast-output-xml> -e <e-value> -o <output-file>\n";
	exit;
}

sub new_filter {
	my ($xml, $e, $outF) = @_;
	my $outfile = "";
	print STDERR "Input file - $xml\n";
	print STDERR "eValue threshold - $e\n";
	if ($outF ne "") {
		$outfile = IO::File->new ($outF, "w");
		print STDERR "Output file - ".$outfile."\n";
	}
	
	my $res = Bio::SearchIO->new (-format => 'blastxml', -file => $xml);
	while (my $result = $res->next_result) { # One query at a time
		if ($e ne "") {
			while (my $hit = $result->next_hit) { # Iterating 1-query -> All-targets
				if ($hit->significance <= $e) {
					my $out = $result->query_accession." | ".(split /\|/, $result->query_description)[2]." | ".$hit->accession." | ".$hit->significance."\n";
					if ($outF ne "") {
						$outfile->write((split /\|/, $result->query_description)[2]."\n");	
					} else {
						print STDOUT $out;
					}
					last;
				}
			}
		} else {
			print STDOUT (split /\|/, $result->query_description)[2]."\n";
		}
	}
	undef $outfile;
}



