# Tic Tac Toe MIPS Assembly Project

## Team Members
- Lindsay Kislingbury
- Catherine Lopez-Ruiz
- Kenia Velasco
- Hadya Rohin
- Hope Gomez

## Project Description
This project is a fully functional implementation of the classic Tic Tac Toe game in MIPS assembly language. Players can take turns placing X's and O's on a 3x3 grid with the goal of getting three in a row horizontally, vertically, or diagonally.

## Features
- Interactive menu system with game rules and instructions
- Player choice between X and O
- Visual representation of the game board
- Input validation to prevent illegal moves
- Win condition detection for rows, columns, and diagonals
- Tie game detection
- Option to play multiple games in succession

## How to Run the Program

### Requirements
- MARS (MIPS Assembler and Runtime Simulator)
  - You can download MARS from [Missouri State University's website](http://courses.missouristate.edu/kenvollmar/mars/) if you don't already have it

### Running Instructions
1. Download and open MARS
2. Open the Tic Tac Toe program file (`TicTacToe.asm`) in MARS
   - File → Open → Navigate to and select the file
3. Assemble the program
   - Click the "Assemble" button (wrench icon) or press F3
4. Run the program
   - Click the "Run" button (green play icon) or press F5
5. Interact with the program through the MARS text console window that appears

## Gameplay Instructions
1. Use the main menu to:
   - View the rules of Tic Tac Toe
   - Learn how to play in MIPS
   - Start a new game
2. Player 1 will choose to be either X or O
3. Players take turns entering a number (1-9) corresponding to the position on the board where they want to place their mark
4. The game will announce a winner or a tie when appropriate
5. After a game ends, you can choose to play again or exit

## Implementation Notes
- The game uses arrays to track the state of the board
- Player input is validated to ensure only legal moves are made
- The program uses MIPS syscalls for user input and output
- Win conditions are checked after each move

Enjoy playing Tic Tac Toe in MIPS assembly!
