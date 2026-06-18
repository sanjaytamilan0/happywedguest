#!/bin/bash

# Digital Template
cp -r lib/templates/basic_template lib/templates/digital_template
cd lib/templates/digital_template

# Rename classes in files
sed -i '' 's/DigitalInvitationApp/DigitalThemeApp/g' *.dart
sed -i '' 's/InvitationScreen/DigitalInvitationScreen/g' *.dart
sed -i '' 's/ReceptionScreen/DigitalReceptionScreen/g' *.dart
sed -i '' 's/WeddingScreen/DigitalWeddingScreen/g' *.dart
sed -i '' 's/_InvitationScreenState/_DigitalInvitationScreenState/g' *.dart
sed -i '' 's/_ReceptionScreenState/_DigitalReceptionScreenState/g' *.dart
sed -i '' 's/_WeddingScreenState/_DigitalWeddingScreenState/g' *.dart

cd ../../..

# Advance Template
cp -r lib/templates/basic_template lib/templates/advance_template
cd lib/templates/advance_template

# Rename classes in files
sed -i '' 's/DigitalInvitationApp/AdvanceThemeApp/g' *.dart
sed -i '' 's/InvitationScreen/AdvanceInvitationScreen/g' *.dart
sed -i '' 's/ReceptionScreen/AdvanceReceptionScreen/g' *.dart
sed -i '' 's/WeddingScreen/AdvanceWeddingScreen/g' *.dart
sed -i '' 's/_InvitationScreenState/_AdvanceInvitationScreenState/g' *.dart
sed -i '' 's/_ReceptionScreenState/_AdvanceReceptionScreenState/g' *.dart
sed -i '' 's/_WeddingScreenState/_AdvanceWeddingScreenState/g' *.dart

cd ../../..

echo "Done"
