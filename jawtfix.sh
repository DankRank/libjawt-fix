#!/bin/sh
set -eu
[ -f "$HOME/.local/lib/jawtfix.so" ] || {
cat >/tmp/$$.c <<EOF
#include <dlfcn.h>
unsigned char JAWT_GetAWT(void *env, void *awt)
{
	static unsigned char (*orig)(void *env, void *awt) = 0;
	if (!orig) {
		void *mod = dlopen("libjawt.so", RTLD_NOW|RTLD_NOLOAD);
		if (!mod)
			return 0;
		*(void**)&orig = dlsym(mod, "JAWT_GetAWT");
		dlclose(mod);
		if (!orig)
			return 0;
	}
	return orig(env, awt);
}
EOF
cat >/tmp/$$.map <<EOF
SUNWprivate_1.1 {
	global: JAWT_GetAWT;
	local: *;
};
EOF
mkdir -p "$HOME/.local/lib"
${CC:-gcc} -O2 -Wall -Wextra -Wl,--version-script=/tmp/$$.map -fpic -shared -o "$HOME/.local/lib/jawtfix.so" /tmp/$$.c
}
LD_PRELOAD="$HOME/.local/lib/jawtfix.so" exec "$@"
