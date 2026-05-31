# JoyBridge Friend Testing Guide

This guide is for trusted friends who are testing a local JoyBridge-new build.

JoyBridge-new is currently a local test app. It is not a Mac App Store app and is not notarized by Apple yet, so the first launch may require manual approval in macOS.

## Quick Install

1. Download `JoyBridge-new-v0.10.0-local-test.dmg`.
2. Open the DMG.
3. Drag `JoyBridge-new.app` to the Applications folder.
4. Open `JoyBridge-new.app` from Applications.
5. If macOS says Apple cannot verify JoyBridge-new, click Done.
6. Open System Settings > Privacy & Security.
7. Scroll to Security and click Open Anyway for JoyBridge-new.
8. Open JoyBridge-new again.
9. In JoyBridge-new, click `请求授权/打开设置`.
10. In System Settings > Privacy & Security > Accessibility, enable JoyBridge-new.
11. Return to JoyBridge-new and click `重新检测权限`.

## Controller Setup

1. Connect both left and right Joy-Cons in macOS Bluetooth settings.
2. Open JoyBridge-new.
3. Click `重新检测手柄`.
4. Confirm the controller name appears.
5. Click `锁定当前` so JoyBridge-new only listens to that controller.
6. Open TextEdit and test a few mappings.

Connecting both Joy-Cons is recommended. A single left or right Joy-Con may not expose `L/R/ZL/ZR` correctly through macOS `GameController.framework`.

## What To Test

- The app opens.
- Accessibility permission shows as granted.
- Controller name appears.
- `最近按键` changes when you press Joy-Con buttons.
- Mapped keys appear in TextEdit.
- Long-pressing a button does not repeat continuously.
- Closing the main window keeps JoyBridge-new in the menu bar.
- `暂停映射` stops keyboard output.
- `启用映射` restores keyboard output.

## If Something Fails

Please send:

- macOS version.
- Mac model if known.
- Controller type, for example `Joy-Con (L/R)`.
- Screenshot of the JoyBridge-new main window.
- The text copied by `复制诊断信息`.
- Which button you pressed.
- What you expected to happen.
- What actually happened.

## Known Local-Test Limits

- The app does not start automatically after Mac restart.
- The app must be opened manually before use.
- The app may show a macOS first-open security warning.
- Each Mac must grant Accessibility permission separately.
- This build is intended for trusted local testing only.

---

# JoyBridge 朋友测试说明

这份说明是给信任的朋友测试 JoyBridge-new 本地版使用的。

JoyBridge-new 当前是本地测试 App。它不是 Mac App Store 上架 App，也还没有经过 Apple 公证，所以第一次打开时，macOS 可能需要你手动允许。

## 快速安装

1. 下载 `JoyBridge-new-v0.10.0-local-test.dmg`。
2. 打开 DMG。
3. 把 `JoyBridge-new.app` 拖到“应用程序”文件夹。
4. 从“应用程序”打开 `JoyBridge-new.app`。
5. 如果 macOS 提示 Apple 无法验证 JoyBridge-new，点击“完成”。
6. 打开 系统设置 > 隐私与安全性。
7. 滚动到“安全性”，点击 JoyBridge-new 的“仍要打开”。
8. 再次打开 JoyBridge-new。
9. 在 JoyBridge-new 里点击 `请求授权/打开设置`。
10. 在 系统设置 > 隐私与安全性 > 辅助功能 中启用 JoyBridge-new。
11. 回到 JoyBridge-new，点击 `重新检测权限`。

## 手柄设置

1. 在 macOS 蓝牙设置中同时连接左右 Joy-Con。
2. 打开 JoyBridge-new。
3. 点击 `重新检测手柄`。
4. 确认界面显示手柄名称。
5. 点击 `锁定当前`，让 JoyBridge-new 只监听这个手柄。
6. 打开 TextEdit，测试几个映射。

建议同时连接左右 Joy-Con。只连接单只左手柄或右手柄时，`L/R/ZL/ZR` 可能不会被 macOS 的 `GameController.framework` 正确暴露。

## 建议测试什么

- App 能正常打开。
- 辅助功能权限显示已授权。
- 界面能显示手柄名称。
- 按 Joy-Con 按钮时，`最近按键` 会变化。
- 在 TextEdit 里能看到映射后的键盘输入。
- 长按按钮不会连续疯狂重复。
- 关闭主窗口后，JoyBridge-new 仍留在菜单栏。
- 点击 `暂停映射` 后不会发送键盘输出。
- 点击 `启用映射` 后映射恢复正常。

## 如果遇到问题，请反馈这些信息

- macOS 版本。
- Mac 型号，如果知道的话。
- 手柄类型，例如 `Joy-Con (L/R)`。
- JoyBridge-new 主窗口截图。
- 点击 `复制诊断信息` 后复制出来的文字。
- 你按的是哪个按钮。
- 你希望发生什么。
- 实际发生了什么。

## 当前本地测试限制

- Mac 重启后，JoyBridge-new 不会自动启动。
- 使用前需要手动打开 JoyBridge-new。
- 第一次打开时，macOS 可能显示安全提醒。
- 每台 Mac 都需要单独授权辅助功能权限。
- 这个版本只适合信任朋友之间本地测试。
