#!/usr/bin/perl 
#===============================================================================
#
#         FILE: get_fasta.pl
#
#        USAGE: ./get_fasta.pl
#
#  DESCRIPTION:
#
# REQUIREMENTS: Bio::Index::Fasta
#      CREATED: 05/04/2012 11:09:15
#===============================================================================

use strict;
use Pod::Usage;
use Getopt::Long;
use Bio::Index::Fasta;

my ($fasta_file, $id_list );

GetOptions(
    'id|id-list=s' => \$id_list,
    'fa|fasta=s'   => \$fasta_file,
    'h|help'       => sub { pod2usage() }
);
pod2usage() if !$id_list;
pod2usage() if !$fasta_file;

build_index($fasta_file);
get_fasta($id_list);

sub build_index {
    my ($fasta_file) = @_;
    my $inx = Bio::Index::Fasta->new(
        -filename   => "fasta.idx",
        -write_flag => 1
    );

    #$inx->id_parser(\&get_id);
    $inx->make_index($fasta_file);
}

sub get_id {
    my $header = shift;

    #$id =~ /^>.*\bsp\|([A-Z]\d{5}\b)/;
    $header =~ /(DDB\d{1,10})/;
    print $1. "\n";
}

sub get_fasta {
    my ($id_list) = @_;
    my $ids = IO::File->new();
    $ids->open( $id_list, "r" );
    my $inx = Bio::Index::Fasta->new("fasta.idx");

    #print STDOUT $inx->fetch('DDB0267068');
    foreach my $id (<$ids>) {
        my $seq = $inx->fetch( chomp($id) );    # Returns Bio::Seq object
        print $id. "\n" . $seq . "\n\n";
    }
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

