#!/usr/bin/env bash
# Run once after `npx cap add android`: permissions, notification icon, app icons.
set -e
M=android/app/src/main/AndroidManifest.xml
[ -f "$M" ] || { echo "Run 'npx cap add android' first"; exit 1; }
if ! grep -q "android.permission.CAMERA" "$M"; then
  PERMS='    <uses-permission android:name="android.permission.CAMERA" />
    <uses-permission android:name="android.permission.RECORD_AUDIO" />
    <uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
    <uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
    <uses-permission android:name="android.permission.VIBRATE" />
    <uses-feature android:name="android.hardware.camera" android:required="false" />
    <queries><intent><action android:name="android.speech.RecognitionService" /></intent></queries>'
  python3 - "$M" "$PERMS" <<'PY'
import sys
p,perms=sys.argv[1],sys.argv[2]
s=open(p).read(); s=s.replace('<application',perms+'\n    <application',1); open(p,'w').write(s)
PY
  echo "Permissions added."
fi
[ -n "$ANDROID_HOME" ] && echo "sdk.dir=$ANDROID_HOME" > android/local.properties
mkdir -p android/app/src/main/res/drawable
cp assets/ic_stat_notes.png android/app/src/main/res/drawable/ic_stat_notes.png
npx capacitor-assets generate --android --assetPath assets || echo "(icon generation skipped)"
