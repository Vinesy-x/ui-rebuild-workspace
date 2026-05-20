# Phase A v2 收尾 follow-up · 给 design 的 1 项修订(2026-05-20 修订)

> 上一轮:`BUG_REPORT_PHASE_A.md`(必修 1+2)→ design v2 全修 ✅
> 本轮:不阻塞,但要进 Phase B 之前清干净 canonical 漂移
> 上一轮 design 沙箱:`https://api.anthropic.com/v1/design/h/ifQlvXZGfmG4lFcjAmHI6A`

> ⚠️ **本文档历史修订记录**:
> - 第 1 版包含 2 项必修(NPC click 未清 + Style Lock 字号未同步)
> - 修订后发现 **Style Lock 字号已经在 design v2 同步到 v3.1**(`8 档 · v3.1 · 锁定`),只是 `scripts/import-design.sh` 旧版没拉根 HTML 真值,我本地是手动 cp 的早期 v1 → 误以为没同步
> - 修脚本后重跑 import,Style Lock v3.1 + tokens.css 动效 token(`--dur-*` + `--ease-*` + `@keyframes`)一并拉到本地
> - **必修 2 作废,只留必修 1**

---

## 把下面整段发给 design

```
Phase A v2 收尾 follow-up,1 项必修:

【必修】Phase A · 主菜单 大掌柜.html 真值里 NPC click 未清(4 处)

final/ Vue 工程已经按 v2 canonical 修了(NPC 改纯装饰,见
MainMenu.vue L67-71 + 注释"canonical v2: 不再 click → npc-req"),
但项目根的 HTML 真值文件 Phase A · 主菜单 大掌柜.html 还有旧的
NPC click → npc-req modal 入口,Phase B 接下去如果以 HTML 当真值
参考会重新引入这个被废的入口。

要改的 4 处(都在 Phase A · 主菜单 大掌柜.html):
- L1455: <div class="npcs" data-act="open:npc-req">
  → <div class="npcs">  (删 data-act)
  + 加注释: <!-- NPC 装饰 · canonical v2: 不再 click → npc-req -->
- L1592: 'npc-req': { ... }
  → 整个 modal 定义删掉
- L1853: 'npc-req':'npc-req',
  → 删整行
- L1874: document.querySelector('.npcs').addEventListener('click',
    () => openModal('npc-req'));
  → 删整行 JS listener

【已确认 design v2 做完的项 ✅】

- Style Lock · 风格定档.html 字号已同步 v3.1(8 档 14-40px,
  中文最小 18px),用户最初以为没同步是脚本 bug,现已澄清。
- tokens.css 加了 motion 体系(--dur-instant/fast/base/modal/slow +
  --ease-out/in/soft/pop + @keyframes utility)— 极好。

【顺带告知】scripts/import-design.sh 已修

用户这边修了 import-design.sh,加 step 4.5 自动 rsync 沙箱项目根
*.html 真值文件到本地。下次 import 你不用做任何事,根 html 也会
自动拉到本地。

【完成后】

修完 1 项必修发新 link。

通过后 → 进 Phase B 第 1 屏:T-B1 fps_0001 技能 list (Tab 1)
```

---

## 用户本地已做的事(不用 design 操心)

| 项 | 状态 |
|---|---|
| `scripts/import-design.sh` 加根 html 拉取(4.5 步)| ✅ 已修 |
| `.gitignore` 加 `final/node_modules` + `dist` + `.vite` + `package-lock.json` | ✅ 已加 |

## Follow-up 完成后 Phase A 验收态势

| 项 | 状态 |
|---|---|
| Style Lock 风格定档(8 档 v3.1)| ✅ design v2 已做(本轮 import 修脚本后拉到)|
| tokens.css motion 体系 | ✅ design v2 新增(本轮拉到)|
| Vue 工程 npm run dev 可起 | ✅(实测 vite build 通过) |
| 8 共享组件 SFC 全在位 | ✅ |
| Pinia modal store 走通 | ✅ |
| canonical fps_0037 归属 — Vue 层 | ✅ |
| canonical fps_0037 归属 — HTML 真值层 | ⚠️ 本 follow-up 必修(NPC click 未清)|
| 6 Phase B 占位 view 全在位 | ✅ |
| viewport 448×960 + 字号 v3.1 中文 ≥18px | ✅ |

→ **修完 1 项必修 → Phase A 完全收尾 → 进 Phase B**
