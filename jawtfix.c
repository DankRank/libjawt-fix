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
