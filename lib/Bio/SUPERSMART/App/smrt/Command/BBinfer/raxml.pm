package Bio::SUPERSMART::App::smrt::Command::BBinfer::raxml;
use strict;
use warnings;
use File::Spec;
use Bio::Tools::Run::Phylo::Raxml;
use base 'Bio::SUPERSMART::App::smrt::Command::BBinfer';

sub _create {
    my $self = shift;
    my $config = $self->config;
    my $tool = Bio::Tools::Run::Phylo::Raxml->new;
    
    # configure raxml runner
    $tool->outfile_name("out");             
    $tool->w( $tool->tempdir );
    return $tool;
}

sub _configure {
    my ( $self, $tool, $config ) = @_;
    $tool->m($config->RAXML_MODEL);
    $tool->N($config->RAXML_RUNS);
    $tool->p($config->RANDOM_SEED);
    $tool->T($config->NODES);
}

sub _run {
    my ( $self, %args ) = @_;
    my $t      = $args{'tool'};
    my $logger = $self->logger;
    
    # create output file name
    my $treefile = File::Spec->catfile( $t->w, 'RAxML_bestTree.' . $t->outfile_name );

    # configure bootstrap options   
    if ( $args{'boot'} ) {
        
        # set rapid bootstrap analysis
        $t->f('a');     
        
        # bootstrap random seed 
        $t->x($self->config->RANDOM_SEED);            
        $treefile = File::Spec->catfile( $t->w, 'RAxML_bipartitions.' . $t->outfile_name );     
    }   

    # run raxml, returns bioperl tree
    my $bptree = $t->run($args{'matrix'});          
    $logger->fatal('RAxML inference failed; outfile not present') if not -e $treefile; 
    return $treefile;
}

1;