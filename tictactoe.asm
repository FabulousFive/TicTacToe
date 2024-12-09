#Tic Tac Toe
# Lindsay Kislingbury, Catherine Lopez-Ruiz, Kenia Velasco, Hadya Rohin, Hope Gomez
# 12/08/2024

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
howTo: .asciiz "\n(1)Before the game starts, Player 1 is given the option to be X's or O's\n(2)Based on what player 1 picks, player 2 will be the other option (X or O).\n(3)Player 1 then picks a number 1-9, to input an X or an O on one of the 9 open spaces on the board. \n(4)Once Player 1 inputs a number, their turn is over, and it is now Player 2's turn to pick a number 1-9.\n(5)Keep repeating steps (3) and (4) until the game is over.\n(6)Once the game is over, the winner is revealed, and you will have the option to play again or exit the game. \n"
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
turnMessage_1: .asciiz "\nPlayer 1's turn ("
turnMessage_2: .asciiz "\nPlayer 2's turn ("
closeParen: .asciiz ")!\n"
inputPrompt:	.asciiz "Enter position (1-9): "
invalidMessage:	.asciiz "Invalid move! Try again.\n"
winMessage:		.asciiz "\nWINNER: "
tieMessage:		.asciiz "Game Tie!\n"
playAgainPrompt:	.asciiz "Play Again? (1=Yes, 0=No): "
nL: .asciiz "   \n   "
newLine: .asciiz "\n"

# Board Data 
boardValues: .byte '1', '2', '3', '4', '5', '6', '7', '8', '9'  # Initial board state

# Draw Board
rowDivider: .asciiz "\n-----\n"
columnDivider: .byte '|'

# Game State
currentPlayer: 	.word 1 # 1 for player X, 2 for player O
movesMade:		.word 0 # track # of moves (max 9)
player1_Letter: .byte 0 # X or O 
player2_Letter: .byte 0 # X or O


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
	
	j equals3
	
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
	li $v0, 12
	syscall
	move $t0, $v0
	
	beq $t0, 'y', yes
	#else no
		jal main
	
yes:
	jal equals3

IsUserInput3:
	#If User input is 3
	beq $t0, 3, equals3

equals3:
   	#new line Character
    	li $v0, 4
    	la $a0, newLine
    	syscall	

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
    # Store X for player 1 and O for player 2
    la $t1, player1_Letter
    li $t2, 'X'
    sb $t2, ($t1)         # Store X in player1_Letter
    
    la $t1, player2_Letter
    li $t2, 'O'
    sb $t2, ($t1)         # Store O in player2_Letter
    
    # player 1 is x message
    li $v0, 4
    la $a0, player1isX
    syscall
    
    j initialize
    
equalsO: 
    # Store O for player 1 and X for player 2
    la $t1, player1_Letter
    li $t2, 'O'
    sb $t2, ($t1)         # Store O in player1_Letter
    
    la $t1, player2_Letter
    li $t2, 'X'
    sb $t2, ($t1)         # Store X in player2_Letter
    
    # player 1 is o message
    li $v0, 4
    la $a0, player1isO
    syscall
    
    j initialize
    
# Initialize new game
# Resets board state, move counter, and sets Player 1 as current
# Returns: None
initialize:	
	jal initializeGame
	j gameLoop

# Main game loop 
# Handles turns, moves, and checks for win/tie conditions
# Continues until game ends
gameLoop:
    # display current board 
    jal drawBoard

    # show whose turn it is based on currentPlayer value
    lw $t0, currentPlayer   # 1 for Player 1, 2 for Player 2
    li $t1, 1
    
    # show player turn message
    beq $t0, $t1, displayPlayer1Turn
    j displayPlayer2Turn

displayPlayer1Turn:
    # print "Player 1's turn ("
    li $v0, 4
    la $a0, turnMessage_1
    syscall
    
    # print their symbol (X or O)
    la $t0, player1_Letter
    lb $a0, ($t0)        # load byte
    li $v0, 11			# print char
    syscall
    
    # print closing )
    li $v0, 4
    la $a0, closeParen
    syscall
    j getMove

