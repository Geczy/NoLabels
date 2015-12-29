include $(THEOS)/makefiles/common.mk

TWEAK_NAME = NoLabels
NoLabels_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += nolabels
include $(THEOS_MAKE_PATH)/aggregate.mk
