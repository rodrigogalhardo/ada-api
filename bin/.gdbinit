target ext :3333
mon halt

# User interface with asm, regs and cmd windows
define split
    layout split
    layout asm
    layout regs
    focus cmd
end
