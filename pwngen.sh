#!/bin/bash

FILENAME="output"
HELP="false"

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
    -h|--help)
    HELP="true"
    ;;
esac
done

if [[ "$HELP" = "true" ]]
then
  echo "USAGE:
    pwngen -f=FILENAME -p=PATH_TO_LOCAL_EXECUTABLE -r=REMOTE_PROCESS -n=REMOTE_PORT_NUMBER"
  exit
fi

# if user includes .py remove it, we'll add it later
FILENAME="${FILENAME%.py}"
FILENAME="${FILENAME}.py"

# These will _almost_ always be relevent
echo "
from pwn import *
from Crypto.Util.number import *

context(arch = 'i386', os = 'linux')
context.log_level = 'debug'
" > ${FILENAME}

# if remote and port given make a tubes
echo "r = remote(\"${REMOTE}\", ${PORT})" >> ${FILENAME}

# if process given redefine r, because you'll probably develop your script
# locally. Comment later when its ready to pwn.
echo "r = process(\"$PROCESS\")" >> ${FILENAME}
echo >> ${FILENAME}

# not useful on their own but I always find myself going to find the names
echo "r.recvuntil(\"\")" >> ${FILENAME}
echo >> ${FILENAME}
echo "r.send(\"\")" >> ${FILENAME}
echo >> ${FILENAME}

echo "r.interactive()" >> ${FILENAME}

cat ${FILENAME}
