CROSS = arm-none-eabi-
FLAGS = -p -m  -Pbuild.gpr -XTARGET=stm32

all :
	@mkdir -p bin
	@mkdir -p objs
	$(CROSS)gnatmake $(FLAGS)

doc :
	robodoc --src ./ --doc  ./doc --multidoc --index --html

clean :
	-rm objs/*
	-rm bin/*

clean-doc :
	-rm -rf doc/

openocd :
	sudo openocd -f /usr/share/openocd/scripts/board/stm32f4discovery.cfg
