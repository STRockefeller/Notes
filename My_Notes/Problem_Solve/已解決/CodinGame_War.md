# CodinGam:War:20220127:Go

## Question



Reference

Let's go back to basics with this simple card game: war!

Your goal is to write a program which finds out which player is the winner for a given card distribution of the "war" game.

###  Rules

War is a card game played between two players. Each player gets a variable number of cards of the beginning of the game: that's the player's deck. Cards are placed face down on top of each deck.

**Step 1 : the fight**

At each game round, in unison, each player reveals the top card of their deck – this is a "battle" – and the player with the higher card takes both the cards played and moves them to the bottom of their stack. The cards are ordered by value as follows, from weakest to strongest:

2, 3, 4, 5, 6, 7, 8, 9, 10, J, Q, K, A.

**Step 2 : war**

If the two cards played are of equal value, then there is a "war". First, **both players place the three next cards of their pile face down**. Then they go back to step 1 to decide who is going to win the war (**several "wars" can be chained**). As soon as a player wins a "war", the winner adds all the cards from the "war" to their deck.

**Special cases:**

- If a player runs out of cards during a "war" (when giving up the three cards or when doing the battle), then the game ends and both players are placed equally first.
- The test cases provided in this puzzle are built in such a way that a game always ends (you do not have to deal with infinite games)

Each card is represented by its value followed by its suit: 

D, H, C, S. For example: 4H, 8C, AS.

When a player wins a battle, they put back the cards at the bottom of their deck in a precise order. **First the cards from the first player, then the one from the second player** (for a "war", all the cards from the first player **then** all the cards from the second player).

For example, if the card distribution is the following:
Player 1 : 

10D 9S 8D KH 7D 5H 6S


Player 2 : 

10H 7H 5C QC 2C 4H 6D


Then after one game turn, it will be:
Player 1 : 

5H 6S 10D 9S 8D KH 7D 10H 7H 5C QC 2C


Player 2 : 

4H 6D

 

#### Victory Conditions

A player wins when the other player no longer has cards in their deck.



###  Game Input

Input

**Line 1:** the number N of cards for player one.

**N next lines:** the cards of player one.

**Next line:** the number M of cards for player two.

**M next lines:** the cards of player two.

Output

- If players are equally first: PAT
- Otherwise, the player number (1 or 2) followed by the number of game rounds separated by a space character. **A war or a succession of wars count as one game round**.

Constraints

0 < N, M < 1000



example

Input

```
3
AD
KC
QC
3
KH
QS
JC
```

Output

```
1 3
```





## My Solution

首先來分析一下 example

| タン | Player1 deck      | Player2 deck  |
| ---- | ----------------- | ------------- |
| 0    | AD KC QC          | KH QS JC      |
| 1    | KC QC AD KH       | QS JC         |
| 2    | QC AD KH KC QS    | JC            |
| 3    | AD KH KC QS QC JC | lose the game |

結果: Player 1 獲勝，回合數 3

比較可惜的是這個case有點過於簡單，沒有演示到 war 或者 chain wars



往上找 war 的範例來看

| タン | Player1 deck                          | Player2 deck          |
| ---- | ------------------------------------- | --------------------- |
| ?    | 10D 9S 8D KH 7D 5H 6S                 | 10H 7H 5C QC 2C 4H 6D |
| ?+1  | 5H 6S 10D 9S 8D KH 7D 10H 7H 5C QC 2C | 4H 6D                 |

Battle 階段 10D vs 10H 進入 war

根據規則

> both players place the three next cards of their pile face down

Player 1 拿出 9S 8D KH

Player 2 拿出 7H 5C QC

> Then they go back to step 1 to decide who is going to win the war

再次 battle 7D vs 2C

> the winner adds all the cards from the "war" to their deck.

勝者全拿，先拿自己再拿對手

剩下的牌(5H 6S)+Battle(10D)+War(9S 8D KH)+WarBattle(7D)+對手出的順序同自己(10H 7H 5C QC 2C)



然後這些動作加起來算在同一個回合

如果後面還有chain wars 也算在一個回合



> If players are equally first: PAT

大致上已經了解流程了，現在只差這段話不清楚到底是什麼意思，先忽略直接寫好了。



---

每次出牌都是從前面開始出，每次拿牌都是補充到後面，一看就很適合用queue去存取

golang 官方沒有提供 queue的結構，所以要先實作一個出來，兩個方案一是使用slice二是使用channel。

