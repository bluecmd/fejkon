#!/usr/bin/env python3
import sys
import xml.etree.ElementTree as ET

import argparse
import os
import sys

import kconfiglib

def configure(root, instance, enable):
    for i in root.iter('instance'):
        if i.attrib['name'] == instance:
            i.attrib['enabled'] = 'true' if enable else 'false'
            return
    else:
        raise Exception('SignalTap instance "%s" not found in template' % (instance, ))

def main():
    kconf = kconfiglib.Kconfig('Kconfig')
    kconf.load_config()
    tree = ET.parse(sys.argv[1])
    root = tree.getroot()
    for sym in kconf.unique_defined_syms:
        val = sym.str_value
        if sym.orig_type is kconfiglib.BOOL:
            if sym.name.startswith('STP_'):
                configure(root, sym.name[4:].lower(), sym.str_value == "y")
    tree.write('/dev/stdout')


if __name__ == '__main__':
    main()
