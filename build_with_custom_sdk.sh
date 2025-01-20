#!/bin/bash

# Set the correct Android SDK path
export ANDROID_SDK_ROOT=$HOME/android-sdk
export ANDROID_HOME=$HOME/android-sdk

# Optional: Check if the variables are set correctly
echo "ANDROID_SDK_ROOT: $ANDROID_SDK_ROOT"
echo "ANDROID_HOME: $ANDROID_HOME"

# Run the Flutter build command (replace with your desired build command)
flutter build apk

# Optional: Check the exit code of the build command
if [ $? -eq 0 ]; then
  echo "Build successful!"
else
  echo "Build failed!"
fi