這邊就採用比較有golang特色的channel來時做看看

```go
func main() {
	// n: the number of cards for player 1
	var n int
	fmt.Scan(&n)
	p1deck := make(chan string, 1000)
	p2deck := make(chan string, 1000)

	for i := 0; i < n; i++ {
		// cardp1: the n cards of player 1
		var cardp1 string
		fmt.Scan(&cardp1)
		p1deck <- cardp1
	}
	// m: the number of cards for player 2
	var m int
	fmt.Scan(&m)

	for i := 0; i < m; i++ {
		// cardp2: the m cards of player 2
		var cardp2 string
		fmt.Scan(&cardp2)
		p2deck <- cardp2
	}

	// fmt.Fprintln(os.Stderr, "Debug messages...")
	fmt.Println("PAT") // Write answer to stdout
}

```

因為n, m 都在0~1000之間，所以 buffer 就先開到1000

這樣就把初始狀態的牌組準配好了

流程寫一寫大概像這樣子

```go
func main() {
	// n: the number of cards for player 1
	var n int
	fmt.Scan(&n)
	p1deck := make(chan string, 1000)
	p2deck := make(chan string, 1000)

	for i := 0; i < n; i++ {
		// cardp1: the n cards of player 1
		var cardp1 string
		fmt.Scan(&cardp1)
		p1deck <- cardp1
	}
	// m: the number of cards for player 2
	var m int
	fmt.Scan(&m)

	for i := 0; i < m; i++ {
		// cardp2: the m cards of player 2
		var cardp2 string
		fmt.Scan(&cardp2)
		p2deck <- cardp2
	}

	for turn := 1; ; turn++ {
		battle(p1deck, p2deck)
		if end, winner := endGame(p1deck, p2deck); end {
			fmt.Println(end, winner)
			return
		}
	}
}

func battle(p1deck, p2deck chan string) {}

func endGame(p1deck, p2deck chan string) (bool, int) {
	return false, 0
}

func war(p1deck, p2deck chan string) {}
```

實作`endGame()`

```go
func endGame(p1deck, p2deck chan string) (bool, int) {
	if len(p1deck) == 0 {
		return true, 2
	}
	if len(p2deck) == 0 {
		return true, 1
	}
	return false, 0
}
```

解析強度

```go
func parsePower(str string) int {
	switch str[0] {
	case 'J':
		return 11
	case 'Q':
		return 12
	case 'K':
		return 13
	case 'A':
		return 14
	default:
		return int(str[0] - '0')
	}
}
```

實作 battle 邏輯，先不管 war 的部分

```go
func battle(p1deck, p2deck chan string) {
	p1 := <-p1deck
	p2 := <-p2deck

	power1 := parsePower(p1)
	power2 := parsePower(p2)

	if power1 == power2 {
		// war
		return
	}
	var winner chan string
	var firstCard, SecondCard string
	if power1 > power2 {
		winner = p1deck
		firstCard = p1
		SecondCard = p2
	} else {
		winner = p2deck
		firstCard = p2
		SecondCard = p1
	}
	winner <- firstCard
	winner <- SecondCard
}
```

到這裡為止，應該就可以處理沒有war的簡單情形了

考慮到war就會變得有點複雜了，因為能發生很多個 chain wars 所以使用遞迴來解題是最直覺的方法，但是題目所要求的放回排組的順序又增加了不少難度。

放回排組的順序是先勝者再敗者，然後根據的是出排順序，那麼把先前出過的牌記下來就勢在必行了。

修改方法簽章新增出牌紀錄的傳入



丟測試

