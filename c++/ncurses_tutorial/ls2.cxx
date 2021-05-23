/*
 * LS2 is a new version of ls command
 */

#include<ncurses.h>

#include<iostream>
#include<stdexcept>
#include<stdio.h>
#include<string>


using namespace std;

string exec(string command)
{
	char buffer[255];
	string result = "";
	//FILE* pipe = popen(command.c_str(), "r");
	FILE* pipe = popen("ls", "r");
	if (!pipe) {
		return "popen failed";
	}

	while(!feof(pipe)) {
		if (fgets(buffer, 255, pipe) != NULL)
			result += buffer;
	}

	pclose(pipe);
	return result;
}

int main()
{
	string ls = exec("ls");
	cout << ls;

	initscr();

	mvprintw(2,0,ls.c_str());
	getch();
	endwin();
}