displayPlayer2Turn:
    # print "Player 2's turn ("
    li $v0, 4
    la $a0, turnMessage_2
    syscall
    
    # print their symbol (X or O)
    la $t0, player2_Letter
    lb $a0, ($t0)        # load byte
    li $v0, 11			# print char
    syscall
    
    # print closing )
    li $v0, 4
    la $a0, closeParen
    syscall
    j getMove
    
getMove:
    # get and process move
    jal getPlayerMove       # returns the chosen position in $v0
    move $a0, $v0           # put chosen position in $a0
    jal executeMove
    
    # check for win
    jal checkWin
    move $t0, $v0         
    bnez $t0, gameWon
    
    # check for tie
    # 9 moves and no win is a tie
    lw $t0, movesMade
    li $t1, 9
    beq $t0, $t1, gameTie
    
    # switch player and continue
    jal switchPlayer
    j gameLoop

gameWon:
    # phow win message
    li $v0, 4
    la $a0, winMessage
    syscall
    
    # print winning player's symbol
    lw $t0, currentPlayer
    li $t1, 1
    beq $t0, $t1, showPlayer1Win
    lb $a0, player2_Letter
    j displayWinner
    
showPlayer1Win:
    lb $a0, player1_Letter

displayWinner:
    li $v0, 11    # print char
    syscall
    
    li $v0, 4      
    la $a0, newLine
    syscall
    j playAgain

gameTie:
    # print tie message
    li $v0, 4
    la $a0, tieMessage
    syscall
    j playAgain

playAgain:
	# print prompt to play again
    li $v0, 4
    la $a0, playAgainPrompt
    syscall
    
    li $v0, 5 # get play again choice
    syscall
    
    beqz $v0, endGame  # 0 = end game
    j initialize       # otherwise initialize and start new game
    
endGame:
    end
	
initializeGame:
    # reset moves counter
    sw $zero, movesMade
    
    # always start with Player 1
    li $t0, 1
    sw $t0, currentPlayer
    
    # reset board values
    la $t0, boardValues
    li $t1, '1'
    sb $t1, 0($t0)
    li $t1, '2'
    sb $t1, 1($t0)
    li $t1, '3'
    sb $t1, 2($t0)
    li $t1, '4'
    sb $t1, 3($t0)
    li $t1, '5'
    sb $t1, 4($t0)
    li $t1, '6'
    sb $t1, 5($t0)
    li $t1, '7'
    sb $t1, 6($t0)
    li $t1, '8'
    sb $t1, 7($t0)
    li $t1, '9'
    sb $t1, 8($t0)
    
    jr $ra
    
# Process a player's move
# Gets input position (1-9), validates it, updates board
# Returns: Position chosen in $v0
getPlayerMove:
    # print move input prompt
    li $v0, 4
    la $a0, inputPrompt
    syscall
    
getInput:  
    li $v0, 5      # Read integer
    syscall
    move $t0, $v0  # Save input to $t0 
    
    # basic position check (keeps game working)
    li $t1, 1
    blt $t0, $t1, invalidInput   # if < 1 invalid
    li $t1, 9
    bgt $t0, $t1, invalidInput   # if > 9 invalid
    
    #map position to index 
    subi $t0, $t0, 1		#convert to 0 based index
    la $t1, boardValues
    add $t1, $t1, $t0	#get address of board at position
    lb $t2, ($t1)		#load current value
    
    #check if position is taken by 'X/x' or 'O/o'
    li $t3, 'X'
    beq $t2, $t3, invalidInput	#if value is x, go to invalidInput
    li $t3, 'x'
    beq $t2, $t3, invalidInput
    li $t3, 'O'
    beq $t2, $t3, invalidInput	#if value is o, go to invalidInput
    li $t3, 'o'
    beq $t2, $t3, invalidInput
    
    #valid position
    addi $t0, $t0, 1
    move $v0, $t0  		# move to return value
    jr $ra