```go
package main

import (
	"fmt"
)

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/

func main() {
	// n: the number of cards for player 1
	var n int
	fmt.Scan(&n)
	p1deck := make(chan string, 1000)
	p2deck := make(chan string, 1000)

	for i := 0; i < n; i++ {
		// cardp1: the n cards of player 1
		var cardp1 string
		fmt.Scan(&cardp1)
		p1deck <- cardp1
	}
	// m: the number of cards for player 2
	var m int
	fmt.Scan(&m)

	for i := 0; i < m; i++ {
		// cardp2: the m cards of player 2
		var cardp2 string
		fmt.Scan(&cardp2)
		p2deck <- cardp2
	}

	// fmt.Println("p1:")
	// for len(p1deck)>0{
	// 	fmt.Println("p1deck <- \""+<-p1deck+"\"")
	// }
	// fmt.Println("p2:")
	// for len(p2deck)>0{
	// 	fmt.Println("p2deck <- \""+<-p2deck+"\"")
	// }

	for turn := 1; ; turn++ {
		if winner := battle(p1deck, p2deck); winner != 0 {
			fmt.Println(winner, turn)
			return
		}
		if end, winner := endGame(p1deck, p2deck); end {
			fmt.Println(winner, turn)
			return
		}
	}
}

func battle(p1deck, p2deck chan string) int {
	p1 := <-p1deck
	p2 := <-p2deck

	power1 := parsePower(p1)
	power2 := parsePower(p2)

	if power1 == power2 {
		record1 := make(chan string, 1000)
		record2 := make(chan string, 1000)
		record1 <- p1
		record2 <- p2
		if len(p1deck) < 4 {
			return 2
		}
		if len(p2deck) < 4 {
			return 1
		}
		return war(p1deck, p2deck, record1, record2)
	}
	var winner chan string
	var firstCard, SecondCard string
	if power1 > power2 {
		winner = p1deck
		firstCard = p1
		SecondCard = p2
	} else {
		winner = p2deck
		firstCard = p2
		SecondCard = p1
	}
	winner <- firstCard
	winner <- SecondCard
	return 0
}

func parsePower(str string) int {
	switch str[0] {
	case 'J':
		return 11
	case 'Q':
		return 12
	case 'K':
		return 13
	case 'A':
		return 14
	default:
		return int(str[0] - '0')
	}
}

func endGame(p1deck, p2deck chan string) (bool, int) {
	if len(p1deck) == 0 {
		return true, 2
	}
	if len(p2deck) == 0 {
		return true, 1
	}
	return false, 0
}

func war(p1deck, p2deck, p1record, p2record chan string) int {
	for i := 0; i < 3; i++ {
		p1record <- <-p1deck
		p2record <- <-p2deck
	}

	p1 := <-p1deck
	p2 := <-p2deck

	power1 := parsePower(p1)
	power2 := parsePower(p2)
	p1record <- p1
	p2record <- p2

	if power1 == power2 {
		if len(p1deck) < 4 {
			return 2
		}
		if len(p2deck) < 4 {
			return 1
		}
		return war(p1deck, p2deck, p1record, p2record)
	}
	if power1 > power2 {
		for len(p1record) > 0 {
			p1deck <- <-p1record
		}
		for len(p2record) > 0 {
			p1deck <- <-p2record
		}
	} else {
		for len(p2record) > 0 {
			p2deck <- <-p2record
		}
		for len(p1record) > 0 {
			p2deck <- <-p1record
		}
	}
	return 0
}

```

大約有一半的case是失敗的

沒頭緒直接埋抓輸入的code去執行，然後拿去playground跑

這個case的結果是

```
Failure
Found: 2 34
Expected: 2 26
```



