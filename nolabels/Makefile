include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = NoLabels
NoLabels_FILES = NBLRootListController.m
NoLabels_INSTALL_PATH = /Library/PreferenceBundles
NoLabels_FRAMEWORKS = UIKit
NoLabels_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/NoLabels.plist$(ECHO_END)
