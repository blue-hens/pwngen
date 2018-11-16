#!/bin/bash
for i in "$@"
do
case $i in
    -p=*|--process)
    PROCESS="${i#*=}"
    ;;
    -r=*|--remote=*)
    REMOTE="${i#*=}"
    ;;
    -n=*|--port=*)
    PORT="${i#*=}"
    ;;
    -f=*|--filename=*)
    FILENAME="${i#*=}"
    ;;
esac
done

echo ${PROCESS}
FILENAME="output"
rm ${FILENAME}.py

# These will _almost_ always be relevent
echo "
from pwn import *
from Crypto.Util.number import *

context(arch = 'i386', os = 'linux')
context.log_level = 'debug'
" >> ${FILENAME}.py

# if remote and port given make a tubes
echo "r = remote(\"${REMOTE}\", ${PORT})" >> ${FILENAME}.py

# if process given redefine r, because you'll probably develop your script
# locally. Comment later when its ready to pwn.
echo "r = process(\"$PROCESS\")" >> ${FILENAME}.py

# not useful on their own but I always find myself going to find the names
echo "r.recvuntil(\"\")" >> ${FILENAME}.py
echo "r.send(\"\")" >> ${FILENAME}.py

echo "r.interactive()" >> ${FILENAME}.py

cat ${FILENAME}.py
