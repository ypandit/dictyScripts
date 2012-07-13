
package BLAST::Align;

=head1

=cut

use strict;
use warnings;
use Moose;
use Getopt::Long;

use Bio::GFF3

    my ($gff3_file);

usage()
    if ( @ARGV < 1
    or !GetOptions( 'i=s' => \$gff3_file ) );

1;
