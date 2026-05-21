# {{游戏名}} — 实时进度

> ⚠️ **design 沙箱开工前必拉这一份**(每个 task 都要)。一文知全局:项目快照 + 当前阶段 + 已废清单 + 共享 modal 状态。
>
> raw URL: `https://raw.githubusercontent.com/{{owner}}/{{repo}}/main/projects/{{name}}/handoff/PROGRESS.md`

---

## 📋 项目快照(design 第一眼看这里就知道全局)

| 项 | 值 |
|---|---|
| **游戏** | {{游戏名}}({{类型}})|
| **视觉** | {{风格}} |
| **viewport** | {{宽}}×{{高}} {{竖屏/横屏}} |
| **抽帧** | {{N}} 帧视频(`input/{{视频}}`)|
| **风格定档** | `preview/Style Lock · 风格定档.html` — Phase A 锁定不再变 |
| **工程栈** | Vite + Vue 3(`<script setup>` + TS)+ Pinia + Vue Router |
| **Modal 模式** | N 共享 modal + `useModalStore` + `<ModalShell>` + router.afterEach 自动 reset |
| **完整 KICKOFF** | `projects/{{name}}/handoff/KICKOFF.md`(只 Phase A 首次启动需要)|

文字内容**全部 {{语境}} 化**(详见 Style Lock N 项对照)。

底栏 N Tab(canonical 锁定):{{Tab 列表}}。

---

## 项目元信息(详细)

- **游戏名**:{{游戏名}}
- **类型**:{{类型}}
- **视觉风格**:{{风格}}
- **viewport**:{{宽}}×{{高}} {{竖屏/横屏}}
- **抽帧来源**:{{视频}} → ffmpeg → phash → 已选 {{N}} 张

---

## 当前阶段:{{阶段名}}

| 阶段 | 状态 | 备注 |
|---|---|---|
| Phase A T-A1({{锁定屏帧号}} 主菜单 + 风格定档)| ⏳ | |
| Phase B T-B1({{帧号}} {{Tab 名}})| 待 | |
| Phase B T-B2(...) | 待 | |
| ... | | |

---

## canonical 演进

- **当前版本**:v{{N}}
- **修订记录**:
  - v1:{{...}}
  - v2 校正:{{...}}

## 已知废弃项

| # | 废弃项 | 替代 |
|---|---|---|
| 1 | {{...}} | {{...}} |

---

## 共享 modal 组件清单

| # | 组件 | 用途 | 复用屏 |
|---|---|---|---|
| 1 | {{XxxDialog}} | {{...}} | fps_{{...}} |
| ... | | | |

---

## 视觉真值锁定(Phase A 通过后)

`projects/{{name}}/handoff/preview/`:
- {{HTML 文件清单}}

---

## 工程层(`projects/{{name}}/handoff/final/`)

- ✅ {{stack}}
- `npm install && npm run dev` 可起 / `vite build` 通过
- view 数:{{N}}(已填 {{M}} + 占位 {{N-M}})
- 共享组件:{{N}} 个
- data json:{{N}} 个

---

## bug 跟踪

| # | bug | 状态 | 报告 |
|---|---|---|---|
| | | | bugs/{{xxx}}.md |

**当前无未修 bug** / **N 个待修**

---

## design 沙箱历史 link

| commit | link 短码 | 任务 |
|---|---|---|
| `{{hash}}` | `{{shortcode}}` | {{描述}} |

---

## 下一步

{{当前焦点 + 待启动 task}}