invalidInput:
    # show error message
    li $v0, 4
    la $a0, invalidMessage
    syscall
    j getInput         # get input again

# Execute a player's move on the board
# Inputs: $a0 = position (1-9)
# Updates board array with current player's symbol
executeMove:
    # convert position (1-9) to array index (0-8)
    addi $t0, $a0, -1    # subtract 1 from position to get index
    
    # get the current player's symbol
    lw $t1, currentPlayer
    li $t2, 1
    beq $t1, $t2, usePlayer1Symbol
    lb $t3, player2_Letter    # load Player 2's symbol
    j storeSymbol
    
usePlayer1Symbol:
    lb $t3, player1_Letter    # load Player 1's symbol
    
storeSymbol:
    # store symbol in the board array
    la $t2, boardValues     # load address of board array
    add $t2, $t2, $t0       # add index offset
    sb $t3, ($t2)           # store the symbol at that position
    
    # increment moves counter
    lw $t0, movesMade
    addi $t0, $t0, 1
    sw $t0, movesMade
    
    jr $ra

# Switch active player
# Changes currentPlayer between 1 and 2
# Returns: None 
switchPlayer:
    lw $t0, currentPlayer   # load current player value
    li $t1, 1
    beq $t0, $t1, setPlayer2     # if player 1's turn, switch to player 2
    li $t0, 1              # otherwise, switch back to player 1
    j storePlayer

setPlayer2:    
    li $t0, 2              # set to player 2

storePlayer:
    sw $t0, currentPlayer  # save new current player
    jr $ra


# Draw the current game board
# Displays 3x3 grid with current game state
# Returns: None
drawBoard:
    #new line Character
    li $v0, 4
    la $a0, newLine
    syscall

    la $t0, boardValues    # load board array address
    
    # Row 0
    # First cell
    lb $a0, ($t0)         # Load value
    li $v0, 11            # Print character
    syscall

    li $v0, 4
    la $a0, columnDivider
    syscall

    # Second cell
    lb $a0, 1($t0)        # Load next value
    li $v0, 11
    syscall

    li $v0, 4
    la $a0, columnDivider
    syscall

    # Third cell
    lb $a0, 2($t0)
    li $v0, 11
    syscall

    li $v0, 4
    la $a0, rowDivider
    syscall

    # Row 1
    lb $a0, 3($t0)
    li $v0, 11
    syscall

    li $v0, 4
    la $a0, columnDivider
    syscall

    lb $a0, 4($t0)
    li $v0, 11
    syscall

    li $v0, 4
    la $a0, columnDivider
    syscall

    lb $a0, 5($t0)
    li $v0, 11
    syscall

    li $v0, 4
    la $a0, rowDivider
    syscall

    # Row 2
    lb $a0, 6($t0)
    li $v0, 11
    syscall

    li $v0, 4
    la $a0, columnDivider
    syscall

    lb $a0, 7($t0)
    li $v0, 11
    syscall

    li $v0, 4
    la $a0, columnDivider
    syscall

    lb $a0, 8($t0)
    li $v0, 11
    syscall

    #new line Character
    li $v0, 4
    la $a0, nL
    syscall

    jr $ra

# Function: Checks for win condition (3-in-a-row)
# Returns: 1 in $v0 if game is won, 0 if not won
# Uses: boardValues array to check symbol positions
checkWin:
	# Save return address on the stack
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	# Check all win conditions (rows, columns, diagonals)
	jal winRow0
	jal winRow1
	jal winRow2
	jal winCol0
	jal winCol1
	jal winCol2
	jal winDiag0
	jal winDiag1

	# If no win condition met, set $v0 to 0
	addi $v0, $zero, 0

	# Restore return address and adjust stack pointer
	lw $ra, 0($sp)
	addi $sp, $sp, 4

	# Return to the caller
	jr $ra

# Function to check the first row for a win
winRow0:
	la $t2, boardValues    # Load base address of board
	lb $t3, 0($t2)         # Load first character of row 0
	lb $t4, 1($t2)         # Load second character of row 0
	lb $t5, 2($t2)         # Load third character of row 0

	# Check if all characters match and are not empty
	beq $t3, $t4, checkRow0Second
	jr $ra
	
