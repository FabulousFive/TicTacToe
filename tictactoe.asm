# Tic Tac Toe
# Lindsay Kislingbury, Catherine Lopez-Ruiz, Kenia Velasco, Hadya Rohin, Hope Gomez

.macro  end
	li $v0, 10
	syscall
.end_macro
	

.data
# Messages
welcomeMessage:	.asciiz "\nTic Tac Toe!\n"
turnMessage_X:	.asciiz "Player X's turn!\n"
turnMessage_O:	.asciiz "Player O's turn!\n"
inputPrompt:	.asciiz "Enter position (1-9): "
invalidMessage:	.asciiz "Invalid move! Try again.\n"
winMessage:		.asciiz "\nWINNER: "
tieMessage:		.asciiz "Game Tie!\n"
playAgainPrompt:	.asciiz "Play Again? (1=Yes, 0=No): "

# Board Data 
board:		.word boardRow0, boardRow1, boardRow2
boardRow0:		.word 1, 2, 3
boardRow1: 	.word 4, 5, 6
boardRow2: 	.word 7, 8, 9

# Constants
.eqv MARK_X 1 # like an enum. makes the code more readable. not necessary if we dont want to use them
.eqv MARK_0 2

# Game State
currentPlayer: 	.word 1 # 1 for player X, 2 for player O
movesMade:		.word 0 # track # of moves (max 9)

.text
main:
	# Print Welcome Message
	li $v0, 4
	la $a0, welcomeMessage
	syscall
	
	# Initalize game
	jal initalizeGame
	
gameLoop:
	# 1. Display current board 
	jal drawBoard
	
	# 2. Show whose turn it is
	lw $t0, currentPlayer
	li $t1, 1		
	beq $t0, $t1, showXTurn # if current player is 1, go to showXTurn
	j showOTurn # if not, go to showOTurn
	
showXTurn:
    	li $v0, 4
    	la $a0, turnMessage_X
    	syscall
    	j getMove

showOTurn:
   	li $v0, 4
    	la $a0, turnMessage_O
    	syscall
   	j getMove

getMove:
	# 3. Get and validate move
	jal getPlayerMove # SHOULD STORE VALID MOVE IN $v0
	
	# 4. Execute Move
	move $a0, $v0 # put the chosen position in $a0
	lw $a1, currentPlayer # put the current mark (1 for X, 2 for O) in $a1
	jal executeMove
	
	# 5. Check for win
	jal checkWin
	bnez $v0, gameWon # if win is detected, go to gameWon
	
	# 6. Check for tie
	lw $t0, movesMade
	li $t1, 9 # if 9 moves made, it's a tie
	beq $t0, $t1, gameTie
	
	# 7. Switch player and continue game loop
	jal switchPlayer
	j gameLoop

gameWon:
	# Handle win condition
	li $v0, 4
	la $a0, winMessage
	syscall
	
	# Display final board
	jal drawBoard
	j playAgain

gameTie:
	# Handle tie condition
	li $v0, 4
	la $a0, tieMessage
	syscall
	j playAgain

playAgain:
	li $v0, 4
	la $a0, playAgainPrompt
	syscall
	
	li $v0, 5 # read play again choice
	syscall
	
	bnez $v0, main #if not zero, go to start of main
	end 
	
initializeGame:
	# Reset moves counter movesMade
	sw $zero, movesMade
	
	# Set player to 1. Player 1 is X
	li $t0, 1
	sw $t0, currentPlayer
	jr $ra # RETURN TO THE ADDRESS WHERE THIS FUNCTION WAS CALLED <(^.^)>

# Switches current player between X and O
# Also increments move counter
switchPlayer:
	lw $t0, currentPlayer  # load current player value into $t0 (1=X, 2=O)
	li $t1, 1		# will compare against MARK_X (1)
	# if the current player is X (1), branch to setO to change to player O
	beq $t0, $t1, setO	# if current player is X, make it O's turn
	# if we get here, current player was O
	li $t0, 1		# set back to X (1)
	j storePlayer	# jump to store 1

# Changes player to O
setO:	li $t0, 2		# set to 2

# Save new current player to memory
storePlayer: 
	sw $t0, currentPlayer # save new current player
	
	# Increment moves counter
	lw $t0, movesMade 	# get current number of moves
	addi $t0, $t0, 1	# increment number of moves made
	sw $t0, movesMade	# save new moves count to memory
	jr $ra		# go back to where this function was called (game loop)
	
# PERSON 1
# Function: Displays the current state of the game board
# Should show numbers 1-9 for empty squares, X for MARK_X, and O for MARK_O
# Input: none
# Output: none
# Uses board data structure to know what to display
drawBoard:
    # TODO:
    # - Load board values from memory
    # - For each cell:
    #   * If value is MARK_X (1), display "X"
    #   * If value is MARK_O (2), display "O"
    #   * Otherwise display the position number
    # - Include vertical and horizontal lines between cells
    jr $ra

# PERSON 2
# Function: Gets and validates a player's move
# Input: none
# Output: $v0 = chosen position (1-9)
# Must verify:
# - Input is between 1 and 9
# - Chosen position is not already taken
getPlayerMove:
    # TODO: 
    # - Display input prompt
    # - Get number from player
    # - Check if valid position (1-9)
    # - Check if position is available
    # - If invalid, show error and ask again
    # - Return valid position in $v0
    
    # For now, just get any number
    li $v0, 5          # Read integer
    syscall
    jr $ra

# PERSON 3
# Function: Places a player's mark on the board
# Input: $a0 = position (1-9), $a1 = current player mark (MARK_X or MARK_O)
# Output: none
# Updates the board array in memory
executeMove:
    # TODO:
    # - Convert position 1-9 to correct row and column
    # - Store player's mark (X=1 or O=2) in correct board position
    # - No need to validate move (Person 2 handles that)
    jr $ra

# PERSON 4
# Function: Checks if current board state is a win
# Input: none
# Output: $v0 = 1 if game is won, 0 otherwise
# Must check:
# - All rows (3)
# - All columns (3)
# - Both diagonals (2)
checkWin:
    # TODO:
    # - Check each row for three matching marks
    # - Check each column for three matching marks
    # - Check both diagonals for three matching marks
    # - If any line has three matching X's or O's:
    #   * Return 1 in $v0
    # - Otherwise:
    #   * Return 0 in $v0
    
    # For now, always return 0 (no win)
    li $v0, 0
    jr $ra
	
