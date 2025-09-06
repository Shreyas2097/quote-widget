#!/bin/bash
set -e

echo "Setting up Android development environment..."

# Create android-sdk directory
mkdir -p $HOME/android-sdk

# Download Android Command Line Tools
cd $HOME/android-sdk
wget -q https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
unzip -q commandlinetools-linux-9477386_latest.zip
mkdir -p cmdline-tools/latest
mv cmdline-tools/* cmdline-tools/latest/ 2>/dev/null || true
rmdir cmdline-tools/cmdline-tools 2>/dev/null || true

# Set environment variables
export ANDROID_HOME=$HOME/android-sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools

# Add to bashrc for persistence
echo "export ANDROID_HOME=$HOME/android-sdk" >> $HOME/.bashrc
echo "export PATH=\$PATH:\$ANDROID_HOME/cmdline-tools/latest/bin:\$ANDROID_HOME/platform-tools" >> $HOME/.bashrc

# Accept licenses and install SDK components
yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --licenses
$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.0"

echo "Android SDK setup complete!"

# Install Gradle if not present
if ! command -v gradle &> /dev/null; then
    echo "Installing Gradle..."
    cd $HOME
    wget -q https://services.gradle.org/distributions/gradle-8.2-bin.zip
    unzip -q gradle-8.2-bin.zip
    export PATH=$PATH:$HOME/gradle-8.2/bin
    echo "export PATH=\$PATH:\$HOME/gradle-8.2/bin" >> $HOME/.bashrc
fi

echo "Development environment ready!"
