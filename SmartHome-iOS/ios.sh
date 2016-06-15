#!/bin/bash

echo "iOS Shell script start."

SCHEME_NAME=SmartHome
WORKSPACE=SmartHome.xcworkspace
PROFILE_NAME='XC Ad Hoc: *'
CERT_NAME='iPhone Distribution: TianHua Pan (8STA58M6SG)'


TIME_STAMP=`date "+%Y%m%d%H"`
BUILD_TIME=$(date +%Y%m%d%H%M)
ArchivePath=build/${SCHEME_NAME}.xcarchive
PacketName=build/${SCHEME_NAME}_${BUILD_TIME}.ipa

#remove all existed build and report
#pod install --no-repo-update
rm -rf build/*
rm -rf report/*

# clean
xctool -workspace ${WORKSPACE} -scheme ${SCHEME_NAME} -configuration Release clean build

#archive
xctool -workspace ${WORKSPACE} -scheme ${SCHEME_NAME} archive -archivePath ${ArchivePath} -CodeSigningIdentity="${CERT_NAME}"

#export
xcodebuild -exportArchive -exportFormat IPA -archivePath ${ArchivePath} -exportPath ${PacketName} -exportProvisioningProfile "${PROFILE_NAME}"

#Unittest and report
#xctool -workspace ${WORKSPACE} -scheme ${SCHEME_NAME} test -test-sdk iphonesimulator9.3 -reporter junit:report/unittest_report.xml

echo "iOS Shell script end."


