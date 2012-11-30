
use strict;
use warnings;

package Dicty::Protein::MolWt;

use Bio::SeqIO;
use Bio::Tools::SeqStats;
use Moose;
use MooseX::Attribute::Dependent;

with 'MooseX::Getopt';

has 'input' => (
    is            => 'rw',
    isa           => 'Str',
    required      => 1,
    documentation => 'Input FastA file'
);

has 'output' => (
    is            => 'rw',
    isa           => 'Str',
    default       => '',
    documentation => 'Output stream',
    lazy          => 1
);

sub run {
    my ($self) = @_;
    my $FH;
    if ( $self->output ) {
        $FH = IO::File->new( $self->output, 'w' );
    }

    my $fasta = Bio::SeqIO->new(
        -file   => $self->input,
        -format => 'Fasta'
    );

    while ( my $seq = $fasta->next_seq() ) {
        my $mw   = Bio::Tools::SeqStats->get_mol_wt($seq);
        my $avg  = ( $$mw[1] + $$mw[0] ) / 2;
        my $data = $seq->id . "\t" . $avg;
        if ($FH) {
            $FH->write( $data . "\n" );
        }
        print $data. "\n";
    }
}

1;

package main;
Dicty::Protein::MolWt->new_with_options->run;
1;

__END__

=head1 DESCRIPTION

Script to calculate molecular weight of protein residues using C<Bio::Tools::SeqStats>.

=head1 SYNOPSIS
	
	perl lib/pMolWt --input dicty.fasta

	perl lib/pMolWt --input dicty.fasta --output mol-wt.txt

=over
