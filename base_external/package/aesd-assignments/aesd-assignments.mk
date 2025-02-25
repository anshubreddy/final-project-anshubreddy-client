
##############################################################
#
# AESD-ASSIGNMENTS
#
##############################################################

#TODO: Fill up the contents below in order to reference your assignment 3 git contents
AESD_ASSIGNMENTS_VERSION = '74803ab918904f5c66010f202c87c474664cbf0a'
# Note: Be sure to reference the *ssh* repository URL here (not https) to work properly
# with ssh keys and the automated build/test system.
# Your site should start with git@github.com:
AESD_ASSIGNMENTS_SITE = 'git@github.com:anshubreddy/final-project-anshubreddy-hw.git'
AESD_ASSIGNMENTS_SITE_METHOD = git
AESD_ASSIGNMENTS_GIT_SUBMODULES = YES

define AESD_ASSIGNMENTS_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)/bme280_sensor all
        $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)/zigbee/zigbee_send all
endef

# TODO add the BME280 sensor utilities/scripts to the installation steps below
define AESD_ASSIGNMENTS_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 $(@D)/bme280_sensor/bme280 $(TARGET_DIR)/usr/bin
        $(INSTALL) -m 0755 $(@D)/zigbee/zigbee_send/zigbee_send $(TARGET_DIR)/usr/bin
endef

$(eval $(generic-package))
