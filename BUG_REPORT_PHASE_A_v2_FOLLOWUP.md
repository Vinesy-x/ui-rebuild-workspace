# Phase A · v2 验收 + 1 项 follow-up bug

> 验收时间:2026-05-20
> 验收人:用户 + Claude
> design 沙箱:`https://api.anthropic.com/v1/design/h/ifQlvXZGfmG4lFcjAmHI6A`
> 上一轮 bug 报告:`BUG_REPORT_PHASE_A.md`

---

## ✅ v2 必修 1+2 全部修了

### 必修 1(Vue scoped style)全修 ✓
11 Vue 文件全部有完整 `<style scoped>`,行数:
- `MainMenu.vue` **720 行**
- `JobDetailModal.vue` **227 行**(新增)
- `HudBar.vue` **167 行**
- `ProgressListDialog.vue` 86 行
- `ModalShell.vue` 83 行
- `BottomTabBar.vue` 64 行
- `JobPromoSplash.vue` 38 行
- `AsyncWaitModal.vue` 36 行
- `App.vue` 27 行
- `PurchaseConfirmModal.vue` 25 行
- `UpgradeOverlay.vue` 24 行
- `OptionPickerModal.vue` 22 行
- `CinematicScene.vue` 11 行
- 6 个 Phase B 占位 view 各 2 行(占位级)

`npm install && npm run dev` 现在可起。

### 必修 2(fps_0037 归属)全修 ✓
- `MainMenu.vue` L67-71:NPC 改为纯装饰(`aria-hidden="true"`,无 `@click`),注释明确"canonical v2: 不再 click → npc-req modal"
- `mainMenu.json`:`npcJobRequirement` 字段删,`_notes` 加 v2 校正说明
- `useModalStore.ts`:`'npc-req'` modal name 删
- **新增** `JobDetailModal.vue`(共享组件之 8,canonical 建议已落实):props `{ jobKey, requirements[] }`,覆盖 0037 焊工 / 0040 汽车修理工 / 后续所有工种

### 顺带升级 ✓(超出我的 bug 要求)
- Vite 工程 boot 完整(`index.html` / `package.json` / `tsconfig.json` / `vite.config.ts` / `main.ts` / `App.vue`)
- 6 个 Phase B 占位 view 全部创建
- Modal 尺寸 3 档锁定(`.modal--sm 420 / md 560 / lg 740`,锚点 `top 64px + left/right 16px`)
- **字号体系 v3.1 升级 8 档**(14-40px,中文最小 16px,旧 11 档 10-30px)— 更适合手机阅读

---

## ⚠️ Follow-up 1 项(不阻塞 Phase B 启动,顺手清)

### `Phase A · 主菜单 大掌柜.html` 真值文件里 NPC click → npc-req 还在(4 处)

`final/` Vue 工程已经修对了(NPC 纯装饰),但 design 沙箱根目录的 HTML 真值文件 `Phase A · 主菜单 大掌柜.html` 还有旧的 NPC 互动代码:

- **L1455**:`<div class="npcs" data-act="open:npc-req">`
- **L1592**:`'npc-req': { ... }`(modal 定义还在)
- **L1853**:`'npc-req':'npc-req',`(路由表项)
- **L1874**:`document.querySelector('.npcs').addEventListener('click', () => openModal('npc-req'));`(JS 绑定)

### 影响
Phase B 实做时如果以 HTML 原型当真值参考(实际操作中会经常这样,因为 inline css 全在 HTML),会重新引入这个被废的入口,跟 Vue 工程不一致。

### 期望修
1. L1455:`<div class="npcs">`(删 `data-act`)
2. L1592:删 `'npc-req': { ... }` 整个 modal 定义
3. L1853:删 `'npc-req':'npc-req',` 路由表项
4. L1874:删整行 NPC 点击 listener
5. 顺手加一行 v2 注释 `<!-- NPC 装饰 · canonical v2: 不再 click → npc-req -->`

---

## ⚠️ Follow-up 2 项(可选)

### `Style Lock · 风格定档.html` 没同步 v3.1 字号体系
- 文档里还显示旧 11 档(10-30px),没改成 v3.1 的 8 档(14-40px)
- 文档第 466-477 行的"11 档字阶 (v2 · 锁定)"段需重写为"8 档 v3.1 锁定"
- 不阻塞验收,但作为风格定档文档应该同步真值

### `scripts/import-design.sh` 还是只拉 `final/`
- 没拉 design 沙箱根目录的 2 个 HTML 真值文件
- 用户每次都得手动 `cp`,流程 bug

---

## Phase A 验收态势

| 项 | 状态 |
|---|---|
| Style Lock 风格定档质量 | ✅ 极高(15 色 + 8 字阶 + 9 货币 + 7 角标 + 27 古风对照 + v2 校准 + v3.1 字号升级)|
| Vue 工程 npm run dev 可起 | ✅ |
| 8 共享组件 SFC 全在位(含 JobDetailModal v2 新增) | ✅ |
| Pinia modal store 走通 | ✅ |
| canonical fps_0037 归属对齐 | ✅ Vue 层 / ⚠️ HTML 真值待清(follow-up 1)|
| 6 Phase B 占位 view 全在位 | ✅ |
| viewport 448×960 + 字号 v3.1 中文 ≥16px | ✅ |

**结论**:Phase A 通过 → **可进 Phase B**。Follow-up 1 可跟 Phase B 第 1 屏(SkillList fps_0001)一起出。