```go
package main

import (
	"fmt"
)

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/

func main() {
	// n: the number of cards for player 1
	var n int
	fmt.Scan(&n)
	p1deck := make(chan string, 1000)
	p2deck := make(chan string, 1000)

	p1deck <- "5C"
	p1deck <- "3D"
	p1deck <- "2C"
	p1deck <- "7D"
	p1deck <- "8C"
	p1deck <- "7S"
	p1deck <- "5D"
	p1deck <- "5H"
	p1deck <- "6D"
	p1deck <- "5S"
	p1deck <- "4D"
	p1deck <- "6H"
	p1deck <- "6S"
	p1deck <- "3C"
	p1deck <- "3S"
	p1deck <- "7C"
	p1deck <- "4S"
	p1deck <- "4H"
	p1deck <- "7H"
	p1deck <- "4C"
	p1deck <- "2H"
	p1deck <- "6C"
	p1deck <- "8D"
	p1deck <- "3H"
	p1deck <- "2D"
	p1deck <- "2S"
	p2deck <- "AC"
	p2deck <- "9H"
	p2deck <- "KH"
	p2deck <- "KC"
	p2deck <- "KD"
	p2deck <- "KS"
	p2deck <- "10S"
	p2deck <- "10D"
	p2deck <- "9S"
	p2deck <- "QD"
	p2deck <- "JS"
	p2deck <- "10H"
	p2deck <- "8S"
	p2deck <- "QH"
	p2deck <- "JD"
	p2deck <- "AD"
	p2deck <- "JC"
	p2deck <- "AS"
	p2deck <- "QS"
	p2deck <- "AH"
	p2deck <- "JH"
	p2deck <- "10C"
	p2deck <- "9C"
	p2deck <- "8H"
	p2deck <- "QC"
	p2deck <- "9D"

	for turn := 1; ; turn++ {
		fmt.Println("turn ", turn-1)
		printChannel(p1deck)
		printChannel(p2deck)
		if winner := battle(p1deck, p2deck); winner != 0 {
			fmt.Println(winner, turn)
			return
		}
		if end, winner := endGame(p1deck, p2deck); end {
			fmt.Println(winner, turn)
			return
		}
	}
}

func battle(p1deck, p2deck chan string) int {
	p1 := <-p1deck
	p2 := <-p2deck

	power1 := parsePower(p1)
	power2 := parsePower(p2)

	if power1 == power2 {
		record1 := make(chan string, 1000)
		record2 := make(chan string, 1000)
		record1 <- p1
		record2 <- p2
		if len(p1deck) < 4 {
			return 2
		}
		if len(p2deck) < 4 {
			return 1
		}
		return war(p1deck, p2deck, record1, record2)
	}
	var winner chan string
	var firstCard, SecondCard string
	if power1 > power2 {
		winner = p1deck
		firstCard = p1
		SecondCard = p2
	} else {
		winner = p2deck
		firstCard = p2
		SecondCard = p1
	}
	winner <- firstCard
	winner <- SecondCard
	return 0
}

func parsePower(str string) int {
	switch str[0] {
	case 'J':
		return 11
	case 'Q':
		return 12
	case 'K':
		return 13
	case 'A':
		return 14
	default:
		return int(str[0] - '0')
	}
}

func endGame(p1deck, p2deck chan string) (bool, int) {
	if len(p1deck) == 0 {
		return true, 2
	}
	if len(p2deck) == 0 {
		return true, 1
	}
	return false, 0
}

func printChannel(c chan string) {
	cc := make(chan string, 1000)
	for len(c) > 0 {
		item := <-c
		fmt.Print(item + " ")
		cc <- item
	}
	fmt.Println()
	for len(cc) > 0 {
		c <- <-cc
	}
}

func war(p1deck, p2deck, p1record, p2record chan string) int {
	for i := 0; i < 3; i++ {
		p1record <- <-p1deck
		p2record <- <-p2deck
	}

	p1 := <-p1deck
	p2 := <-p2deck

	power1 := parsePower(p1)
	power2 := parsePower(p2)
	p1record <- p1
	p2record <- p2

	if power1 == power2 {
		if len(p1deck) < 4 {
			return 2
		}
		if len(p2deck) < 4 {
			return 1
		}
		return war(p1deck, p2deck, p1record, p2record)
	}
	if power1 > power2 {
		for len(p1record) > 0 {
			p1deck <- <-p1record
		}
		for len(p2record) > 0 {
			p1deck <- <-p2record
		}
	} else {
		for len(p2record) > 0 {
			p2deck <- <-p2record
		}
		for len(p1record) > 0 {
			p2deck <- <-p1record
		}
	}
	return 0
}

```

輸出

```
// 前略
turn  6
5D 5H 6D 5S 4D 6H 6S 3C 3S 7C 4S 4H 7H 4C 2H 6C 8D 3H 2D 2S 
10S 10D 9S QD JS 10H 8S QH JD AD JC AS QS AH JH 10C 9C 8H QC 9D AC 5C 9H 3D KH 2C KC 7D KD 8C KS 7S 
turn  7
5H 6D 5S 4D 6H 6S 3C 3S 7C 4S 4H 7H 4C 2H 6C 8D 3H 2D 2S 5D 10S 
10D 9S QD JS 10H 8S QH JD AD JC AS QS AH JH 10C 9C 8H QC 9D AC 5C 9H 3D KH 2C KC 7D KD 8C KS 7S 
// 中略
turn  33
10C 
7D KD 8C KS 7S 9S 6D QD 5S JS 4D 8S 6S QH 3C JD 3S AD 7C JC 4S AS 4H QS 7H AH 4C JH 2H 9C 8D 8H 3H QC 2D 9D 2S AC 5D 5C 10S 9H 5H 3D 10D KH 6H 2C 10H KC 6C 
2 34
```

贏家沒錯，就是多花了幾個回合

