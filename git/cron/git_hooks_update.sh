#!/bin/sh

# Can execute only ROOT
if [ "`id -un`" != "root" ]
then
	echo "Please change to root."
	exit 1
fi

# work directory
GIT_WORK_DIR=Soft-Patch-Panel_tools
GIT_COPY_DIR=.git_template
TARGET_USER_NAME=tx_*

# git clone
cd /tmp
git clone https://github.com/ntt-ns/Soft-Patch-Panel_tools.git
RET=${?}
if [ ${RET} -ne 0 ]
then
	rm -rf /tmp/${GIT_WORK_DIR}
	exit ${RET}
fi

# Change mode
find /tmp/${GIT_WORK_DIR}/git/${GIT_COPY_DIR} -type f | while read COPY_FILE
do
	chmod 755 ${COPY_FILE}
done

# Copy to user's directory
ls -1d /home/${TARGET_USER_NAME} | while read SETTING_USER
do
	DEST_USER=`basename ${SETTING_USER}`
	cp -rp /tmp/${GIT_WORK_DIR}/git/${GIT_COPY_DIR} ${SETTING_USER}/.
	chown -R ${DEST_USER}:tx_group ${SETTING_USER}/${GIT_COPY_DIR}
done

# Copy to user's clone directory
find /home/${TARGET_USER_NAME} -name ".git" -type d | while read GIT_CLONE_DIR
do
	DEST_USER=`echo ${GIT_CLONE_DIR} | sed -e "s#^/home/##" -e "s#/.*##"`
	cp -rp /tmp/${GIT_WORK_DIR}/git/${GIT_COPY_DIR}/hooks ${GIT_CLONE_DIR}
	chown -R ${DEST_USER}:tx_group ${GIT_CLONE_DIR}/hooks
done

# End
rm -rf /tmp/${GIT_WORK_DIR}
