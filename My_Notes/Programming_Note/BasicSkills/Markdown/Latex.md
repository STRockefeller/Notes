# Latex

#markdown #latex

## Windows Packages

[using a package](https://latex-tutorial.com/tutorials/packages/)

typora 可以渲染常見的 Latex 內容。不過有些東西還是必須安裝package 才能

<https://miktex.org/download>

這個東西可以幫你自動安裝有用到的package 很是方便，不過可惜的是typora依然無法渲染，要用他自己的editor

用 R Markdown 似乎可以渲染， 不知道還有沒有比較簡單的方法。有找到再來補充。

## Tree

<https://tex.stackexchange.com/questions/5447/how-can-i-draw-simple-trees-in-latex>

```latex
\documentclass{article}
\usepackage{dirtree}
\begin{document}

\dirtree{%
.1 debug.
.2 filename.
.2 modules.
.3 module.
.3 module.
.3 module.
.2 level.
}

\end{document}
```

![](https://i.imgur.com/rEfiPtT.png)

```latex
\documentclass[tikz,border=10pt]{standalone}
\usepackage[linguistics]{forest}
\begin{document}
\begin{forest}
  [IP
    [NP
     [Det
       [\textit{the}]
     ]
     [N$'$
       [N
         [\textit{package}]
       ]
     ]
    ]
    [I$'$
      [I
        [\textsc{3sg.Pres}
        ]
      ]
      [VP
        [V$'$
          [V
            [\textit{is}]
          ]
          [AP
            [Deg
              [\textit{extremely}]
            ]
            [A$'$
              [A
                [\textit{straightforward}]
              ]
              [CP
                [\textit{to wield}, roof]
              ]
            ]
          ]
        ]
      ]
    ]
  ]
\end{forest}
\end{document}
```

![](https://i.imgur.com/fhx9ui3.png)

## Chess Board

雖然用unicode也可以，不過latex還是好看很多，而且比較方便。

```
♖♘♗♔♕♗♘♖
♙♙♙♙♙♙♙♙




♟♟♟♟♟♟♟♟
♜♞♝♚♛♝♞♜
```

<https://www.overleaf.com/learn/latex/Chess_notation>

```lat
\documentclass{article}
% Note: you only need to load xskak,
% not the skak or chessboard packages.
\usepackage{xskak}
\begin{document}
% This \chessboard command draws 
% an empty chess board: the option
% showmover=false will be discussed
% later in the article
\chessboard[showmover=false]
% The \newchessgame command 
% initializes a new game:
\newchessgame
% Because a new game was initialized, 
% \chessboard now draws a 
% board with chess pieces:
\chessboard
The small white square to the right of the second board is called the \textit{mover}.
\end{document}
```

![](https://i.imgur.com/vhn5Nka.png)

渲染出來有一點點跑版的感覺

```latex
\documentclass{article}
\usepackage{xskak}
\begin{document}
\newchessgame
\mainline{1.e4 e5 2.Nf3 Nc6 3.Bb5 a6}
\showboard % A skak package command. Future examples will use \chessboard[...]
\end{document}
```

![](https://i.imgur.com/NqW0mih.png)

可以直接用棋譜渲染，讚。

可以來個經典的 queen's gambit

```latex
\documentclass{article}
\usepackage{xskak}
\begin{document}
\newchessgame
\mainline{1.d4 d5 2.c4 dxc4 3.Nf3 Nf6 4.e3 e6 5.Bxc4 c5}
\showboard
\end{document}
```

![](https://i.imgur.com/MIdFmRV.png)

```latex
\documentclass{article}
\usepackage{xskak}
\begin{document}
\storechessboardstyle{4x16}{%
  maxfield=d16,
  borderwidth=1mm,
  color=white,
  colorwhitebackfields,
  color=black,
  colorblackbackfields,
  blackfieldmaskcolor=black,
  whitepiececolor=yellow,
  whitepiecemaskcolor=red,
  blackpiececolor=cyan,
  blackpiecemaskcolor=blue,
  addfontcolors,
  pgfstyle=border,
  color=white,
  markregion=a1-d16,
  showmover=false,
  hlabelwidth=18pt,
  vlabellift=16pt}
  \chessboard[
    style=4x16,
    setpieces={Qa8,Qb4,Qc1,Qd3,Qb16,Qc12,Qa7,Qc15,qa1,qb14,qc11,qd13,qb6,qc2,qa4,qc5},
    padding=1ex,
  ]
\end{document}
```

![](https://i.imgur.com/WT35prL.png)

也可以自訂棋盤