逐個檢查發現turn 7的結果是錯的，我只抓第一個字元所以10被判成1去比較了= =，超白癡

修改 parsePower()

```go
func parsePower(str string) int {
	switch str[0] {
	case 'J':
		return 11
	case 'Q':
		return 12
	case 'K':
		return 13
	case 'A':
		return 14
	case '1':
		if len(str) == 3{
			return 10
		}
		return 1
	default:
		return int(str[0] - '0')
	}
}
```

之後除了 PAT 和 Long case 都通過了



看懂了，special cases 裡面有寫pat條件，看太快直接忽略掉了..

> If a player runs out of cards during a "war" (when giving up the three cards or when doing the battle), then the game ends and both players are placed equally first.

還好還算好改，先前把牌不夠出的情形算成對方勝利，現在只要改成PAT就可以了



改完之後還是過不了 long case

```
Failure
Found: 1 130
Expected: 2 1262
```

看到這個結果我就放棄靠人工逐回檢查了

有發現一個之前寫錯的地方就是雙方牌組上限各1000，這樣我應該把channel的 buffer設定成2000才對，不然過程中也有超過1000的可能性

不過測試過不了顯然也不是這個問題，如果超過上限會跳panic而不會得到結果。

沒頭緒就來refactor，`war()`裡面有段邏輯和`battle()`相似，應該可以改成兩個方法互相循環的狀態。

重構完如下

```go
package main

import (
	"fmt"
)

func main() {
	// n: the number of cards for player 1
	var n int
	fmt.Scan(&n)
	var player1, player2 player
	player1.deck = make(chan string, 2000)
	player2.deck = make(chan string, 2000)
	player1.playedRecord = make(chan string, 2000)
	player2.playedRecord = make(chan string, 2000)

	for i := 0; i < n; i++ {
		// cardp1: the n cards of player 1
		var cardp1 string
		fmt.Scan(&cardp1)
		player1.deck <- cardp1
	}
	// m: the number of cards for player 2
	var m int
	fmt.Scan(&m)

	for i := 0; i < m; i++ {
		// cardp2: the m cards of player 2
		var cardp2 string
		fmt.Scan(&cardp2)
		player2.deck <- cardp2
	}

	turn := 1
	for {
		result := battle(&player1, &player2)
		switch result {
		case Player1Win:
			fallthrough
		case Player2Win:
			fmt.Println(result, turn)
			return
		case PAT:
			fmt.Println("PAT")
			return
		}
		if end, result := endGame(player1.deck, player2.deck); end {
			fmt.Println(result, turn)
			return
		}
		turn++
	}
}

type player struct {
	deck         chan string
	playedRecord chan string
}

type battleResult int

const (
	notEnd     battleResult = 0
	Player1Win battleResult = 1
	Player2Win battleResult = 2
	PAT        battleResult = 3
)

func battle(player1, player2 *player) battleResult {
	player1BattleCard := <-player1.deck
	player2BattleCard := <-player2.deck

	power1 := parsePower(player1BattleCard)
	power2 := parsePower(player2BattleCard)
	player1.playedRecord <- player1BattleCard
	player2.playedRecord <- player2BattleCard

	if power1 == power2 {
		if len(player1.deck) < 4 || len(player2.deck) < 4 {
			return 3
		}
		return war(player1, player2)
	}
	if power1 > power2 {
		transferAllContent(player1.playedRecord, player1.deck)
		transferAllContent(player2.playedRecord, player1.deck)
	} else {
		transferAllContent(player2.playedRecord, player2.deck)
		transferAllContent(player1.playedRecord, player2.deck)
	}
	return 0
}

func war(player1, player2 *player) battleResult {
	for i := 0; i < 3; i++ {
		player1.playedRecord <- <-player1.deck
		player2.playedRecord <- <-player2.deck
	}
	return battle(player1, player2)
}

func endGame(player1Deck, player2Deck chan string) (bool, battleResult) {
	if len(player1Deck) == 0 {
		return true, Player2Win
	}
	if len(player2Deck) == 0 {
		return true, Player1Win
	}
	return false, 0
}

func transferAllContent(source, destination chan string) {
	for len(source) != 0 {
		destination <- <-source
	}
}

func parsePower(str string) int {
	switch str[0] {
	case 'J':
		return 11
	case 'Q':
		return 12
	case 'K':
		return 13
	case 'A':
		return 14
	case '1':
		if len(str) == 3 {
			return 10
		}
		return 1
	default:
		return int(str[0] - '0')
	}
}

```

