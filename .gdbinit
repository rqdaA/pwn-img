define gef
    source /root/.gdbinit-gef.py
end

define dbg
    source ~/pwndbg/gdbinit.py
end

define pwngdb
    source ~/peda/peda.py
    source ~/Pwngdb/pwndbg/pwngdb.py
    source ~/Pwngdb/angelheap/gdbinit.py
    python import angelheap
    python angelheap.init_angelheap()
end

dbg
