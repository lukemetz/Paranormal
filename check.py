#!/usr/bin/env python

import commands
import subprocess
import sys
from tools.check_tidy import check_tidy

def tidy():
    err = check_tidy()
    return err

def build():
    build_command = "xcodebuild -project Paranormal/Paranormal.xcodeproj/ -scheme Paranormal"
    err = run(build_command)
    return err

def tests():
    test_command = 'xcodebuild -project Paranormal/Paranormal.xcodeproj/ -scheme Paranormal test'
    err = run(test_command)
    return err

def run_check(check):
    print colors.OKBLUE + 'Running ' + check.__name__ + colors.ENDC
    exit_code = check()
    if exit_code is 0:
        print colors.OKGREEN + check.__name__ + ' succeeded!\n' + colors.ENDC
    else:
        print (colors.FAIL + check.__name__ + ' failed with exit code ' + str(exit_code)
            + '. Aborting.\n' + colors.ENDC)
    return exit_code

def run(command):
    try:
        return subprocess.Popen(command.split(' ')).wait()
    except:
        print "exception raised running command: \n" + command
        raise

all_checks = [
    tidy,
    build,
    tests,
    ]

class colors:
    HEADER = '\033[96m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'

if __name__ == "__main__":
    successes = []
    for check in all_checks:
        if run_check(check) is 0:
            successes.append(True)
        else:
            sys.exit(1)

    print colors.OKBLUE + "Summary:" + colors.ENDC
    print '\n'.join([
        colors.OKGREEN + all_checks[i].__name__ + ": succeeded" + colors.ENDC if success
        else colors.FAIL + all_checks[i].__name__ + ": FAILED" + colors.ENDC
        for i, success in enumerate(successes)])

    if all(s == 0 for s in successes):
        sys.exit(0)
    else:
        sys.exit(1)
