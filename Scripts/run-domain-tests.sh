#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BUILD_DIR="$ROOT_DIR/build/domain-tests"
BINARY="$BUILD_DIR/DomainMappingTests"

mkdir -p "$BUILD_DIR"

swiftc \
  "$ROOT_DIR/JoyBridge/Models/ControllerButton.swift" \
  "$ROOT_DIR/JoyBridge/Models/ControllerDeviceFamily.swift" \
  "$ROOT_DIR/JoyBridge/Models/ControllerInputEvent.swift" \
  "$ROOT_DIR/JoyBridge/Models/KeyboardKey.swift" \
  "$ROOT_DIR/JoyBridge/Models/KeyModifier.swift" \
  "$ROOT_DIR/JoyBridge/Models/MappingAction.swift" \
  "$ROOT_DIR/JoyBridge/Models/KeyMapping.swift" \
  "$ROOT_DIR/JoyBridge/Models/MappingCatalog.swift" \
  "$ROOT_DIR/JoyBridge/Models/MappingProfile.swift" \
  "$ROOT_DIR/JoyBridge/Models/RuntimeState.swift" \
  "$ROOT_DIR/JoyBridge/Diagnostics/DiagnosticReport.swift" \
  "$ROOT_DIR/JoyBridge/Persistence/MappingStore.swift" \
  "$ROOT_DIR/JoyBridge/Persistence/UserDefaultsMappingStore.swift" \
  "$ROOT_DIR/JoyBridge/Utilities/KeyboardEventSender.swift" \
  "$ROOT_DIR/JoyBridge/Services/AccessibilityPermissionProviding.swift" \
  "$ROOT_DIR/JoyBridge/Services/ControllerInputHandling.swift" \
  "$ROOT_DIR/JoyBridge/Services/KeyboardOutputService.swift" \
  "$ROOT_DIR/JoyBridge/Services/MappingService.swift" \
  "$ROOT_DIR/JoyBridge/Services/TargetControllerRule.swift" \
  "$ROOT_DIR/JoyBridge/Managers/MappingManager.swift" \
  "$ROOT_DIR/Tests/DomainMappingTests.swift" \
  -o "$BINARY"

"$BINARY"
