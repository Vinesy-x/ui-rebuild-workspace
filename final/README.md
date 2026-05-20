# final/ · 大掌柜 Vite Vue 3 工程

Phase A 已交付。`npm install && npm run dev` 可起。

## 目录

```
final/
├── README.md                          本说明
├── package.json
├── vite.config.ts
├── tsconfig.json
├── index.html                         Vite 入口
└── src/
    ├── main.ts                        boot · createApp + Pinia + router
    ├── App.vue                        根 layout · router-view + ModalShell
    ├── styles/
    │   └── tokens.css                 全局 token · 色板 / 字号 / 工具类 · 锁定
    ├── stores/
    │   └── useModalStore.ts           Pinia modal store
    ├── router.ts                      Vue Router · Tab 6 路由占位
    ├── data/
    │   └── mainMenu.json              fps_0035 提取数据
    ├── views/
    │   ├── MainMenu.vue               ⭐ Phase A 锁定屏 (fps_0035)
    │   ├── SkillList.vue              Phase B 占位 (0001)
    │   ├── MeetList.vue               Phase B 占位 (0012)
    │   ├── WorkDAG.vue                Phase B 占位 (0036)
    │   ├── BusinessList.vue           Phase B 占位 (0046)
    │   ├── InvestBank.vue             Phase B 占位 (0058)
    │   └── ShopItems.vue              Phase B 占位 (0073/0080)
    └── components/
        ├── HudBar.vue                 双行 HUD
        ├── BottomTabBar.vue           底栏 6 Tab
        ├── ModalShell.vue             modal 根容器 · 3 档尺寸 · scrim+blur
        ├── ProgressListDialog.vue     ← 共享 1: 心境 + 體魄
        ├── OptionPickerModal.vue      ← 共享 2: 礼物 + 约会
        ├── PurchaseConfirmModal.vue   ← 共享 3: 食 + 居 + 大件
        ├── AsyncWaitModal.vue         ← 共享 4: 卖车 3 步
        ├── CinematicScene.vue         ← 共享 5: 大件过场
        ├── UpgradeOverlay.vue         ← 共享 6: 亲疏度升级
        ├── JobPromoSplash.vue         ← 共享 7: 工作促销
        └── JobDetailModal.vue         ← 共享 8 (v2 新增): 工作详情 0037+0040
```

## v2 canonical 校正 (2026-05)

### fps_0037 归属
- **旧推测**：主菜单 NPC (红巾娘子) tap → 焊工要求 modal
- **v2 校正**：0037 是工作 Tab → 工作 list → 点工作卡 → **JobDetailModal**「焊工」（与 0040 汽车修理工、0041 promo 同 widget 不同工种）
- **作废**：主菜单 NPC tap 边。NPC 改为纯装饰，无交互
- **新增**：`JobDetailModal.vue` 作 7 共享组件之 8

### 删除的字段
- `mainMenu.json` 删 `npcJobRequirement`
- `useModalStore.ts` 删 `'npc-req'` modal name
- `MainMenu.vue` NPC `@click` 处理删

## Modal 尺寸 3 档 (锁定)

| 档 | 高 | 用途 |
|---|---|---|
| `.modal--sm` | 420px | 短列表 / 信息 modal |
| `.modal--md` | 560px | hero+6 行 / req 列表 (默认) |
| `.modal--lg` | 740px | 长列表 / 商店 / 设置 / 人物卷 |

- 锚点：`top: 64px` · `left/right: 16px` · 居中偏上
- 默认 `overflow: hidden`，仅列表型 modal 加 `.modal-body.scroll`

## 字号体系 8 档 v3.1 (锁定)

```
--fs-overlay  40  · UpgradeOverlay 段位大字
--fs-display  32  · HUD 主数据 / hero / 大数字
--fs-h1       26  · modal title / 屏标题
--fs-h2       20  · section / NPC 名 / 卡片标题
--fs-body     18  · 正文 / list / 价格 (最小)
--fs-label    17  · tab / button / pill
--fs-meta     15  · cost / cd / sub-info
--fs-mono     14  · placeholder 监督
```

工具类：`.t-overlay / .t-display / .t-h1 / .t-h2 / .t-body / .t-name / .t-num / .t-label / .t-meta / .t-mono`

## 强约束 (Phase A 锁定)

1. tokens.css 是唯一颜色 / 字号源 — 不允许各屏写死 hex
2. 8 个共享组件必须复用 — 不允许各屏新写 modal
3. 印章 + 汉字 = 货币 icon 标准 — Phase B 替换为 SVG 切片
4. modal scrim = `rgba(0,0,0,.65) + backdrop-filter:blur(8px)` 锁定
5. 中文正文最小 16px，禁 inline `style="font-size:Npx"`

## Phase B 进入条件

✓ npm run dev 跑出 Phase A 主菜单（fps_0035）= HTML 原型视觉等价
✓ 8 共享组件 SFC 全在位
✓ Pinia modal store 走通
✓ canonical 屏映射对齐 info-architecture.md
