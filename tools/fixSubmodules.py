# Changes cocos2d-swift submodules as travis is unhappy with https://
f = open("Paranormal/libs/cocos2d-swift/.gitmodules", 'rb+')
contents = f.read()
f.close()
contents = contents.replace("https://", "git://")

f = open("Paranormal/libs/cocos2d-swift/.gitmodules", 'w+')
f.write(contents)
