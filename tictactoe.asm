# Tic Tac Toe
# Lindsay Kislingbury, Catherine Lopez-Ruiz, Kenia Velasco, Hadya Rohin, Hope Gomez


.macro  end
	li $v0, 10
	syscall
.end_macro
	

.data
# Messages
welcomeMessage:	.asciiz "\n	 Tic Tac Toe!\n"
mainMenu: .asciiz "\n----------MAIN MENU----------\n1. Rules of the Game\n2. How to play in MIPS\n3. Play Game!\n"
selectOne: .asciiz "\nPlase select one of the options: "
gameRulesTitle:"\n----------Tic Tac Toe Rules-----------"
gameRules: .asciiz "\n(1)Tic Tac Toe is a two player game.\n(2)One person is the X's and the other person is the O's.\n(3)Each player takes a turn placing an 'X' or an 'O' on the board.\n(4)You win by getting three X's or three O's in a row.\n(5)A row can be diagonal, horizontal, or verticle.\n(6)If no one has three in a row, and there are no spaces on the board left, then no one wins.\n"
howToTitle: .asciiz "\n----------How to Play Tic Tac Toe in MIPS----------"
howTo: .asciiz "\n(1)Use a, s, d, f, to move from one box to the other.\n	(a)Move One LEFT	\n	(s)Move One UP\n	(d)Move One DOWN\n	(f)Move One RIGHT\n(2)Keep using a, s, d, f to move until you are at your desired location.\n(3)Once you are at your desired location, type X or O depending on if you are X's or O's.\n(4)Once you input you X or O, your turn is over, and it is the next players turn.\n(5)Keep repeating until the game is over.\n"
ready: .asciiz "\nAre you ready to play Tic Tac Toe?!\nType 'y' for yes or 'n' for no: "
startGame: .asciiz "\nLet's play Tic Tac Toe!"
promptXorO: .asciiz "\nPlayer 1, Please select X or O: "
player1isX: .asciiz "\nPlayer 1, you are X's! \nPlayer 2, you are O's!\n\n"
player1isO: .asciiz "\nPlayer 1, you are O's! \nPlayer 2, you are X's!\n\n"
choiceX: .byte 'X'
choicex: .byte 'x'
choiceO: .byte 'O'
choiceo: .byte 'o'
choiceYes: .byte 'y'
choiceNo: .byte 'n'
turnMessage_X:	.asciiz "\nPlayer X's turn!\n"
turnMessage_O:	.asciiz "Player O's turn!\n"
inputPrompt:	.asciiz "Enter position (1-9): "
invalidMessage:	.asciiz "Invalid move! Try again.\n"
winMessage:		.asciiz "\nWINNER: "
tieMessage:		.asciiz "Game Tie!\n"
playAgainPrompt:	.asciiz "Play Again? (1=Yes, 0=No): "
nL: .asciiz "   \n   "

# Board Data 
board:		.word boardRow0, boardRow1, boardRow2
boardRow0:	.word 1, 2, 3
boardRow1: 	.word 4, 5, 6
boardRow2: 	.word 7, 8, 9

# Draw Board
rowDivider: .asciiz "\n-----\n"
columnDivider: .byte '|'

# Game State
currentPlayer: 	.word 1 # 1 for player X, 2 for player O
movesMade:		.word 0 # track # of moves (max 9)

player1_Letter: .word 0
player2_Letter: .word 0


.text
main:
	# Print Welcome Message
	li $v0, 4
	la $a0, welcomeMessage
	syscall
	
	#Print Menu Menu and Options
	li $v0, 4
	la $a0, mainMenu
	syscall
	
	#Print Prompt for user to select an option
	li $v0, 4
	la $a0, selectOne
	syscall
	
	#Get user input for menu
	li $v0, 5
	syscall
	move $t0, $v0
	
IsUserInput1:
	#if user input is 1
	beq $t0,1, equals1
	
	j IsUserInput2
	
equals1:#show rules 

#Show Rules Title
	li $v0, 4
	la $a0, gameRulesTitle
	syscall

#Show rules of Tic-tac-toe
	li $v0, 4
	la $a0, gameRules
	syscall
	
	#print out "Are you ready prompt"
	li $v0, 4
	la $a0, ready
	syscall
	
	#Get Player's responce, Yes or No
	li $v0, 8
	syscall
	move $t0, $v0
	
	jal initialize
	
IsUserInput2:
	#If user input is 2
	beq $t0,2,equals2
	
	j IsUserInput3
	
equals2: #Show how to play in MIPS

#Print howTo Title
	li $v0, 4
	la $a0, howToTitle
	syscall

#Print howTo description
	li $v0, 4
	la $a0, howTo
	syscall
	
	li $v0, 4
	la $a0, ready
	syscall
	
	#Get Player's responce, Yes or No
	li $v0, 8
	syscall
	move $t0, $v0
	
	beq $t0, 'y', yes
	
	#else no
	
	
	yes:
		jal initialize




IsUserInput3:
	#If User input is 3
	beq $t0, 3, equals3
equals3:
	# Initalize game
	li $v0, 4
	la $a0, startGame
	syscall
	
	#Prompt for Player 1 to pick X or O 
	li $v0, 4
	la $a0, promptXorO
	syscall
	
	#Get Player's pick of X or O
	li $v0, 12
	syscall
	move $t0, $v0
	
	
	#If Player Picks Capitol X or Lower Case X
conditionIfX:
	beq $t0, 'X', equalsX
		jal  conditionIfx 
conditionIfx:	
	beq $t0, 'x', equalsX
		jal conditionIfO 
	
	#If Player 1 Picks Capitol O or lower Case O
conditionIfO:
	beq $t0, 'O', equalsO 
		jal conditionIfo

conditionIfo:
	beq $t0, 'o', equalsO
		jal conditionIfX
	
equalsX: 
	#player 1 is x message
	li $v0, 4
	la $a0, player1isX
	syscall
	
	jal initialize
	
equalsO: 
	#player 1 is o message
	li $v0, 4
	la $a0, player1isO
	syscall
	
initialize:	
	jal initializeGame
	
	#else, send error message
	
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

#new line Character
#li $v0, 4
#la $a1, nL
#syscall

#MAKE INTO .MACROS
Row0:
li $v0, 1
la $a0, 1
syscall

li $v0, 4
la $a0, columnDivider
syscall

li $v0, 1
la $a0, 2
syscall

li $v0, 4
la $a0, columnDivider
syscall

li $v0, 1
la $a0, 3
syscall

li $v0, 4
la $a0, rowDivider
syscall

Row1:

li $v0, 1
la $a0, 4
syscall

li $v0, 4
la $a0, columnDivider
syscall


li $v0, 1
la $a0, 5
syscall

li $v0, 4
la $a0, columnDivider
syscall

li $v0, 1
la $a0, 6
syscall

li $v0, 4
la $a0, rowDivider
syscall

Row2:

li $v0, 1
la $a0, 7
syscall

li $v0, 4
la $a0, columnDivider
syscall


li $v0, 1
la $a0, 8
syscall

li $v0, 4
la $a0, columnDivider
syscall

li $v0, 1
la $a0, 9
syscall

#new line Character
li $v0, 4
la $a0, nL
syscall

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
