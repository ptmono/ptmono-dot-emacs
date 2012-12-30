#!/usr/bin/python
# -*- coding:utf-8 -*-

# TODO: We need to a method to create config/auth.el.

import os
import sys
from subprocess import Popen

class Vars:
    compress_dirs = ['cvs', 'etc', 'info', 'elpa', 'etc2', 'font', 'snippets']

class Cmds:
    '''
    '''
    @staticmethod
    def compress():
        """
        Zip the directories.
        """
        results = []
        for d in Vars.compress_dirs:
            if not os.path.exists(d):
                print "There is no %s directory." % d
            else:
                cmd = "tar -zcvf %s.tar.gz %s" % (d, d)
                p = Popen(cmd, shell=True)
                out, err = p.communicate()
                results.append(cmd)

        print "\n"
        print "==================="
        print "We create the files"
        print "==================="
        for result in results:
            print " - %s" % result

    @staticmethod
    def extract():
        # TODO: In nt we has no output
        for d in Vars.compress_dirs:
            filename = "%s.tar.gz" % d
            if not os.path.exists(filename):
                print "There is no %s file." % filename
            else:
                if os.name == 'nt':
                    cmd = "tar zxvfo %s" % filename
                else:
                    cmd = "tar -zxvfo %s" % filename
                p = Popen(cmd, shell=True)
                out, err = p.communicate()

    @staticmethod
    def commitImgs():
        cmd = "svn status imgs_xp |awk '{print $2}' |xargs -I {} svn add {}"
        p = Popen(cmd, shell=True)
        out, err = p.communicate()

    def setPython():
        print "-----------------------------------------------"
        print "-----------------------------------------------"
        print "  For python"
        print "-----------------------------------------------"
        print "-----------------------------------------------"
        print ""
        print "Install"
        print " - python 2.7"
        print " - ipython"
        print " - pyreadline"
        print ""
        print "Edit"
        print "To collect output we have to modify ipyton.bat. Add -u option"
        print "@C:\Python27\python.exe C:\Python27\scripts\ipython.py %* to"
        print "@C:\Python27\python.exe -u C:\Python27\scripts\ipython.py %*"
        print "See more worknote_xp.muse#1102150621"

    @staticmethod
    def gsvn():
        try: msg = sys.argv[2]
        except: msg = 'NoLog'
        


def usage():
    "Print help message."
    print """
Usage: torrent.py command

 commands
  - compress
  - extract
"""


def test():
    Cmds.compress()


# TODO: -h --help
def main():
    try: cmd = sys.argv[1]
    except: cmd = False

    if cmd == "-h" or cmd == "--help":
        return usage()

    if cmd:
        try:
            func = getattr(Cmds, cmd)
        except:
            print "\nERROR: We has no command %s." % cmd
            return

        return func()
    else:
        return usage()


if __name__ == '__main__':
    main()

### pymacs
# http://pypi.python.org/packages/2.6/s/setuptools/setuptools-0.6c11-py2.6.egg#md5=bfa92100bd772d5a213eedd356d64086

# sh setuptools-0.6c9-py2.4.egg --prefix=~
