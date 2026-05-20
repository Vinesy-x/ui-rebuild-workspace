# Phase A v2 收尾 follow-up · 给 design 的 2 项修订(2026-05-20)

> 上一轮:`BUG_REPORT_PHASE_A.md`(必修 1+2)→ design v2 全修 ✅
> 本轮:不阻塞,但要进 Phase B 之前清干净 canonical 漂移
> 上一轮 design 沙箱:`https://api.anthropic.com/v1/design/h/ifQlvXZGfmG4lFcjAmHI6A`

---

## 把下面整段发给 design

```
Phase A v2 收尾 follow-up,2 项必修:

【必修 1】Phase A · 主菜单 大掌柜.html 真值里 NPC click 未清(4 处)

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

【必修 2】Style Lock · 风格定档.html 字号体系未同步 v3.1

design v2 在 final/README.md + tokens.css 已经把字号升级到 v3.1
(8 档 14-40px,中文最小 16px),但 Style Lock · 风格定档.html 第
466-477 行的"11 档字阶 (v2 · 锁定)"段还是旧版(11 档 10-30px),
跟 tokens.css 当前真值不一致。

要改 Style Lock · 风格定档.html:
- "11 档字阶 (v2 · 锁定)" → "8 档字阶 (v3.1 · 锁定)"
- 11 档对照表删掉,改为 8 档:
  --fs-overlay  40  · UpgradeOverlay 段位大字
  --fs-display  32  · HUD 主数据 / hero / 大数字
  --fs-h1       26  · modal title / 屏标题
  --fs-h2       20  · section / NPC 名 / 卡片标题
  --fs-body     18  · 正文 / list / 价格 (最小)
  --fs-label    17  · tab / button / pill
  --fs-meta     15  · cost / cd / sub-info
  --fs-mono     14  · placeholder 监督
- 顺手在头部加"v3.1 更新说明":中文正文最小 16→18,适合手机阅读

【顺带提】scripts/import-design.sh 用户这边已经修好了

用户自己改了 import-design.sh,加了 4.5 步:rsync 沙箱项目根的
*.html 真值文件到本地仓库根。下次 import 会自动拉到本地,你不用做
任何事。

【完成后】

修完上面 2 项发新 link。

通过后 → 进 Phase B 第 1 屏:T-B1 fps_0001 技能 list (Tab 1)
```

---

## 用户本地已做的事(不用 design 操心)

| 项 | 状态 |
|---|---|
| `scripts/import-design.sh` 加根 html 拉取(4.5 步)| ✅ 已修 |
| `.gitignore` 加 `final/node_modules` + `dist` + `.vite` + `package-lock.json` | ✅ 已加 |

## v2 follow-up 完成后 Phase A 验收态势

| 项 | 状态 |
|---|---|
| Style Lock 风格定档 | ✅ 通过 + 字号同步 v3.1 |
| Vue 工程 npm run dev 可起 | ✅(实测 vite build 通过) |
| 8 共享组件 SFC 全在位 | ✅ |
| Pinia modal store 走通 | ✅ |
| canonical fps_0037 归属对齐(Vue + HTML 真值)| ✅ |
| 6 Phase B 占位 view 全在位 | ✅ |
| viewport 448×960 + 字号 v3.1 中文 ≥16px | ✅ |

→ **Phase A 完全收尾 → 进 Phase B**
