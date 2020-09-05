#!/usr/bin/env python3
import kconfiglib

def main():
    kconf = kconfiglib.Kconfig("Kconfig")
    kconf.load_config()

    for sym in kconf.unique_defined_syms:
        val = sym.str_value
        if sym.orig_type is kconfiglib.BOOL:
            print("set {}{} {}\n".format(kconf.config_prefix, sym.name, val))
        if sym.orig_type is kconfiglib.STRING:
            print("set {}{} \"{}\"\n".format(kconf.config_prefix, sym.name, val))


if __name__ == "__main__":
    main()
