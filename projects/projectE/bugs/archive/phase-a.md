# Phase A · T-A1 验收反馈(2 项必修)

> 验收时间:2026-05-20
> 验收人:用户
> 当前 design 沙箱:`https://api.anthropic.com/v1/design/h/gBklKWhewjLqVQYR-1w5AA`

`Style Lock · 风格定档.html` 和 `Phase A · 主菜单 大掌柜.html` 视觉质量极高,5 关键词("雾天起青/江南黑瓦/印泥赭收/细金均线/水墨留白")+ 15 色 + 11 字阶 + 9 货币 + 7 角标 + 27+ 古风对照 + 12 项资产清单 + v2 校准说明完整。**风格定档通过 → 锁定**。

但 Vue 工程层 + canonical 数据有 2 项必修才能进入 Phase B。

---

## ❌ 必修 1:Vue 组件 `<style scoped>` 大部分空缺

### 现象
`final/src/` 下 11 个 Vue 文件:
- **6 个完全没 `<style>` 段**:`AsyncWaitModal.vue` / `BottomTabBar.vue` / `HudBar.vue` / `OptionPickerModal.vue` / `PurchaseConfirmModal.vue`(以及 6 个未列出的 placeholder views)
- **2 个 `<style>` 段是空注释占位**:
  - `views/MainMenu.vue` — `/* 局部样式从项目根 Phase A · 主菜单 大掌柜.html 提炼 / 实做时拆 tokens.css + main-menu.css 引入 */`
  - `components/ProgressListDialog.vue` — `/* 引 tokens.css 全局 + .modal .modal-bar .modal-body .hero .plist .prow */`
- 只 5 个有完整 scoped style:`CinematicScene` / `JobPromoSplash` / `ModalShell` / `UpgradeOverlay` / `MainMenu`(MainMenu 的 style 段是空注释,即只 4 个真有 style)

### 影响
`cd final && npm install && npm run dev` 跑出来的 Vue 工程**主菜单完全裸 HTML 没样式**(只有 tokens.css 的 reset),`Phase A · 主菜单 大掌柜.html` 原型才是有样式的真值。Phase B 接下去开发每屏都得手抄 inline css → scoped style,工作量翻倍且容易漂移。

### 期望修
**把 `Phase A · 主菜单 大掌柜.html`(1931 行)的 inline `<style>` 段拆分到对应 Vue 组件的 `<style scoped>`**:
- `.menu / .scene / .name-strip / .bonus-bubble / .task-row / .pouch / .task-card / .play / .bar / .ratio / .stack / .npcs / .npc / .floater` 等 → `MainMenu.vue`
- `.hud / .avatar-wrap / .avatar-frame / .avatar-lv / .hud-cell / .ic-seal / .ic-coin/jade/mood/heart/star/coin2 / .gear-btn / .cal` → `HudBar.vue`
- `.bottom-tab / .tab-item / .tab-icon / .tab-label` → `BottomTabBar.vue`
- `.modal-bar / .modal-body / .hero / .plist / .prow / .rname / .rcost / .rgain / .rcd` → `ProgressListDialog.vue`
- 礼物 / 约会 list 样式 → `OptionPickerModal.vue`
- 购买 / 月费 / 加成 list 样式 → `PurchaseConfirmModal.vue`
- 卖车 3 步样式(启动 / loading ∞ / 出价) → `AsyncWaitModal.vue`

完成后跑 `npm run dev` 应该看到跟 `Phase A · 主菜单 大掌柜.html` 视觉等价的 MainMenu。

---

## ❌ 必修 2:`fps_0037` 归属错(影响 3 处 final/ 文件)

### 用户校正
canonical 早期 8 agent 推测 `fps_0037` = "主菜单 tap NPC → 焊工要求 modal"。**用户重新审视 0037 PNG 后发现**:
- **0037 底板可见"级 11" 标签 + 锁定"???"卡**(工作 list DAG 树元素),不是街景
- 0037 **实为工作详情 modal "焊工"**,底板 = 工作 list `fps_0036`,跟 fps_0040 汽车修理工 / fps_0041 promo 是**同 widget 不同工种 / 状态**
- 主菜单 → tap NPC 这条边**完全作废**(主菜单 NPC 可能纯装饰或触发别的,未观察)

