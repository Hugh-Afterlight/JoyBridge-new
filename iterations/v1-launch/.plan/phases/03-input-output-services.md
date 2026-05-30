# Phase 03 · input-output-services

Status: pending

## Goal

解耦手柄输入、目标过滤、映射执行、键盘输出和权限检查，让输入链路按 ARCHITECTURE 中的边界运行。

## Tasks

- [ ] 定义标准化 Controller input event。
- [ ] 抽出 TargetController 过滤规则。
- [ ] 让 Controller 输入层不直接调用 MappingManager 或 KeyboardEventSender。
- [ ] 抽出 MappingService，负责从 ControllerButton 得到 MappingAction。
- [ ] 抽出 KeyboardOutputService，负责 CGEvent 输出。
- [ ] 保证 Accessibility 未授权、映射暂停、映射禁用、无动作都不会输出键盘事件。
- [ ] 保证 modifier hold 在暂停、退出、映射变更时释放。

## Acceptance

- 锁定目标后只接受目标手柄输入。
- 目标手柄不在线时不自动切换到其他手柄。
- 暂停时最近按键仍更新，但键盘事件不发送。
- 退出前释放已按下 modifier。
- 核心服务边界有测试或可观察验证。

## Notes

GameController 的硬件兼容限制只诊断，不承诺修复所有设备差异。
