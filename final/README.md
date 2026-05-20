# final/ · 大掌柜 Vite Vue 3 工程

Phase A 已交付的脚手架。Phase B 起逐屏填实。

## 目录

```
final/
├── README.md                  本说明
└── src/
    ├── styles/tokens.css      全局 token (Phase A 锁定 · 不再改)
    ├── stores/useModalStore.ts 全局 modal Pinia store
    ├── router.ts              Vue Router (Phase B 屏占位)
    ├── views/
    │   └── MainMenu.vue       fps_0035 主菜单 (Phase A)
    ├── components/
    │   ├── ModalShell.vue     根 layout 挂的 modal 路由
    │   ├── HudBar.vue         双行 HUD
    │   ├── BottomTabBar.vue   底栏 6 Tab
    │   ├── ProgressListDialog.vue  ← 共享 1: 心境 + 體魄
    │   ├── OptionPickerModal.vue   ← 共享 2: 礼物 + 约会
    │   ├── PurchaseConfirmModal.vue ← 共享 3: 食 + 居 + 大件
    │   ├── AsyncWaitModal.vue       ← 共享 4: 卖车 3 步
    │   ├── CinematicScene.vue       ← 共享 5: 大件过场
    │   ├── UpgradeOverlay.vue       ← 共享 6: 亲疏度升级
    │   └── JobPromoSplash.vue       ← 共享 7: 工作促销
    └── data/
        └── mainMenu.json     fps_0035 数据（PNG 提取 + 古风化）
```

## 与 HTML 原型的关系

项目根 `Phase A · 主菜单 大掌柜.html` = 视觉真值（Style Lock）。
本目录 Vue SFC = 等价 Vue 实现骨架。Phase B 起：
1. 把 HTML 原型的 inline style 抽到 `src/styles/main-menu.css` 引入
2. 49 张屏按 `design-brief/flows/info-architecture.md` 屏映射逐屏 view
3. 所有 modal 一律走 `useModalStore` (避免嵌套 router)
4. `router.afterEach` 自动 reset modal

## 强约束 (Phase A 锁定)

1. tokens.css 是唯一颜色 / 字号源 — 不允许各屏写死 hex
2. 7 个共享组件必须复用 — 不允许各屏新写 modal
3. 印章 + 汉字 = 货币 icon 标准 — Phase B 替换为 SVG 切片
4. modal scrim = `rgba(0,0,0,.65) + backdrop-filter:blur(8px)` 锁定
