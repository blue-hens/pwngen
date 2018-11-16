filename="output"
rm $filename.py

# These will _almost_ always be relevent
echo "
from pwn import *
from Crypto.Util.number import *

context(arch = 'i386', os = 'linux')
context.log_level = 'debug'
" >> $filename.py

# if remote and port given make a tubes
echo "r = remote($remote, $port)" >> $filename.py

# if process given redefine r, because you'll probably develop your script
# locally. Comment later when its ready to pwn.
echo "r = process($executable)" >> $filename.py

# not useful on their own but I always find myself going to find the names
echo "r.recvuntil(\"\")" >> $filename.py
echo "r.send(\"\")" >> $filename.py

echo "r.interactive()"
