# Exports
---
the kernel will modify _G with mutiple functions and values on boot. 

this may include librarys, syscalls, and general data.

---
exports

    _G
        _G -- _G contains itself indefenitly
        kernel{}
        os{}
        io{}
        fs{}
        term{}
        debug{}
