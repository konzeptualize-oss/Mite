#!/usr/bin/env bash
# One-time setup for building the APK inside GitHub Codespaces (installs Java 21 + Android SDK).
set -e
sudo apt-get update -y && sudo apt-get install -y openjdk-21-jdk unzip
export JAVA_HOME="$(dirname "$(dirname "$(readlink -f "$(which javac)")")")"
export ANDROID_HOME="$HOME/android-sdk"
if [ ! -d "$ANDROID_HOME/cmdline-tools/latest" ]; then
  mkdir -p "$ANDROID_HOME/cmdline-tools"
  curl -fsSL -o /tmp/cmdtools.zip https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip
  unzip -q /tmp/cmdtools.zip -d "$ANDROID_HOME/cmdline-tools"
  mv "$ANDROID_HOME/cmdline-tools/cmdline-tools" "$ANDROID_HOME/cmdline-tools/latest"
fi
yes | "$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager" --licenses >/dev/null || true
"$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager" "platform-tools" "platforms;android-35" "build-tools;35.0.0"
grep -q ANDROID_HOME ~/.bashrc || { echo "export ANDROID_HOME=$ANDROID_HOME" >> ~/.bashrc; echo "export JAVA_HOME=$JAVA_HOME" >> ~/.bashrc; }
echo "Setup done. Close and reopen the terminal, then run: npm run android:add"
