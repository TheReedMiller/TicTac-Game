# TicTac-Game
This is a Simplistic Game, built around a Variation of Tic Tac Toe.

# Code

This project is a combination of coding skils and languages. This uses a main c file to run the "brain" behind the code within the game. However this c program, outsorces some of its function calls to ARM64 assembly language files. These files have the setup for the game as well as some of the logic/computation behind the game. 

For Example: 
    -In order to decide whether a player has Won the game. the main.c program calls to a function written in tictac.S (assembly program) to return a boolean value.
    -To display the current state of the game, the main.c program calls to another assemply function to output the state to the terminal


# What this Project Showcases
This game showcases not only my skills in using c, but mostly showcases my knowledge of the ARM64 assembly language. While this is definately not the most "modern" form of coding, this proves that I can perform tasks given a set of constraits, such as these rudimentary programming languages.

The BIG-Topic covered in this project is creating Abstract Data Types. At the begining of my tictoc.S file, you can find my defenition/implimentation of the abstract data type. This requires setting aside a specific amound of data for items such as the Size of the gameboard, the array that stores the answer key to the game, as well as the array that stores the current state of the game. 

The program's ability to store both the current state of the game and the answer is actually done with a 2D-Array. Having an array for each index within the gameboard, and within that index, and array containing both the correct answer, as well as the current state.

This process also encompases, the use of proper allocation and termination of memory space for an array. Using precise calculation this program allocates not only enough space for variables such as pointers, gameboard size, but holds a 2D-Array. After the program is done running, it makes sure to properly de-allocate the created array(in reverse order), to return the memory to the state that it was when the program began.

# Game - Rules
1)  Every row must have an equal number of X's and O's.
2)  Every column must have an equal number of X's and O's.
3)  There can be no more than two X's or O's in a row vertically or horizontally.
4)  Every row and every column is unique.

 # How to Run this game
 Attached are a number of files, this includes:
 
 1 - Makefile
 
 1 - main.c file
 
 1 - tictac.S file
 
 4 - size.tictac files
 

 Once they are all in the same directory, type "make" in the terminal to use the makefile to asseble an executable program

 Then run the file, while also specifying which version(size) of the game to use. 

 Here are some examples:

 ./tictac 4x4.tictac
 
./tictac 8x12hard.tictac


 
