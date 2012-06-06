package DDG::Goodie::AnagramSolver;
use Algorithm::Permute;

# ABSTRACT: Solves anagrams

use DDG::Goodie;

#use constant DICT_FILE => '/usr/share/dict/words';
use constant DICT_FILE => 'american_80.txt';

 
my %dict;
sub create_dict {
    open my $fh, '<', DICT_FILE
        or return;
    while(<$fh>)
    {
        chomp;
	if ($_ !~ /\w/)
	{
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
	    print "$_\n";
	}
    }
	close $fh;

    # remove trivial cases
    foreach my $key (keys %dict) {
	delete $dict{$key} if (@{$dict{$key}} == 1);
    }
};

# recursive funtion
# takes keys as param
# returns list of anagrams for key
sub search_dict {
    my $key = $_[0];
    my $k = length $key;
    my @matched;
 
    if ($k > 1)
    {
	push @matched, search_dict(substr $key, 0, $k-1)
    }

    my $p = new Algorithm::Permute([split '', $key]);
    while (my @res = $p->next) {
	print join('', @res), "\n";
    }
    
   
    print "\n";

    #print "$key\n";
}

triggers start => 'solve';

handle remainder => sub {
    #print "$_\n";
    my $key = join('', sort(split //, $_)); 
    #print "$key\n";
    search_dict($_);
    create_dict;
    my @ret_vals; 

    #return @{$dict{$key}} if exists $dict{$key};
    my $k = length $key;
    while ($k > 0)
    {
        my $new_str = (substr $key, 0, $k-1) . (substr $key, $k);
       
        push @ret_vals, @{$dict{$new_str}} if exists $dict{$new_str};
        --$k;
       
        #print "$new_str\n";
    }

    #print (@ret_vals);
    return @ret_vals if (@ret_vals);
    return;
    
};

zci is_cached => 1;

1;
