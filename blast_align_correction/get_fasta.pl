#!/usr/bin/perl

=head1 NAME

B<get_fasta.pl> - Get a FastA file for a subset of IDs from a index Fasta

=head1 SYNOPSIS

perl get_fasta.pl -id idlist.txt -fa dicty.fasta

=head1 REQUIRED ARGUMENTS

B<[-id|--id-list]> - List of IDs to search for in the indexed database

B<[-fa|--fasta]> - Fasta file to be indexed

=head1 OPTIONAL ARGUMENTS

B<[-o|--output]> - Output FastA file. default=STDOUT

=head1 OPTIONS

B<[-h|-help]> - display this documentation.

=cut

use strict;
use Pod::Usage;
use Getopt::Long;
use Bio::DB::Fasta;
use Bio::SeqIO;

my ( $fasta_file, $id_list, $out_file );

GetOptions(
    'id|id-list=s'     => \$id_list,
    'fa|fasta=s'       => \$fasta_file,
    '-o|output-file=s' => \$out_file,
    'h|help'           => sub { pod2usage() }
);
pod2usage() if !$id_list;
pod2usage() if !$fasta_file;

my $seqout;
if ( $out_file ne "" ) {
    $seqout = Bio::SeqIO->new( -file => ">$out_file", -format => 'fasta' );
}
else {
    $seqout = Bio::SeqIO->new( -fh => \*STDOUT, -format => 'fasta' );
}
my $db = build_index($fasta_file);
write_fasta( $db, $id_list, $seqout );

sub build_index {
    my ($fasta_file) = @_;
    my $db = Bio::DB::Fasta->new(
        $fasta_file,
        -reindex => 1,
        -makeid  => sub {
            my ($ID) = @_;
            $ID =~ /^>(DDB\d{1,10})\|.*$/;
            $1;
        }
    );
    return $db;
}

sub write_fasta {
    my ( $db, $id_list, $seqout ) = @_;
    my $f = IO::File->new( $id_list, 'r' ) or die "Cannot open file: $!";
    while ( my $line = $f->getline ) {
        chomp($line);
        my $seqobj = $db->get_Seq_by_id($line);

        #print $line."\n".$seqobj->seq."\n\n";
        my $seq = Bio::Seq->new( -id => $line, -seq => $seqobj->seq );
        $seqout->write_seq($seq);
    }
    $f->close;
}