checkRow0Second:
	beq $t4, $t5, checkRow0Third
	jr $ra
	
checkRow0Third:
	bne $t3, ' ', winReturn
	jr $ra

# Function to check the second row for a win
winRow1:
	la $t2, boardValues    # Load base address of board
	addi $t2, $t2, 3       # Offset to start of row 1
	lb $t3, 0($t2)
	lb $t4, 1($t2)
	lb $t5, 2($t2)

	# Check if all characters match and are not empty
	beq $t3, $t4, checkRow1Second
	jr $ra
	
checkRow1Second:
	beq $t4, $t5, checkRow1Third
	jr $ra
	
checkRow1Third:
	bne $t3, ' ', winReturn
	jr $ra

# Function to check the third row for a win
winRow2:
	la $t2, boardValues    # Load base address of board
	addi $t2, $t2, 6       # Offset to start of row 2
	lb $t3, 0($t2)
	lb $t4, 1($t2)
	lb $t5, 2($t2)

	# Check if all characters match and are not empty
	beq $t3, $t4, checkRow2Second
	jr $ra
	
checkRow2Second:
	beq $t4, $t5, checkRow2Third
	jr $ra
	
checkRow2Third:
	bne $t3, ' ', winReturn
	jr $ra

# Function to check the first column for a win
winCol0:
	la $t2, boardValues    # Load base address of board
	lb $t3, 0($t2)         # Load first character of column 0
	lb $t4, 3($t2)         # Load second character of column 0
	lb $t5, 6($t2)         # Load third character of column 0

	# Check if all characters match and are not empty
	beq $t3, $t4, checkCol0Second
	jr $ra
	
checkCol0Second:
	beq $t4, $t5, checkCol0Third
	jr $ra
	
checkCol0Third:
	bne $t3, ' ', winReturn
	jr $ra

# Function to check the second column for a win
winCol1:
	la $t2, boardValues
	lb $t3, 1($t2)
	lb $t4, 4($t2)
	lb $t5, 7($t2)

	beq $t3, $t4, checkCol1Second
	jr $ra
	
checkCol1Second:
	beq $t4, $t5, checkCol1Third
	jr $ra
	
checkCol1Third:
	bne $t3, ' ', winReturn
	jr $ra

# Function to check the third column for a win
winCol2:
	la $t2, boardValues
	lb $t3, 2($t2)
	lb $t4, 5($t2)
	lb $t5, 8($t2)

	beq $t3, $t4, checkCol2Second
	jr $ra
	
checkCol2Second:
	beq $t4, $t5, checkCol2Third
	jr $ra
	
checkCol2Third:
	bne $t3, ' ', winReturn

	jr $ra

# Function to check the main diagonal for a win
winDiag0:
	la $t2, boardValues
	lb $t3, 0($t2)
	lb $t4, 4($t2)
	lb $t5, 8($t2)

	beq $t3, $t4, checkDiag0Second
	jr $ra
	
checkDiag0Second:
	beq $t4, $t5, checkDiag0Third
	jr $ra
	
checkDiag0Third:
	bne $t3, ' ', winReturn
	jr $ra

# Function to check the anti-diagonal for a win
winDiag1:
	la $t2, boardValues
	lb $t3, 2($t2)
	lb $t4, 4($t2)
	lb $t5, 6($t2)

	beq $t3, $t4, checkDiag1Second
	jr $ra
	
checkDiag1Second:
	beq $t4, $t5, checkDiag1Third
	jr $ra
	
checkDiag1Third:
	bne $t3, ' ', winReturn
	jr $ra

# Common return point for a win condition
winReturn:
    addi $v0, $zero, 1          # Indicate a win in $v0
    li $t7, 1                   # Set winner flag
    lw $ra, 0($sp)              # Restore return address
    addi $sp, $sp, 4            # Restore stack pointer
    jr $ra                      # Return to caller
    
    li $v0, 0              		# Default: no win
    jr $ra
