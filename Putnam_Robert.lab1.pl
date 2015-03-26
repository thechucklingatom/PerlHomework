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
