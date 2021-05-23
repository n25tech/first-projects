#include <iostream>
#include <fstream>
#include <vector>
#include <algorithm>

using namespace std;

vector<string> get_wordlist()
{
    string movieItem;
    vector<string> words;
    ifstream MovieListFile("movies_list.txt");
    while(getline(MovieListFile, movieItem))
    {
	words.push_back(movieItem);
    }
    MovieListFile.close();
    return words;
}

string get_word()
{
	vector<string> wordlist;
	wordlist = get_wordlist();
	//vector<string>::const_iterator iter;
	//for (iter = wordlist.begin(); iter != wordlist.end(); iter++)
	//	cout << *iter << endl;
	srand(time(0));
	random_shuffle(wordlist.begin(), wordlist.end());
	string word_to_guess = wordlist[0];
	//for (int i=0; i < word_to_guess.size(); i++)
	//{
	//	if (isspace(word_to_guess[i]))
	//	{
	//		word_to_guess.replace(i, 1, "/");
	//	}
	//}
	//cout << word_to_guess << endl;
	//cout << word_to_guess.size() << endl;
	return word_to_guess;
}

string initial_guessed_word(string word_to_guess)
{
	string guessed_word;
	for (int i=0; i < word_to_guess.size(); i++)
	{
		char mychar = word_to_guess[i];
		if (isspace(mychar))
		{
			guessed_word.append("/");
		} else if (isalpha(mychar)) {
			guessed_word.append("_");
		}
		else {
			guessed_word.push_back(mychar);
		}
	}
	return guessed_word;
}

bool game()
{
	// get target word to guess
	const string word_to_guess = get_word();
	// setup word that will contain guessed letters
	string guessed_word;
	guessed_word = initial_guessed_word(word_to_guess);
	int no_of_chances = 7;
	int no_of_guesses = 0;
	string guessed_letters;
	char letter;
	bool game_over = false;
	bool won = false;
	while (game_over != true)
	{
		if (no_of_chances == 0)
		{
			game_over = true;
			won = false;
			break;
		} else if (guessed_word.find("_")==string::npos)
		{
			game_over = true;
			won = true;
			break;
		}
		cout << "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" << endl;
		cout << guessed_word << endl;
		cout << "chances remaining: " << no_of_chances << endl;
		cout << "guesses used: " << no_of_guesses << endl; 
		//cout << "guessed_letters: " << endl;
		cout << "Enter a letter to guess:" ;
		cin >> letter;
		no_of_guesses++;

		// check if letter is present:
		bool letter_present = false;
		for (int i=0; i < guessed_word.size(); i++)
		{
			if (word_to_guess[i] == tolower(letter) || word_to_guess[i] == toupper(letter))
			{
				guessed_word[i] = word_to_guess[i];
				letter_present = true;
			}
		}
		if (letter_present == false)
		{
			no_of_chances--;
		}
	}
	if (won == true)
	{
		cout << "Congrats you won!!!" << endl;
		cout << "You guessed the movie:" << word_to_guess << endl;
		cout << "You took " << no_of_guesses << " guesses" << endl;
		cout << "You had " << no_of_chances << " remaining" << endl;
	} else 
	{
		cout << "Game Over!!" << endl;
		cout << "The movie was:" << word_to_guess << endl;
		cout << "You made " << no_of_guesses << " guesses" << endl;
	}
	return false;
}

int main()
{
	char start_game_option;
	cout << "Welcome to hangman" << endl;
	cout << "start a new game? Y/N" << endl;
	cin >> start_game_option;
	if (start_game_option == 'Y' || start_game_option == 'y')
	{
		game();
	} else if (start_game_option == 'N' || start_game_option == 'n')
	{
		exit(0);
	} else {
		cout << "Didn't get a proper response. Goodbye" << endl;
	}
	return 0;
}
