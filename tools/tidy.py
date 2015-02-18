import commands
import fileinput
import os.path
import sys
import re

def tidy():
    filenames = (commands.getoutput(
        "find . "
        "-path ./Paranormal/libs -prune "
        "-o -name '*.swift' "
        "-o -name '*.fsh' "
        "-o -name '*.h' "
        "-o -name '*.py' "
        ).split('\n'))

    for filename in filenames:
        if os.path.isfile(filename):
            filelines = fileinput.input(filename, inplace=1)
            for line in filelines:
                line = re.sub('[ \t]+$', '', line)
                sys.stdout.write(line)

if __name__ == '__main__':
    tidy()
