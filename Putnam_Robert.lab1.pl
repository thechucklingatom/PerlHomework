######################################### 	
#    CSCI 305 - Programming Lab #1		
#										
#  Robert.Putnam			
#  thechucklingatom@gmail.com			
#										
#########################################

# Replace the string value of the following variable with your names.
my $name = "Robert Putnam";
my $partner = Null;
print "CSCI 305 Lab 1 submitted by $name and $partner.\n\n";

# Checks for the argument, fail if none given
if($#ARGV != 0) {
    print STDERR "You must specify the file name as the argument.\n";
    exit 4;
}

# Opens the file and assign it to handle INFILE
open(INFILE, $ARGV[0]) or die "Cannot open $ARGV[0]: $!.\n";


# YOUR VARIABLE DEFINITIONS HERE...
my %myHash = {};
my @questionArr = ("happy", "sad", "computer", "the");

# This loops through each line of the file
while($line = <INFILE>) {
	
	# This strips each line. by the conditions you gave. I find 52,759
	# So I am happy I waited until after weds class to turn this in because
	# you complained about my use of stack overflow.
	# I believe the one you pulled up was my english checking one. I already
	# had an expression that was working for some of it using /^w/ or something
	# like that, but it was not doing exactly what I wanted. I ended up posting 
	# out of frustration asking why my [^a-zA-Z0-9_' ]*$ wasn't matching what
	# I was going for. I was looking at it and researching for around 15 minutes before
	# I decided to go back to the hashing part after posting the question.
	# It turns out that I had put the ^ inside the brackets which is negation instead of
	# in front like what I wanted. I usually avoid Stack overflow but since we are trying
	# new things I figured I would try it. I did not email you about it because of this sentance
	# in the lab "You are encouraged to use any web
	# tutorials and resources to learn Perl. Given the size of the class, I will not be able to debug your
    # code for you. Please do not send panicked emails requesting I fix your bug for you. Allow yourself
    # plenty of time, and use patience, perseverance, and the internet to debug your code."
	# I didn't see anything wrong with forums especially since I wasn't just asking for the solution,
	# I had already built most of the regex but I was blanking on why something did not work the way
	# I thought it would. You mention you cannot post production code in a work environment but I 
	# disagree, for this you wouldn't have known if I had posted foo<SEP>bar (foo) [foo] or a non-english
	# bar. In my working experience if you are working alone and having issues debugging forums are a great
	# place to talk with someone about your problems. Granted I have not had many jobs I have had to program
	# but the two I did it wouldn't have mattered. If you would like to discuss this, or anything else, further
	# email me and I would be happy to find the time to do so.
	$line =~ s/.*>|([([\/\_\-:"`+=*].*)|(feat.*)|[?¿!¡\.;&\$@%#\\|]//g;
	#this if checks if it is English, and if it is inserts into the hash.
	if($line =~ m/^[a-zA-Z0-9_' ]*$/g){
		#set the line to lowercase
		$line = lc($line);
		#splits it on whitespace
		@words = split(' ', $line);
		#walks through the array and inserts the words
		for (my $i = 0; $i < @words - 1; $i++){
			#checks if it is already there
			if(exists $myHash{$words[$i]}){
				#check the following word is alread a value
				if(exists $myHash{$words[$1]}{$words[$i+1]}){
					#if it is increment the frequency
					$myHash{$words[$i]}{$words[$i+1]}++;
				}else{
					#otherwise insert it
					$myHash{$words[$i]}{$words[$i+1]} = 1;
				}
			}else{
				#if the first word doesnt exist add it
				$myHash{$words[$i]}{$words[$i+1]} = 1;
			}
			
		}
	}
}

# Close the file handle
close INFILE; 

# At this point (hopefully) you will have finished processing the song 
# title file and have populated your data structure of bigram counts.
print "File parsed. Bigram model built.\n\n";
MCWFreq(@questionArr);
#I did a lot of debugging using this next line.
#use Data::Dumper;

# User control loop
print "Enter a word [Enter 'q' to quit]: ";
$input = <STDIN>;
chomp($input);
print "\n";	
while ($input ne "q"){
	@songTitle = ();
	$songTitle[0] = $input;
	for (my $iter = 0; $iter < 19; $iter++){
		#calls the most common word function
		$songTitle[$iter+1] = MCW($songTitle[$iter]);
		#check if there is already this word earlier in the string
		for (my $jter = 0; $jter <= $iter; $jter++){
			#if there is a match end the loop and delete the last word
			if($songTitle[$jter] eq $songTitle[$iter+1]){
				$songTitle[$iter+1] = "";
				$iter = 20;
				$jter = 21;
			}
		}
	}
	for(my $iter = 0; $iter < @songTitle; $iter++){
		print "$songTitle[$iter] ";
	}
	print "\nEnter a word [Enter 'q' to quit]: ";
	$input = <STDIN>;
	chomp($input);
}

#or in every other language this is a function
sub MCWFreq{
	#this loop runs through each argument MCW is passed
	#it can take arrays as arguments and compute for each
	#word in the array
	for(my $iter = 0; $iter < @_; $iter++){
		#start with my temp value declaration
		#temp val starts at 0 for initial value compare
		$tempVal = 0;
		$tempKey;
		#check if it exists in the hash, keeps it from breaking
		if(exists $myHash{@_[$iter]}){
			#if it exists strip the keys and values associated with it
			my @v = values $myHash{@_[$iter]};
			my @k = keys $myHash{@_[$iter]};
			#find which word has the highest frequency by comparing values
			for (my $i = 0; $i < @v; $i++){
				#if the value is bigger, it is more common, so set it as such
				if($v[$i] > $tempVal){
					$tempVal = $v[$i];
					$tempKey = $k[$i];
				#if equal randomly decide
				}elsif($v[$i] == $tempVal){
					if(rand(1)){
						$tempVal = $v[$i];
						$tempKey = $k[$i];
					}
				}
			}
			#The print didnt want to work correctly so I just made a scalar and printed that
			$arrLength = @k;
			#prints the word entered, the most common and its frequency, then states how many unique words
			print "The most common word that follows $\@_[$iter] is $tempKey which shows up $tempVal times.\n";
			print "There are a total of $arrLength unique words.\n";
		}else{
			#if here the word entered doesnt exist in the hash
			print "$\@_[$iter] does not exist in this data set.\n";
		}
	}
}
sub MCW{
	#this loop runs through each argument MCW is passed
	#it can take arrays as arguments and compute for each
	#word in the array
	for(my $iter = 0; $iter < @_; $iter++){
		#start with my temp value declaration
		#temp val starts at 0 for initial value compare
		$tempVal = 0;
		$tempKey;
		#check if it exists in the hash, keeps it from breaking
		if(exists $myHash{@_[$iter]}){
			#if it exists strip the keys and values associated with it
			my @v = values $myHash{@_[$iter]};
			my @k = keys $myHash{@_[$iter]};
			#find which word has the highest frequency by comparing values
			for (my $i = 0; $i < @v; $i++){
				#if the value is bigger, it is more common, so set it as such
				if($v[$i] > $tempVal){
					$tempVal = $v[$i];
					$tempKey = $k[$i];
				#if equal randomly decide
				}elsif($v[$i] == $tempVal){
					if(rand(1)){
						$tempVal = $v[$i];
						$tempKey = $k[$i];
					}
				}
			}
			return $tempKey;
		}else{
			#if here the word entered doesnt exist in the hash
			return "";
		}
	}
}