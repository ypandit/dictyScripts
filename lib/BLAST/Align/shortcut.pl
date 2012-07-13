
package BLAST::Align::shortcut;

=head1

=cut

use strict;
use Getopt::Long;
use Bio::GFF3::LowLevel::Parser;
use IO::File;

my ( $help, $gff3_file );

usage()
    if ( @ARGV < 1
    or !GetOptions( 'i=s' => \$gff3_file )
    or defined $help );

sub usage {
    print STDERR "Usage:\tperl shortcut.pl -i <gff3-file>\n";
    exit;
}
print STDERR "Reading from file: $gff3_file\n";

my $p = Bio::GFF3::LowLevel::Parser->open( IO::File->new( $gff3_file, 'r' ) );

while ( my $i = $p->next_item ) {

    if ( ref $i eq 'ARRAY' ) {
        for my $f (@$i) {
            my $attributes = $f->{'attributes'};
			#print ref($attributes) . "\n";
        	print STDOUT $attributes->{'ID'}[0]."\n";
        }
    }
    elsif ( $i->{directive} ) {
        if ( $i->{directive} eq 'FASTA' ) {    # if FastA; at the end of file
            print STDERR "FastA sequence begins here";
        }
        elsif ( $i->{directive} eq 'gff-version' ) {
            print STDERR "GFF version $i->{value}\n";
        }
        elsif ( $i->{directive} eq 'sequence-region' ) {
            print(
                "#sequence-region, sequence $i->{seq_id},",
                " from $i->{start} to $i->{end}\n"
            );
        }
    }
    elsif ( $i->{comment} ) {    # Comment in GFF3
        print STDERR "Comment: '$i->{comment}'\n";
    }
    else {
        die 'Serious problem with GFF !';
    }
}

1;
