#!/bin/bash

picture=(
"






"
"





_________
"
"

 |   
 |     
 |     
 |     
_|_______
"
"
 _______ 
 |    
 |     
 |     
 |     
_|_______
"
"
 _______ 
 |/    
 |     
 |    
 |     
_|_______
"
"
 _______ 
 |/    |
 |     O
 |     
 |     
_|_______
"
"
 _______ 
 |/    |
 |     O
 |     |
 |     
_|_______
"
"
 _______ 
 |/    |
 |     O
 |    -|- 
 |     
_|_______
"
"
 _______ 
 |/    |
 |     O
 |    -|- 
 |    /
_|_______
"
"
 _______ 
 |/    |
 |     O
 |    -|- 
 |    /|
_|_______
"
)
function checkSuccess() {
	if ! echo -n $word | tr -c $correctletters - | grep -q -
	then
		clear
		echo "The word was: $word. You guessed it with $(( 9-$incorrectguesses )) guesses remaining"
		echo "YOU WIN! come again soon..."
		exit
	fi
}

### BEGIN GAME LOGIC ###

clear
echo "Would you like to choose your word or have a random one chosen for you?  "
read -p "Type r for random or any other key to choose: " randchoice
if [ $randchoice == "r" ]
then
	num=$(shuf -i 1-$(cat words.txt | wc -l) -n 1)
	word=$(sed -n "$num"p words.txt)
	extra=${word:(-1)}
	word=${word//$extra}
else
	clear
	read -sp "Game Master enter a word: " word 
fi
word=$(echo $word | tr [:upper:] [:lower:])
echo





#Give nine incorrect guesses
incorrectguesses=0
correctletters="."
incorrectletters="."
while [ $incorrectguesses -lt 9 ]
do
	clear
	echo --------------------------------------
	echo -e "HANGMAN\n"
	
	#Display current state of game: word with correct letters,
	#list of incorrect letters, and picture.
	echo Word:
	echo -n $word | tr -c "$correctletters" "-"
	echo 
	#Display picture using number of incorrectguesses
	#zero should be a blank picture. 
	echo "${picture[$incorrectguesses]}"
	echo "Incorrect guesses remaining: $(( 9-$incorrectguesses ))"
	echo "Incorrect guesses: "
	echo ${incorrectletters[@]}
	
	#Check for a win after displaying main content
	checkSuccess
	
	#Take entry and validate it
	while true; do
		read -p "Please guess a letter (qu to quit): " letter
		letter=$(echo $letter | tr [:upper:] [:lower:])
		
		length=$(echo -n $letter | wc -m )
		if [ $letter == "qu" ];then
			exit
		elif [ $length -ne 1 ];then 
			echo "Let's not go crazy... One letter at a time please. "
			continue
		elif ! [[ $letter =~ [A-z]+$ ]]; then
			echo "I believe i said letter, not number..."
			continue
		elif echo $correctletters | grep -q $letter || echo $incorrectletters | grep -q $letter 
		then
			echo "Letter already guessed!"
			continue
		else
			break
		fi
	done 
 
	#Check if entry is correct and perform logic accordingly
	if echo $word | grep -q $letter
	then
		correctletters="${correctletters}$letter"
	else
		incorrectletters="${incorrectletters}$letter "
		(( incorrectguesses++ ))
	fi
	
done
clear
echo "GAME OVER MAN, GAME OVER"
echo -n "The word was $word"
echo
echo "${picture[incorrectguesses]}"

exit

