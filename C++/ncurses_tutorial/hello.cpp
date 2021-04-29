#include<ncurses.h>

using namespace std;

int main()
{
	// initialize the screen
	initscr();

	printw("Hello World");
	getch();
	refresh();
	mvprintw(2,0,"Hello from");
	move(3, 5);
	getch();
	getch();

	// deallocate memory and end ncurses
	endwin();

	return 0;
}
