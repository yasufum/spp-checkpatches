#!/bin/sh

# Can execute only ROOT
if [ "`id -un`" != "root" ]
then
	echo "Please change to root."
	exit 1
fi

# work directory
GIT_WORK_DIR=Soft-Patch-Panel_tools
GIT_COPY_DIR=git/.git_template

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
find /tmp/${GIT_WORK_DIR}/${GIT_COPY_DIR} -type f | while read COPY_FILE
do
	chmod 755 ${COPY_FILE}
done

# Copy to user's directory
ls -1d /home/tx_* | while read SETTING_USER
do
	cp -rp /tmp/${GIT_WORK_DIR}/${GIT_COPY_DIR} ${SETTING_USER}/.
done
rm -rf /tmp/${GIT_WORK_DIR}
