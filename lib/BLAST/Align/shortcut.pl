
package BLAST::Align::Shortcut;

=head1

=cut

use strict;
use warnings;
use Getopt::Long;

use Bio::GFF3::LowLevel::Parser;
use IO::File;

my ( $help, $gff3_file, $out_file );
my $intron_count = 0;

usage()
    if (
    @ARGV < 1
    or !GetOptions(
        'i=s' => \$gff3_file,
        'o=s' => \$out_file
    )
    or defined $help
    );

sub usage {
    print STDERR "Usage:\tperl shortcut.pl -i <gff3-file> -o <output-file>\n";
    exit;
}

my $fh;
if ( $out_file ne "" ) {
    $fh = IO::File->new( $out_file, 'w' );
}
else {
    $fh = \*STDOUT;
}

my $p = Bio::GFF3::LowLevel::Parser->open( IO::File->new( $gff3_file, 'r' ) );

while ( my $i = $p->next_item ) {

    if ( ref $i eq 'ARRAY' ) {
        for my $f (@$i) {
            _check($f);
        }
    }
    elsif ( $i->{directive} ) {
        if ( $i->{directive} eq 'FASTA' ) {    # if FastA; at the end of file
            print STDERR "FastA sequence begins here";
        }
        elsif ( $i->{directive} eq 'gff-version' ) { # the GFF version comment
            print STDERR "GFF version $i->{value}\n";

            #_write_to_file($i->{value})
        }

        elsif ( $i->{directive} eq 'sequence-region' )
        {    # the sequence-region comment
            print STDERR (
                "#sequence-region, sequence $i->{seq_id},",
                " from $i->{start} to $i->{end}\n"
            );
        }
    }
    else {
        die "Serious problem with GFF !\n";
    }
}
print STDERR "\n# introns with issues: " . $intron_count . "\n";

sub _check {
    my ($features) = @_;
    my $children = $features->{'child_features'};
    for my $child (@$children) {
        my $c = @$child[0];
        if ( ( $c->{'end'} - $c->{'start'} ) > 2500 ) {
            $intron_count = $intron_count + 1;
            return;
        }
    }
    _write_to_file($features);
    return;

}

sub _write_to_file {
    my ($features) = @_;
    print $fh Bio::GFF3::LowLevel::gff3_format_feature($features);
    my $children = $features->{'child_features'};
    for my $child (@$children) {
        print $fh Bio::GFF3::LowLevel::gff3_format_feature( @$child[0] );
    }
    return;
}

1;