閱讀性確實好了很多，但是原本對的還是對錯的也還是錯。放棄，想不出來了



---

2022/02/08 補充

終於寫出來啦，後來發現題目還是讀錯了

取牌順序這裡

> When a player wins a battle, they put back the cards at the bottom of their deck in a precise order. **First the cards from the first player, then the one from the second player** (for a "war", all the cards from the first player **then** all the cards from the second player).

我最初的理解是獲勝的玩家按照自己的出牌順序取牌，接著按照對手的出牌順序取牌，看到題目的用字"First Player", "Second Player" 覺得有點彆扭但也沒有多想

結果把它當作字面上的意思，First Player = Player1 , Second Player = Player2 就過關了= =

我還自己幫題目追加難度...

```go
	if power1 > power2 {
		transferAllContent(player1.playedRecord, player1.deck)
		transferAllContent(player2.playedRecord, player1.deck)
	} else {
		transferAllContent(player1.playedRecord, player2.deck)
		transferAllContent(player2.playedRecord, player2.deck)
	}
```

只要修正這個部分就可以了



完整如下

```go
package main

import (
	"fmt"
)

func main() {
	// n: the number of cards for player 1
	var n int
	fmt.Scan(&n)
	var player1, player2 player
	player1.deck = make(chan string, 2000)
	player2.deck = make(chan string, 2000)
	player1.playedRecord = make(chan string, 2000)
	player2.playedRecord = make(chan string, 2000)

	for i := 0; i < n; i++ {
		// cardp1: the n cards of player 1
		var cardp1 string
		fmt.Scan(&cardp1)
		player1.deck <- cardp1
	}
	// m: the number of cards for player 2
	var m int
	fmt.Scan(&m)

	for i := 0; i < m; i++ {
		// cardp2: the m cards of player 2
		var cardp2 string
		fmt.Scan(&cardp2)
		player2.deck <- cardp2
	}

	turn := 1
	for {
		result := battle(&player1, &player2)
		switch result {
		case Player1Win:
			fallthrough
		case Player2Win:
			fmt.Println(result, turn)
			return
		case PAT:
			fmt.Println("PAT")
			return
		}
		if end, result := endGame(player1.deck, player2.deck); end {
			fmt.Println(result, turn)
			return
		}
		turn++
	}
}

type player struct {
	deck         chan string
	playedRecord chan string
}

type battleResult int

const (
	notEnd     battleResult = 0
	Player1Win battleResult = 1
	Player2Win battleResult = 2
	PAT        battleResult = 3
)

func battle(player1, player2 *player) battleResult {
	player1BattleCard := <-player1.deck
	player2BattleCard := <-player2.deck

	power1 := parsePower(player1BattleCard)
	power2 := parsePower(player2BattleCard)
	player1.playedRecord <- player1BattleCard
	player2.playedRecord <- player2BattleCard

	if power1 == power2 {
		if len(player1.deck) < 4 || len(player2.deck) < 4 {
			return 3
		}
		return war(player1, player2)
	}
	if power1 > power2 {
		transferAllContent(player1.playedRecord, player1.deck)
		transferAllContent(player2.playedRecord, player1.deck)
	} else {
		transferAllContent(player1.playedRecord, player2.deck)
		transferAllContent(player2.playedRecord, player2.deck)
	}
	return 0
}

func war(player1, player2 *player) battleResult {
	for i := 0; i < 3; i++ {
		player1.playedRecord <- <-player1.deck
		player2.playedRecord <- <-player2.deck
	}
	return battle(player1, player2)
}

func endGame(player1Deck, player2Deck chan string) (bool, battleResult) {
	if len(player1Deck) == 0 {
		return true, Player2Win
	}
	if len(player2Deck) == 0 {
		return true, Player1Win
	}
	return false, 0
}

func transferAllContent(source, destination chan string) {
	for len(source) != 0 {
		destination <- <-source
	}
}

func parsePower(str string) int {
	switch str[0] {
	case 'J':
		return 11
	case 'Q':
		return 12
	case 'K':
		return 13
	case 'A':
		return 14
	case '1':
		if len(str) == 3 {
			return 10
		}
		return 1
	default:
		return int(str[0] - '0')
	}
}

```



## Better Solutions



### Solution 1