### 影响 final/ 3 处必改

**1. `final/src/views/MainMenu.vue` L43**:
```vue
<!-- 改前(错):NPC tap 弹焊工要求 modal -->
<div class="npcs" @click="store.open('npc-req', {jobKey: data.npcJobRequirement})">
  <div class="npc npc-1"></div>
  <div class="npc npc-2"><span class="npc-name">{{ data.scene.npcName }}</span></div>
</div>

<!-- 改后:NPC 纯装饰(canonical 校正后无主菜单 NPC tap 入口) -->
<div class="npcs">
  <div class="npc npc-1"></div>
  <div class="npc npc-2"><span class="npc-name">{{ data.scene.npcName }}</span></div>
</div>
```

**2. `final/src/data/mainMenu.json`**:
```diff
{
  "_source": "fps_0035 PNG 真实提取 + 古风化",
  "character": { ... },
  "hud": { ... },
  "bonus": "四倍 +4.2k",
  "scene": {
    "bgIllu": "/assets/illu-main-bg.png",
    "npcName": "紅巾娘子"
  },
- "npcJobRequirement": "tongHanJiang",
  "task": { ... },
  "_notes": [
-   "急聘銀作開鎖匠 = canonical 工作要求 modal (fps_0037 等价) → 红巾娘子 tap 触发",
+   "fps_0037 在 canonical 校正后属 工作详情 modal (跟 0040 同类),非主菜单 NPC tap;主菜单 NPC = 纯装饰",
    "Bonus 4x 红包 红字泡 = 主菜单顶部右侧悬浮",
    "三堆叠卡 = 多任务列表入口 (Phase B 补完)"
  ]
}
```

**3. `final/src/stores/useModalStore.ts` L20-22**:
```diff
  // 主菜单触发
  | 'settings'
  | ...
- // NPC tap
- | 'npc-req'
  // Tab 1
```

并把 `'job-detail'` 注释从 "Tab 3" 移到 "Tab 3:工作详情 modal,涵盖 fps_0037 焊工 / fps_0040 汽车修理工 / 等所有工种,共用 `JobDetailModal` 组件 props={ jobKey, requirements[] }"。

### 顺手再问 1 个澄清问题
Phase B Tab 3 工作 list 设计时,`JobDetailModal` 是不是应该共用一个组件?(fps_0037 焊工 + 0040 汽车修理工 + 后续所有工种都是同布局,只换数据)

---

## 顺带建议:`scripts/import-design.sh` 缺 root html

`Phase A · 主菜单 大掌柜.html` + `Style Lock · 风格定档.html` 在 design 沙箱**项目根**(`projecte/project/*.html`),`import-design.sh` 只拉 `projecte/project/final/` 子目录,导致这两个真值文档没 import 到本地,我是手动 `cp` 补的。

建议脚本加一步:`rsync projecte/project/*.html → repo_root/`

(这条不阻塞验收,可后续修)

---

## 验收态势

- ✅ Style Lock 文档质量极高(15 色 + 11 字阶 + 9 货币 + 7 角标 + 27 古风对照 + v2 重校),**风格锁定**
- ✅ `tokens.css` / `useModalStore` / `ModalShell` / router 骨架 + 30 个 modal name 字典都对
- ✅ 古风化做得极彻底(王掌櫃 / 紅巾娘子 / 急聘銀作開鎖匠 / 廿一·六十 / 崇寧 仲秋廿四 / 票引 / 骰碼 等)
- ❌ Vue 工程不能直接跑出视觉(必修 1)
- ❌ canonical 数据 fps_0037 归属错,带 3 处 final/ 改动(必修 2)

修完上面 2 项就可以锁 Phase A → 进 Phase B。
