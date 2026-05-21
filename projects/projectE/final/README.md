# final/ · 大掌柜 Vite Vue 3 工程层

> ⚠️ **项目级文档看 `../README.md` 和 `../PROGRESS.md`**。本文件只描述 `src/` 内部结构。
> 状态 / 当前阶段 / canonical 演进 / 共享 modal 清单 / 已废清单 → 全在 `../PROGRESS.md`。

## 启动

```bash
npm install && npm run dev
# http://localhost:5173/
npm run build          # 生产构建
```

## src/ 目录结构

```
src/
├── main.ts                    boot · createApp + Pinia + router + 导入 tokens/components.css
├── App.vue                    根 layout · router-view + ModalShell
├── router.ts                  Vue Router · 6 Tab + main 路由
│
├── styles/
│   ├── tokens.css             ⭐ 锁定:15 色 / 8 字阶 / 9 货币 / motion / 8 sp / 6 r / 等 var
│   └── components.css         ⭐ canonical 全局 class(.sub-tabs / .modal-pane / .pane-cta /
│                                .star / .ic-seal+9 货币 / .screen / .screen-bar /
│                                .npc-card / .red-bang / .set-row / .toggle / .reputation /
│                                .goal-row / .tx-press)
│
├── stores/
│   └── useModalStore.ts       Pinia · ModalName union + open/close + props
│
├── types/
│   └── modalPayloads.ts       共享 modal props union(BankInfoMsg / ShopTab / ...)
│
├── utils/
│   └── mergeHud.ts            hud overrides 合并 utility(各 view 复用)
│
├── data/                      ⭐ 每屏一份 JSON 数据层
│   ├── mainMenu.json          fps_0035 主菜单
│   ├── skillList.json         T-B1 技能(13 项 + 2 booster)
│   ├── relations.json         T-B2 关系(4 NPC + 5 actions + 礼物/约会库)
│   ├── workList.json          T-B3 工作 DAG(13 岗位 + 父子关系)
│   ├── businessList.json      T-B4 商號(5 业务 + IAP banner)
│   └── investments.json       T-B5 投资(3 sub-tab + 9 商號 + infoMessages)
│
├── views/                     一屏一文件(router 对应)
│   ├── MainMenu.vue           ⭐ Phase A 锁定 · 街景 hub
│   ├── SkillList.vue          T-B1 ✅
│   ├── MeetList.vue           T-B2 ✅(list)
│   ├── RelationDetail.vue     T-B2 ✅(详情 · 路由参数)
│   ├── WorkDAG.vue            T-B3 ✅(13 岗 DAG)
│   ├── BusinessList.vue       T-B4 ✅(5 业务)
│   ├── InvestBank.vue         T-B5 ✅(3 sub-tab)
│   └── ShopItems.vue          T-B6 待启动(占位)
│
└── components/                共享组件
    ├── HudBar.vue             双行 HUD(9 资源 cell + 头像 + 日历 + 齿轮)
    ├── BottomTabBar.vue       底栏 6 Tab(技/缘/工/商/票/物)
    ├── ModalShell.vue         modal 根容器 · 3 档尺寸 sm/md/lg · scrim+blur
    └── <N>Modal.vue           N 共享 modal(数量看 PROGRESS.md)
```

## 强约束(Phase A 锁定 · Phase B 各 task 不重写)

1. tokens.css = 唯一颜色 / 字号源 · 字号必走 `var(--fs-*)` 8 阶
2. 共享 modal 走 `useModalStore` + `ModalShell` map · 不重复 implement
3. 印章 + 汉字 = 货币 icon 标准 · 复用全局 `.ic-seal.ic-*` class
4. modal scrim 锁定 `rgba(0,0,0,.65) + backdrop-filter blur(8px)`
5. 中文正文 ≥18px(v3.1)
6. canonical 跟 PNG 冲突时 PNG 优先,然后更新 canonical
7. 已废弃项(PROGRESS.md 已废清单)不要重新引入

## Modal 尺寸 3 档

| 档 | 高 | 用途 |
|---|---|---|
| `.modal--sm` | 420px | 短列表 / 信息 modal |
| `.modal--md` | 560px | hero+6 行 / req 列表(default)|
| `.modal--lg` | 740px | 长列表 / 商店 / 设置 / 人物卷 |

锚点:`top: 64px` · `left/right: 16px` · 居中偏上。
默认 `overflow: hidden`,仅列表型 modal 加 `.modal-body.scroll`。
