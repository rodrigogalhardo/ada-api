CROSS = arm-none-eabi-
FLAGS = -p -m  -Pbuild.gpr -XTARGET=stm32

all :
	$(CROSS)gnatmake $(FLAGS)
clean :
	-rm objs/*
	-rm bin/*
