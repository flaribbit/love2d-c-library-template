CC=gcc

test.dll: test.c
	$(CC) -I include -shared test.c lua51.dll -o test.dll
