# CodeWars:Is the King in check ?:20230321:GO

tags: #problem_solve #codewars/5kyu #golang

[Reference](https://www.codewars.com/kata/5e28ae347036fa001a504bbe)

## Question

You have to write a function that takes for input a 8x8 chessboard in the form of a bi-dimensional array of chars (or strings of length 1, depending on the language) and returns a boolean indicating whether the king is in check.

The array will include 64 squares which can contain the following characters :

'♔' for the black King;
'♛' for a white Queen;
'♝' for a white Bishop;
'♞' for a white Knight;
'♜' for a white Rook;
'♟' for a white Pawn;
' ' (a space) if there is no piece on that square.
Note : these are actually inverted-color chess Unicode characters because the codewars dark theme makes the white appear black and vice versa. Use the characters shown above.

There will always be exactly one king, which is the black king, whereas all the other pieces are white.
The board is oriented from Black's perspective.
Remember that pawns can only move and take forward.
Also be careful with the pieces' lines of sight ;-) .

The input will always be valid, no need to validate it. To help you visualize the position, tests will print a chessboard to show you the problematic cases. Looking like this :

|---|---|---|---|---|---|---|---|
|   |   |   |   |   |   |   |   |
|---|---|---|---|---|---|---|---|
|   |   |   | ♜ |   |   |   |   |
|---|---|---|---|---|---|---|---|
|   |   |   |   |   |   |   |   |
|---|---|---|---|---|---|---|---|
|   |   |   | ♔ |   |   |   |   |
|---|---|---|---|---|---|---|---|
|   |   |   |   |   |   |   |   |
|---|---|---|---|---|---|---|---|
|   |   |   |   |   |   |   |   |
|---|---|---|---|---|---|---|---|
|   |   |   |   |   |   |   |   |
|---|---|---|---|---|---|---|---|
|   |   |   |   |   |   |   |   |
|---|---|---|---|---|---|---|---|

## My Solution

```go
package kata

func KingIsInCheck(board [8][8]rune) bool {
	kingPosI, kingPosJ := findKingPosition(board)
	return isAttackedByRookOrQueen(board, kingPosI, kingPosJ) ||
		isAttackedByBishopOrQueen(board, kingPosI, kingPosJ) ||
		isAttackedByKnight(board, kingPosI, kingPosJ) ||
		isAttackedByPawn(board, kingPosI, kingPosJ)
}

func findKingPosition(board [8][8]rune) (int, int) {
	for i, row := range board {
		for j := range row {
			if board[i][j] == '♔' {
				return i, j
			}
		}
	}
	return 0, 0
}

// isAttackedByRookOrQueen checks if the black king at position (ki, kj) is attacked by any white Rook or Queen on the given board.
func isAttackedByRookOrQueen(board [8][8]rune, ki, kj int) bool {
	// Check horizontally to the left of the king
	for j := kj - 1; j >= 0; j-- {
		if board[ki][j] == '♜' || board[ki][j] == '♛' {
			return true
		} else if board[ki][j] != ' ' { // Stop searching if there's a piece blocking the way
			break
		}
	}

	// Check horizontally to the right of the king
	for j := kj + 1; j < 8; j++ {
		if board[ki][j] == '♜' || board[ki][j] == '♛' {
			return true
		} else if board[ki][j] != ' ' { // Stop searching if there's a piece blocking the way
			break
		}
	}

	// Check vertically above the king
	for i := ki - 1; i >= 0; i-- {
		if board[i][kj] == '♜' || board[i][kj] == '♛' {
			return true
		} else if board[i][kj] != ' ' { // Stop searching if there's a piece blocking the way
			break
		}
	}

	// Check vertically below the king
	for i := ki + 1; i < 8; i++ {
		if board[i][kj] == '♜' || board[i][kj] == '♛' {
			return true
		} else if board[i][kj] != ' ' { // Stop searching if there's a piece blocking the way
			break
		}
	}

	// If none of the above conditions were met, the king is not attacked by any Rook or Queen
	return false
}

// isAttackedByBishopOrQueen checks if the black king at position (ki,kj) is attacked by any white Bishop or Queen on the given board.
func isAttackedByBishopOrQueen(board [8][8]rune, ki, kj int) bool {
	// Check diagonally up-left of the king
	for i, j := ki-1, kj-1; i >= 0 && j >= 0; i, j = i-1, j-1 {
		if board[i][j] == '♝' || board[i][j] == '♛' {
			return true
		} else if board[i][j] != ' ' {
			break // Stop searching when a piece is blocking the way
		}
	}

	// Check diagonally down-right of the king
	for i, j := ki+1, kj+1; i < 8 && j < 8; i, j = i+1, j+1 {
		if board[i][j] == '♝' || board[i][j] == '♛' {
			return true
		} else if board[i][j] != ' ' {
			break // Stop searching when a piece is blocking the way
		}
	}

	// Check diagonally up-right of the king
	for i, j := ki-1, kj+1; i >= 0 && j < 8; i, j = i-1, j+1 {
		if board[i][j] == '♝' || board[i][j] == '♛' {
			return true
		} else if board[i][j] != ' ' {
			break // Stop searching when a piece is blocking the way
		}
	}

	// Check diagonally down-left of the king
	for i, j := ki+1, kj-1; i < 8 && j >= 0; i, j = i+1, j-1 {
		if board[i][j] == '♝' || board[i][j] == '♛' {
			return true
		} else if board[i][j] != ' ' {
			break // Stop searching when a piece is blocking the way
		}
	}

	// If none of the above conditions were met, the king is not attacked by any Bishop or Queen
	return false
}

// isAttackedByKnight checks if the black king at position (ki, kj) is attacked by any white Knight on the given board.
func isAttackedByKnight(board [8][8]rune, ki, kj int) bool {
	// Check all 8 possible squares that a knight can attack from the king's position
	var knightMovesI = []int{-2, -2, -1, -1, 1, 1, 2, 2}
	var knightMovesJ = []int{-1, 1, -2, 2, -2, 2, -1, 1}

	for k := 0; k < 8; k++ {
		i := ki + knightMovesI[k]
		j := kj + knightMovesJ[k]

		if i >= 0 && i < 8 && j >= 0 && j < 8 && board[i][j] == '♞' {
			// Found a white knight attacking the black king
			return true
		}
	}

	// If none of the above conditions were met, the king is not attacked by any Knight
	return false
}

// isAttackedByPawn checks if the black king at position (ki, kj) is attacked by any white Pawn on the given board.
func isAttackedByPawn(board [8][8]rune, ki, kj int) bool {
	// Check diagonally up-left of the king
	if ki > 0 && kj > 0 && board[ki-1][kj-1] == '♟' {
		// Found a white pawn attacking the black king
		return true
	}

	// Check diagonally up-right of the king
	if ki > 0 && kj < 7 && board[ki-1][kj+1] == '♟' {
		// Found a white pawn attacking the black king
		return true
	}

	// If none of the above conditions were met, the king is not attacked by any Pawn
	return false
}

```

## Better Solutions

### Solution1

```go
package kata

import "errors"

func KingIsInCheck(board [8][8]rune) bool {
  for row := 0; row < 8; row++ {
    for col := 0; col < 8; col++ {
      if pieceHits(row, col, board) { return true }
    }
  }
  return false
}

func pieceHits(row, col int, board[8][8]rune) bool {
  switch cell := board[row][col]; cell {
    case '♟': return pawnHits(row, col, board)
    case '♞': return knightHits(row, col, board)
    case '♝': return bishopHits(row, col, board)
    case '♜': return rookHits(row, col, board)
    case '♛': return queenHits(row, col, board)
    default : return false
  }
}


func pawnHits(row, col int, board [8][8]rune) bool {
  left, _ := checkCell(row+1, col-1, board)
  right, _ := checkCell(row+1, col+1, board)
  return left || right
}

func knightHits(row, col int, board [8][8]rune) bool {
  c1, _ := checkCell(row-2, col+1, board)
  c2, _ := checkCell(row-1, col+2, board)
  c3, _ := checkCell(row+1, col+2, board)
  c4, _ := checkCell(row+2, col+1, board)
  c5, _ := checkCell(row+2, col-1, board)
  c6, _ := checkCell(row+1, col-2, board)
  c7, _ := checkCell(row-1, col-2, board)
  c8, _ := checkCell(row-2, col-1, board)
  return c1 || c2 || c3 || c4 || c5 || c6 || c7 || c8
}

func bishopHits(row, col int, board [8][8]rune) bool {
  l1 := checkLine(row, col, -1,  1, board)
  l2 := checkLine(row, col,  1,  1, board)
  l3 := checkLine(row, col,  1, -1, board)
  l4 := checkLine(row, col, -1, -1, board)
  return l1 || l2 || l3 || l4
}

func rookHits(row, col int, board [8][8]rune) bool {
  l1 := checkLine(row, col, -1,  0, board)
  l2 := checkLine(row, col,  1,  0, board)
  l3 := checkLine(row, col,  0,  1, board)
  l4 := checkLine(row, col,  0, -1, board)
  return l1 || l2 || l3 || l4
}

func queenHits(row, col int, board [8][8]rune) bool {
  return rookHits(row, col, board) || bishopHits(row, col, board)
}

func checkLine(row, col, dRow, dCol int, board[8][8]rune) bool {
  for {
    row = row + dRow
    col = col + dCol
    check, err := checkCell(row, col, board)
    if err != nil { return false }
    if check { return true }
  }
}

func checkCell(row, col int, board[8][8]rune) (bool, error) {
  if row < 0 || row > 7 || col < 0 || col > 7 { return false, errors.New("Out of board") }
  switch cell := board[row][col]; cell {
    case ' ': return false, nil
    case '♔': return true, nil
    default : return false, errors.New("Blocked")
  }
}

```
