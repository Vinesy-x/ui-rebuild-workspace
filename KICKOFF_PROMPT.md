# Starter / Migration Prompts

## 用途索引

| 场景 | 用哪段 |
|---|---|
| **从零启动** | [模式 1](#模式-1全新工程从零启动) |
| **从已做 HTML 迁移到 Vue 工程** | [模式 2](#模式-2从-html-迁移到-vue)(本次实际需要) |

---

## 模式 1:全新工程从零启动

```
我有 N 张手游录屏截图在附件 design-brief/ 目录(竖屏 448×960,<游戏类型>),需要做完整 UI 重建。

【工程格式 — 必须遵守】

final/ 已经是一个 Vite + Vue 3 + TS + Pinia + Vue Router 工程(详见 design-brief/ENGINEERING_TEMPLATE.md)。
所有产出按 4 类:
- token → final/src/styles/tokens.css
- 共享组件 → final/src/components/*.vue (SFC)
- 屏组件 → final/src/views/*.vue (SFC,每屏 1 个)
- 数据 → final/src/data/*.json

**禁止散装 HTML**。组件用 props,跨屏命名一致,跳转用 vue-router。

【工作流程 - 两阶段】

Phase A(只 1 个任务):用 style-reference/target-style.png 的风格,做 1 张测试屏(fps_0012 卡组列表)。
完成时一并交付 token + 共享组件 + 数据 schema → 这就是"风格定档"。
等用户验收 OK 后才进 Phase B。

Phase B(每张帧 1 个任务):剩余 36 张帧。每张 = 1 个 view + 可能新增 component / data。
完成 1 张停 1 张,等用户验收。

【强约束(4 条)】

1. 每个内容元素从 PNG 真实提取(禁占位 mock)
2. 图标用 SVG(禁 emoji / unicode)
3. 跨屏组件 + token 命名一致(Phase A 锁定)
4. 交互行为按 design-brief/flows/interaction-spec.md 实现

【第一步】

先读:
- design-brief/README.md
- design-brief/TASKS.md
- design-brief/ENGINEERING_TEMPLATE.md ★必读
- design-brief/flows/interaction-spec.md
- style-reference/target-style.png + STYLE_ANALYSIS.md
- analysis/projectE_fps_0012.png

然后告诉用户:理解的风格方向 + 你 T-A1 打算产出哪些文件。开始 T-A1。
```

---

## 模式 2:从 HTML 迁移到 Vue

适用场景:**你已经让 Design 做了若干张散装 HTML,现在要迁移到 Vite Vue 工程,顺便提炼共享组件**。

```
我们的工程格式从"散装 HTML"切换为 Vite + Vue 3 + TS。final/ 已经是初始化好的 Vue 工程。

【你已做的 4 张需要转换】

T-A1 (fps_0012 卡组列表) → final/src/views/DeckList.vue
T-B1 (fps_0001 开场)     → final/src/views/Opening.vue
T-B2 (fps_0002 资源奖励) → final/src/views/RewardSet.vue
T-B3 (fps_0003 主菜单)   → final/src/views/MainMenu.vue

转换时:
1. 从这 4 张 HTML 提炼出**共享组件**放到 final/src/components/*.vue
   - 至少:Button.vue / UnitCard.vue / DialogShell.vue / HUD.vue / BottomTabBar.vue
   - 还有什么共享的你自己判断
2. 提炼**所有 token** 放到 final/src/styles/tokens.css(CSS 自定义属性)
   - 色板 / 字号 / 间距 / 圆角 / 阴影
   - 命名清晰可复用(不是 "卡组那个紫色")
3. 提炼**数据**到 final/src/data/*.json
   - units.json(从 fps_0012 提取的所有单位)
   - 其他出现过的实体
4. 屏组件改用 vue-router 跳转,跳转目标按 design-brief/flows/interaction-spec.md

【完成转换后输出】

1. final/src/styles/tokens.css(完整)
2. final/src/components/*.vue(若干个共享组件)
3. final/src/views/{DeckList,Opening,RewardSet,MainMenu}.vue
4. final/src/data/*.json(至少 units.json)
5. final/src/router.ts 更新(把 Placeholder 替换为这 4 个 view)
6. final/src/assets/icons.svg(SVG sprite)
7. 一份 design-brief/PHASE_A_LOCK.md 总结:
   - token 命名清单
   - 组件清单(每个组件的 props 接口)
   - SVG icon 清单
   - 数据 schema
   
   这份 LOCK 文档是 Phase B 的契约,后续 36 张严格按这里命名。

【强约束(4 条)】

1. 每个内容元素从 PNG 真实提取(禁占位)
2. 图标用 SVG sprite(<use href="@/assets/icons.svg#icon-xxx">)
3. 组件 + token 命名一致(本次转换后锁定,Phase B 沿用)
4. 跳转用 vue-router,行为按 interaction-spec.md

【验证】

转换完成后,在本地跑 cd final && npm install && npm run dev,确认:
- http://127.0.0.1:5173/ 能看到 MainMenu
- 路由跳转正常(主菜单 ↔ 卡组等)
- 没有 TS 错误
- 没有 console error

把验证截图给我看。

【第一步】

先读 design-brief/ENGINEERING_TEMPLATE.md 理解工程格式,然后开始转换。完成一组停下汇报,不要一次全转。建议顺序:
1. 先做 tokens.css + 共享组件骨架
2. 再做 DeckList.vue (T-A1 风格定档屏)
3. 然后 MainMenu / Opening / RewardSet

每完成一组(token+组件+1-2 屏),输出 + 截图 + 等用户继续。
```

---

## 后续轮的简短回复模板

| 你要表达 | 回什么 |
|---|---|
| Phase A 通过 | `Phase A 通过,开始 T-B4(fps_0005 竞技场)`|
| 这个组件 / 屏 OK | `继续`|
| 改这里 | `修改 X:<反馈>`|
| 暂停 | `暂停,我先看一下`|
| 颜色不对 | `T-XX 的 X 颜色应该是 style-reference 里 region Y 的色`|

## checkpoint 节奏建议

| 时机 | 重点验收 |
|---|---|
| 转换完 token + 组件骨架 | 命名清晰可复用,SVG sprite 就位 |
| 转换完 DeckList.vue | 视觉对齐 target-style,组件用得对 |
| 转换完 MainMenu / Opening / RewardSet | 路由跳转通,跨屏组件一致 |
| 进 Phase B 前 | 跑通 `npm run build`(确保能打包) |
| Phase B 每 5 张 | 视觉一致性 / 内容真实 / 没引入新的散装样式 |
| 全部完成 | `npm run build` + 部署到任意静态服务器看效果 |
