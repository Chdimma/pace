#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive
export PATH="$HOME/flutter/bin:$PATH"

if [ ! -x "$HOME/flutter/bin/flutter" ]; then
  git clone https://github.com/flutter/flutter.git --depth 1 -b stable "$HOME/flutter"
fi

flutter --version
flutter config --enable-web
flutter precache --web
flutter pub get
flutter build web --release

if [ ! -d build/web ]; then
  echo "Flutter web build output was not created." >&2
  exit 1
fi
