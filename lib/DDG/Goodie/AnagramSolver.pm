package DDG::Goodie::AnagramSolver;
# ABSTRACT: Solves anagrams

use DDG::Goodie;

use constant DICT_FILE => '/usr/share/dict/words';
 
my %dict;
sub create_dict {
    open my $fh, '<', DICT_FILE
        or return;
    while(<$fh>)
    {
        chomp;
        my $word_index = join('', sort(split //, $_)); 
        if (exists $dict{$word_index})
        {
            push @{$dict{$word_index}}, $_;
        } else
        {
            my @word_list;
            push @word_list, $_;
            $dict{$word_index} = \@word_list;
        }
    }
    close $fh;

    # remove trivial cases
    foreach my $key (keys %dict) {
	delete $dict{$key} if (@{$dict{$key}} == 1);
    }
};

triggers start => 'solve';

handle remainder => sub {
    print "$_\n";
    my $key = join('', sort(split //, $_)); 
    print "$key\n";

    create_dict;
    
    return @{$dict{$key}} if exists $dict{$key};
    return;
    
};

zci is_cached => 1;

1;
