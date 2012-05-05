#!/usr/bin/perl 

use strict;
use Pod::Usage;
use Getopt::Long;
use Bio::DB::Fasta;

my ( $fasta_file, $id_list );

GetOptions(
    'id|id-list=s' => \$id_list,
    'fa|fasta=s'   => \$fasta_file,
    'h|help'       => sub { pod2usage() }
);
pod2usage() if !$id_list;
pod2usage() if !$fasta_file;

my $db = build_index($fasta_file);
write_fasta( $db, $id_list );

sub build_index {
    my ($fasta_file) = @_;
    my $inx = Bio::DB::Fasta->new(
        $fasta_file,
        -makeid => sub {
            my ($id) = @_;
            retrun $1 if $id =~ /^>(DDB\d{1, 10})\|\S+$/;
        }
    );
    return $inx;
}

sub get_fasta {
    my ( $db, $id_list ) = @_;
    my $file = IO::File->new( $id_list, 'r' ) or die "cannot open file:$!";
    while ( my $line = $file->getline ) {
        chomp $line;
        my $seq = $db->get_Seq_by_id( $line );
        # Returns Bio::Seq object
        # Read the bioperl doc to figure out how to write it to a file
    }
    $file->close;
}

=head1 NAME

B<get_fasta.pl> - [One line description of application purpose]


=head1 SYNOPSIS

perl get_fasta.pl -id idlist.txt -fa dicty.fasta

=head1 REQUIRED ARGUMENTS

B<[-id|--id-list]> - [Write something here]

B<[-id|--id-list]> - [Write something here]

=head1 OPTIONS

B<[-h|-help]> - display this documentation.

