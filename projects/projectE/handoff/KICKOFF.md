# 给 design 的 KICKOFF Prompt(projectE · 大掌柜)

> ⏳ **等用户传宋朝风格参考图到 `_internal/analysis/style-reference/` 后,把下面这段发给 design**

> 本 prompt 反映 2026-05-20 canonical 最新状态(8 agent + 6 agent + 用户补图 + simplify 多轮校正后)。
> 共 5 个 flows 文档(`info-architecture.md` + `interaction-spec.md` + `topology.html` + `screen-details.md` + `screen-details-extras.md` + `screen-details-extras2.md`)是 design 必读 canonical。

---

```
projectE · 大掌柜 — 视频 UI 重建任务

【项目背景】

- 游戏名:大掌柜
- 类型:模拟、互动剧情(BitLife 类放置养成 + 经营)
- 核心机制:文字互动情景对话 + 事件经营 + 数值养成(技能/关系/工作/业务/投资/物品 6 大系统)
- 布局参考:现代版同类游戏 130 帧视频抽帧,深度分析 50 张高清(在 _internal/analysis/png/)+ 2 张用户补图(analysis-extras/)
- 视觉目标:中国古代宋朝古风(参考图在 _internal/analysis/style-reference/)

⚠️ 重要双重源约定:
- 布局结构 + 交互行为 来自现代视频抽帧 + flows canonical
- 美术风格 来自宋朝参考图
- 文字内容 改成宋朝语境(对照见下)

【工程格式】

Vite + Vue 3(`<script setup>` + TS)+ Pinia + Vue Router。

产出目录结构(放在仓库 `final/` 下):
- handoff/final/src/styles/tokens.css       全局 token(宋朝色板 / 字号 / 间距 / 圆角)
- handoff/final/src/components/*.vue         共享组件(7 个,见下)
- handoff/final/src/views/*.vue              屏组件(每帧 1 个,跟 router 一一对应)
- handoff/final/src/data/*.json              真实数据(从 PNG 提取)
- handoff/final/src/stores/useModalStore.ts  Pinia store 管 modal 浮层
- handoff/final/src/router.ts                Vue Router 路由表

Modal 模式(避免嵌套 router):
- 全部 modal 走 Pinia store(`open(name, props)` / `close()` / `currentModal`)
- 一个 <ModalShell> 组件挂在根 layout,根据 currentModal 渲染对应 modal
- `router.afterEach` 切屏自动 reset modal(避免跨屏残留)
- modal 底板可见:scrim `rgba(0,0,0,.65)` + `backdrop-filter: blur(8px)`

【Phase A 任务】

T-A1:fps_0035 主菜单(街景 hub)+ 风格定档

输入:
1. _internal/analysis/png/projectE_fps_0035.png — Phase A 锁定屏布局
2. _internal/analysis/style-reference/*.png — 宋朝视觉风格
3. handoff/spec/ — canonical 5 文档(必读,见下)

要做:
- 布局 = fps_0035(双行 HUD + 街景背景 + 2 NPC + 角色名+✏ + 中央任务卡 + 右侧黄色按钮 +
  Bonus 4x 红包气泡 + 底部 6 Tab + 红 ! 角标系统)
- 视觉 = 宋朝古风(从 style-reference 提炼色板 / 装饰元素 / 字体感)
- 文字内容 = 改成宋朝语境
- 主菜单是剧情驱动 hub(住房/衣服购买后背景换 + NPC 换装同步 + 对话台词换,
  详见 interaction-spec.md "主菜单是剧情驱动 hub" 段)

同时交付风格定档(锁定后 Phase B 不再变):
- 色板 10-15 色 + 5 档品质 + 专用色,自命名(宋瓷/丹青/朱印/...)
- 字号体系 4-6 档
- 字体(中文衬线 / 仿宋)
- 7 个共享组件命名 + skeleton(见"共享组件清单")
- SVG / PNG 资产清单
- 8 种货币 + USD icon 套
- 角标系统(红 ! / 黄 ⚠ 促销 / 绿 ✓ / 🔒 / FAIL / ❗ 等)

通过后 → 进入 Phase B,风格不再变。

【底栏 6 Tab(用户确认,canonical 锁定)】

技能 / 遇见 / 工作 / 业务 / 投资 / 物品
- Tab 3 工作 + Tab 6 物品默认带红 ! 角标(新通知)
- 字符 / 目标 / 商店 / 设置 / 幸福 / 健康 / 随机事件 等 modal 跟主菜单挂

【7 个共享组件(canonical 已识别,必须复用)】

1. ProgressListDialog       — 幸福 0123 + 健康 0126 共享
                              hero + 6 行(name/cost/+%/cd)+ 动态 NPC 气泡
2. OptionPickerModal        — 礼物 0020 + 约会 0022 共享
                              list + 推荐 ✓(可选)+ "接受" CTA
3. PurchaseConfirmModal     — 住房 0075 + 食物 0082 共享
                              大图 + 价 + 加成 + 绿"购买/接受"
4. AsyncWaitModal           — 卖车 3 步链 0067-0069
                              启动 → loading ∞ → 出价 / 重搜
5. CinematicScene           — 0077 大件购买过场
                              全屏插画(无 UI chrome,自动播放后返回)
6. UpgradeOverlay           — 0014 亲疏度升级
                              全屏粉心 ✨ + 段位大字 + 1-2 秒
7. JobPromoSplash           — 0041 工作促销
                              黄字标题 + 立绘 + 月薪高亮(无 CTA)

【8 种货币 + USD(canonical 完整)】

- 💵 钞票     — 升级业务 / 月费 / 礼物 / 行为成本
- 💎 紫晶/钻石 — 雇佣经理 / 加速技能 / 高级住房 / 运输 ⭐ 来源 = 成就奖励
- 🟢 砖(绿)— 月入 / 投资组合 / 卖车收入
- ❤ 红心    — 健康度 0-100
- 😊 黄笑    — 幸福度 0-100
- ⭐ 黄星    — 收集解锁(技能 25/40/70 + 物品 ★24)⭐ 来源 = 成就奖励
- 🪙 黄币    — 备用资源
- 🎫 门票 / 🃏 芯片 — 抽卡 / 赌场
- USD       — IAP 真钱(不实现,占位)

【文字古风化对照(canonical 已推荐)】

- John Doyle 21 年份 60 左边 → 王掌柜 21 岁
- 力量 / 智略 / 魅力 / 吸引力 / 运气 → 保留或仿宋化
- 汽车修理工 → 马车工匠 / 修车坊
- 服务员 / 焊工 / 銀匠 → 跑堂 / 銅銲匠 / 銀匠(本身已偏古风)
- 投资 - 股票 → 票号 - 商号股本
- 银行 - cashback → 钱庄 - 回返银
- MOTEL 旅馆 → 客栈
- 幸福 → 心境(或保留)
- 在外赛车 → 蹴鞠 / 跑马
- 喝啤酒 → 饮酒
- 看电影 → 听说书
- 玩台球 → 玩骰子
- STARBUX / STREAMLIX 等股票 → 茶肆 / 戏班 / 食肆 等宋朝商号

【强约束 6 条】

1. 每个内容元素从 PNG / canonical 真实提取(布局 + 数值)
2. 图标用 SVG / PNG(禁 emoji / unicode)
3. 跨屏组件 + token 命名一致(Phase A 锁定后 Phase B 沿用)
4. 交互行为按 handoff/spec/interaction-spec.md 实现(Phase B 跟着推)
5. 7 个共享组件必须复用,不允许各屏单独实现 modal
6. 产出 = Vite Vue 3 SFC

【先读这些再开始(优先级从高到低)】

1. README.md(projectE 总览)
2. handoff/spec/info-architecture.md(屏映射 canonical + 顶部多份重大校正)⭐⭐⭐
3. handoff/spec/screen-details.md(50 selected 帧深度 spec)
4. handoff/spec/screen-details-extras.md(33 备用帧增量)
5. handoff/spec/screen-details-extras2.md(48 raw 备用帧增量,8 项重大 canonical 校正)
6. handoff/spec/interaction-spec.md(交互行为契约)
7. handoff/spec/topology.html(可视化拓扑)
8. _internal/analysis/png/projectE_fps_0035.png(Phase A 锁定屏)
9. _internal/analysis/extras/projectE_fps_0092_*.jpg(2 张目标 modal 补图)
10. _internal/analysis/style-reference/(宋朝视觉参考图)
11. handoff/tasks/(各屏 task prompt 累积 · T-B<N>.md)

然后告诉用户:
- 你看完 style-reference 提炼的 5 个宋朝风格关键词
- T-A1 打算产出哪些文件(tokens.css / 组件名 / view 名)
- 文字内容打算怎么古风化(用上面的对照,你可调整)
- 7 个共享组件的具体 Vue SFC 文件名

开始做 T-A1。完成停下等用户验收。
```

---

## 给 design 之前的 Checklist(用户做)

- [ ] 把宋朝风格参考图传到 `_internal/analysis/style-reference/`(色板 / UI 框 / 字体 / 装饰元素 3-10 张)
- [ ] `git add _internal/analysis/style-reference/ && git commit -m "feat: 宋朝风格参考图" && git push`
- [ ] 然后把上面 ``` 括起来的那段 prompt 发给 design
- [ ] design 出 link → 用户跑 `./scripts/import-design.sh <link>` 拉本地

## Phase B 工作流

- 每屏 1 task
- design 沙箱出 link → import → verify → commit → bug 报告 → 新 link
- flows 文档跟着 Phase B 同步补(新发现的元素 / 边)
- 13 个仍未抽到的 modal(改名/倍数奖励/日期/IAP/银行存款/买入卖出股票/業務出售/變為主要 confirm/衣服购物车/衣服回收/语言选择/新游戏 confirm)Phase B 各屏推进时 design 根据 canonical 文字描述补
