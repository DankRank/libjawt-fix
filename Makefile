.PHONY: all clean
all: jawtfix.so
clean:
	$(RM) jawtfix.so
jawtfix.so: jawtfix.c mapfile
	$(CC) -O2 -Wall -Wextra -Wl,--version-script=mapfile -fpic -shared -o jawtfix.so jawtfix.c
