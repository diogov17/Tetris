CC=ghc
CFLAGS=-Wall -O2

tetris: Tetris.hs
	ghc $(CFLAGS) -o tetris Tetris.hs
	
comment:
	haddock Tetris.hs

clear:
	rm -f tetris.exe tetris Tetris.hi Tetris.o Rotate.hi Rotate.o Types.hi Types.o SinglePlayer.hi SinglePlayer.o MultiPlayer.hi MultiPlayer.o Menu.hi Menu.o 