```go
package main

import "fmt"
import "os"
/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/

func main() {
    mp := map[string]int{
        "2":0,
        "3":1,
        "4":2,
        "5":3,
        "6":4,
        "7":5,
        "8":6,
        "9":7,
        "10":8,
        "J":9,
        "Q":10,
        "K":11,
        "A":12,
    }

    // n: the number of cards for player 1
    var n int
    fmt.Scan(&n)
    p1 := make([]int,n)
    for i := 0; i < n; i++ {
        var cardp1 string
        fmt.Scan(&cardp1)
        p1[i] = mp[cardp1[:len(cardp1)-1]]
    }

    // m: the number of cards for player 2
    var m int
    fmt.Scan(&m)
    p2 := make([]int,m)

    for i := 0; i < m; i++ {
        var cardp2 string
        fmt.Scan(&cardp2)
        p2[i] = mp[cardp2[:len(cardp2)-1]]
    }
    fmt.Fprintln(os.Stderr, p1,p2)
    rounds := 1
    temp1,temp2 := []int{},[]int{}
    for {
        tc1,tc2 := p1[0],p2[0]
        p1 = p1[1:]
        p2 = p2[1:]
        temp1 = append(temp1,tc1)
        temp2 = append(temp2,tc2)
        if tc1 != tc2 {
            if tc1 > tc2{
                p1 = append(p1, temp1...)
                p1 = append(p1, temp2...)
            }else{
                p2 = append(p2,temp1...)
                p2 = append(p2,temp2...)
            }
            temp1,temp2 = []int{},[]int{}
            if len(p1) == 0 {
                fmt.Println("2",rounds)
                break
            }
            if len(p2) == 0 {
                fmt.Println("1",rounds)
                break
            }
            rounds++
        } else if (len(p1) < 3 || len(p2) < 3) {
            fmt.Println("PAT")
            break    
        } else {
            temp1 = append(temp1, []int{p1[0],p1[1],p1[2]}...)
            temp2 = append(temp2, []int{p2[0],p2[1],p2[2]}...)
            p1 = p1[3:]
            p2 = p2[3:]
        }
    }
}
```



### Solution 2

```go
package main

import "fmt"

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/

func main() {
    
    values := map[string]int {
        "2":1,
        "3":2,
        "4":3,
        "5":4,
        "6":5,
        "7":6,
        "8":7,
        "9":8,
        "10":9,
        "J":10,
        "Q":11,
        "K":12,
        "A":13}
    
    val := func(c string) int {
        if v, ok := values[c]; ok {
            return v
        }
        return 0
    }
    
    // n: the number of cards for player 1
    var n int
    fmt.Scan(&n)
    
    deck1 := make([]string,n)
    for i := 0; i < n; i++ {
        // cardp1: the n cards of player 1
        var cardp1 string
        fmt.Scan(&cardp1)
        deck1[i] = cardp1[:len(cardp1)-1]
    }
    // m: the number of cards for player 2
    var m int
    fmt.Scan(&m)
    
    deck2 := make([]string,m)
    for i := 0; i < m; i++ {
        // cardp2: the m cards of player 2
        var cardp2 string
        fmt.Scan(&cardp2)
        deck2[i] = cardp2[:len(cardp2)-1]
    }
    
    var war1, war2 []string
    var c1, c2 string
    answer := "PAT"
    rounds := 0
    for {
        c1, deck1 = deck1[0], deck1[1:]
        c2, deck2 = deck2[0], deck2[1:]
        
        war1 = append(war1, c1)
        war2 = append(war2, c2)
        
        if val(c1) == val(c2) {
            answer = "PAT"
            if len(deck1) <= 3 || len(deck2) <= 3 {break}
            war1, deck1 = append(war1, deck1[0:3]...), deck1[3:]
            war2, deck2 = append(war2, deck2[0:3]...), deck2[3:]
        } else {
            winner, wId := &deck1, 1
            if val(c1) < val(c2) {winner, wId = &deck2, 2}
            *winner, war1 = append(*winner, war1...), []string{} 
            *winner, war2 = append(*winner, war2...), []string{}
            rounds++
            answer = fmt.Sprintf("%d %d", wId , rounds)
            if len(deck1) == 0 || len(deck2) == 0 {break}
        }
        
    }

    
    // fmt.Fprintln(os.Stderr, "Debug messages...")
    fmt.Println(answer)// Write answer to stdout
}
```

