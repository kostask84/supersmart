package Bio::SUPERSMART::App::smrtutils::Command::DBinsert;

use strict;
use warnings;

use Bio::Phylo::IO qw(parse unparse);
use Bio::Phylo::Util::CONSTANT ':objecttypes';

use base 'Bio::SUPERSMART::App::SubCommand';
use Bio::SUPERSMART::App::smrtutils qw(-command);

# ABSTRACT: 

=head1 NAME

DBinsert - insert custom sequences and taxa into database

=head1 SYNOPSYS


=head1 DESCRIPTION

=cut

sub options {    
	my ($self, $opt, $args) = @_;
	my $format_default = 'fasta';
	return (
		['alignment|a=s', "alignment file(s) to insert into database, multiple files should be separatet by commata", { arg => 'file' } ],
		['desc|d=s', "description for sequences", {}],
		['format|f=s', "format of input alignemnt files, default: $format_default", {}]
	    );	
}

sub validate {
	my ($self, $opt, $args) = @_;			
	$self->usage_error('no alignment argument given') if not $opt->alignment;
}

sub run {
	my ($self, $opt, $args) = @_;    
	
	my $logger = $self->logger;

	my $aln_str = $opt->alignment;

	# retrieve matrix object(s) from fil(s)
	my @files = split(',', $aln_str);       
	for my $file ( @files ) {
		$logger->info ("Processing alignment file $file");
		# create matrix object from file
		my $project = parse(
			'-format'     => $opt->format,
			'-type'       => 'dna',
			'-file'       => $file,
			'-as_project' => 1,
		    );
		my ($matrix) = @{ $project->get_items(_MATRIX_) };
		
		# iterate over sequences and insert into database
		for my $seq ( @{$matrix->get_entities} ) {
			print $seq->get_name . "  " . $seq->get_unaligned_char . "\n";
						
			my $id = $seq->get_name;
			if (! $id =~ m/^[0-9]+?/) {
				$logger->info("Descriptor of sequence $id does not look like taxon ID, trying to map id");
			}
			# gather fields required for 'seqs' table in phylota
			my $division = 'INV';
			my $acc_vers = 1;
			my $unaligned = $seq->get_unaligned_char;
			my $gbrel = '000';
			
			my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
			

		}
		

	}
	
	

}

1;