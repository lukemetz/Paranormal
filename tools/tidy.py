import commands

def tidy():
    tidy_command = "LC_CTYPE=C find . -type f -not -path '*/\.*' -exec sed -i '' 's/[ \t]*$//' {} \;"
    commands.getoutput(tidy_command)

if __name__ == '__main__':
    tidy()
