# T-B1 task prompt · Phase B 第 1 屏(fps_0001 技能 list)

> Phase A 已完全收尾,进 Phase B。
> Phase B 工作流:每屏 1 task → design 沙箱出 link → 用户 `./scripts/import-design.sh` 拉本地 verify → commit → bug 报告 → 新 link

把下面 ``` 包起来的整段发给 design ⬇️

---

```
projectE · 大掌柜 — Phase B T-B1
fps_0001 技能 list (底栏 Tab 1)

【背景】

Phase A T-A1 fps_0035 主菜单已通过 → 风格 / tokens / 8 共享组件 / Pinia
modal store / router / 6 占位 view 全部锁定,不再改。

T-B1 起逐屏填实 Phase B。第 1 屏是底栏 Tab 1 技能,涉及 3 帧:
- fps_0001 = 技能 list (主)
- fps_0002 = 升级飘字 trans (inline 在 list 内, "+2 飘字 + 金奖杯")
- fps_0007 = 加速 modal (每技能各一,共享 modal)

【屏归属与数据 (canonical 已锁定)】

总 13 技能 (5 解锁 + 8 锁定),3 档解锁价阶梯 ⭐25 / 40 / 70:

已解锁 5 (顶部段, 训练中):
- 力量 lv10  ·  ----- 升级动画中 (被遮)
- 智略 lv12 · 34分:13秒 · 100 銅/月
- 魅力 lv7  · 05分:11秒 · 100 銅/月
- 吸引力 lv2 · 00分:03秒 · 100 銅/月 (即将完成)
- 运气 lv1  · 00分:41秒 · 200 銅/月

锁定 8 (底部段, 收集 ⭐ 解锁):
- 耐力     🔒 ⭐25
- 抗能力   🔒 ⭐25
- 创造力   🔒 ⭐40
- 雄心     🔒 ⭐40
- 决心     🔒 ⭐70
- 共情力   🔒 ⭐70
- 领导力   🔒 ⭐70
- (第 8 锁定项, Phase B 自由命名, ⭐70 档)

每行 4 元素 (从左到右):
[图标 + 等级 lv N]  [名称 / 计时 / 月费 / 进度条]  [▶ 启动]  [加速卡 仪表盘 icon]

锁定行简化: [🔒]  [名称 / 收集 ⭐N 解锁]  (无 ▶ / 加速)

顶部 2 强化按钮:
- 绿瓶 + 标记 = 属性药水 (推测; click 行为 Phase C 接策划表后定)
- 绿电池 = 精力 / 全局加速 (推测; 同上)

【加速 modal (fps_0007, 7+1 共享之 1 复用)】

- 每技能各自一个 modal (modal 文案动态带技能名)
- 仪表盘 icon + "将你的{N}训练速度提升 6 倍! 永久生效!"
  ({N} 是当前技能名: 吸引力 / 力量 / 等)
- 倍率固定 6×
- 永久生效 (非限时)
- 左 "取消" 按钮 蓝色 (--azure)
- 右 "💎 6" 按钮 绿色 (--cur-jade), 6 紫晶 / 玉珏

⚠️ 但 0007 不是 7 共享组件之一 — 单独建 SkillAccelerateModal.vue
(已 useModalStore 'skill-accelerate' name 占位, Phase A 锁定)

【升级飘字 trans (fps_0002)】

技能计时到 0 → 自动升级 → inline 飘字 (不是 modal):
- 该行升级到下一级
- 飘字: 绿色 pill "+2 天" / "+2 香烟" 等 (canonical 推测,
  实际飘字数值 Phase C 接策划表后定; 当前用占位)
- 金奖杯 + "+1" level-up 角标 在该行短暂出现
- 1-2 秒淡出

⚠️ 这是 inline state, 不是新 modal, 在 SkillList.vue 内自行实现
(可以用 Vue <transition> + Pinia toast queue)

【加速激活 inline 运行态 (canonical extras 备用帧 0006/0008/0010)】

某技能被加速后, 该行持续显示运行态:
- 进度条上方挂 "+2.5..." 浮动收益 chip
- 进度条右侧 ⏸️ 暂停按钮 + 火焰 icon (加速进行中标志)
- 进度条右侧 立柱图标 (库存指示, 道具系统证据)

⚠️ 也是 inline state, SkillList.vue 内自行实现; 道具系统 (绿瓶+/
  绿电池/立柱) 视觉占位即可, 行为 Phase C 接策划表后定

【文字古风化 (建议, design 可调整)】

- 整屏标题: "技能" → 保留 / 改"技艺"
- 技能名:
  - 力量 → 膂力 / 保留
  - 智略 → 心计 / 保留
  - 魅力 → 风姿 / 保留
  - 吸引力 → 风韵 / 保留
  - 运气 → 福缘 / 气运
  - 耐力 → 耐性 / 韧劲
  - 抗能力 → 抗压
  - 创造力 → 巧思 / 慧根
  - 雄心 → 雄心 (保留, 已古风)
  - 决心 → 决断
  - 共情力 → 共情 / 同理
  - 领导力 → 御众 / 统御
- 单位:
  - 100/月 → 100 銅/月 (用印章)
  - 收集 ⭐25 → 文星 廿五
  - 训练速度提升 6 倍 → 修炼之速 提升 六倍
  - 永久生效 → 永世锁住
- 按钮:
  - ▶ 启动 → 起 / 习
  - 加速 → 催功 / 催时
  - 取消 → 罢
  - 接受 → 受

【产出 4 件】

1. final/src/views/SkillList.vue (填实, 当前是 2 行 placeholder)
   - 13 技能完整 list
   - 顶部 HUD 复用 HudBar.vue (Phase A 已建)
   - 底部 BottomTabBar 复用 (Phase A 已建)
   - 顶部 2 强化按钮 (绿瓶+ / 绿电池) — Phase B 视觉占位
   - 每行 4 元素布局 (解锁行) / 2 元素 (锁定行)
   - inline transitions: 升级飘字 / 加速激活态

2. final/src/components/SkillAccelerateModal.vue (新增, 共享 modal)
   - props: { skillName, costJade }
   - 在 ModalShell.vue 的 map 里注册 'skill-accelerate' → SkillAccelerateModal
   - 跟 useModalStore.open('skill-accelerate', { skillName: '吸引力',
     costJade: 6 }) 配套

3. final/src/data/skillList.json (新增)
   - 13 技能数据 (name / lvl / costPerMonth / progressSec / unlockStar
     for 锁定项)
   - 从 canonical 提取

4. (顺手) router.ts 已经有 /skill 路由 → SkillList.vue, 验证跳转 OK
   也顺手验证 BottomTabBar Tab 1 click → router.push('/skill') OK

【强约束 (继承 Phase A, 不重写)】

1. tokens.css 唯一颜色 / 字号源 — 不允许写死 hex
2. 8 共享组件 (含 JobDetailModal) 必须复用 — 不允许新建 modal 除非
   像 SkillAccelerateModal 这种 useModalStore 已有 name 的 9 个 modal
3. 印章 + 汉字 = 货币 icon 标准
4. modal scrim = rgba(0,0,0,.65) + backdrop-filter blur(8px) 锁定
5. 中文正文最小 18px (v3.1 锁定)
6. 不允许各屏单独写 modal — 走 useModalStore.open / close
7. router.afterEach 切屏自动 reset modal (Phase A 已建)

【先读这些再开始 (优先级)】

1. design-brief/analysis/projectE_fps_0001.png (主屏布局真值)
2. design-brief/analysis/projectE_fps_0002.png (升级飘字 trans)
3. design-brief/analysis/projectE_fps_0007.png (加速 modal)
4. design-brief/flows/info-architecture.md (canonical 屏映射)
5. design-brief/flows/screen-details.md L226-263 (fps_0001-0007 深度 spec)
6. design-brief/flows/screen-details-extras.md (备用帧 0011 揭示 13 技能 +
   3 档解锁价阶梯; 0005 揭示 +2 香烟 chip 道具系统; 0006/0008/0010 揭示
   加速激活 inline 运行态)
7. final/README.md (Phase A 锁定项 + 8 共享组件 + Modal 3 档尺寸 + 字号 v3.1)
8. final/Phase A · 主菜单 大掌柜.html (HUD / BottomTabBar 等已建组件视觉真值)
9. final/Style Lock · 风格定档.html (色板 + 字号 + 货币印章 + 角标)

然后告诉用户:
- 13 技能名 (5 解锁 + 8 锁定) 你定的最终古风化名字
- 加速 modal 视觉 (6 紫晶按钮颜色 / 仪表盘 icon 实现方式)
- 升级飘字 + 加速激活 inline 实现策略 (Vue transition / Pinia toast 哪种)
- 顶部 2 强化按钮 (绿瓶+ / 绿电池) 视觉占位方案
- 顺带: 整屏背景是不是 paper-1 / 卡片是不是 frame-wood / 列表行用什么底色

完成后停下等用户验收 (用户会跑 npm run dev 在 / 切到 /skill 看)。
```

---

## 给 design 之前自检

- [x] Phase A 完全收尾 (Vue 工程跑通 / canonical 对齐 / Style Lock 锁定)
- [x] 13 技能 + 3 档解锁价 + 各种 inline state 在 canonical 已经记录
- [x] useModalStore 已有 'skill-accelerate' modal name (Phase A 占位过)
- [x] router 已有 /skill 路由 (Phase A 占位过)
- [x] SkillList.vue 已有 2 行 placeholder (Phase A 占位过)
- [ ] 把上面 ``` 包起来的整段发给 design
- [ ] design 出 link → 用户跑 `./scripts/import-design.sh <link>` 拉本地

## Phase B 节奏目标

| 屏 | task | 预估 |
|---|---|---|
| T-B1 fps_0001 技能 list (Tab 1) | ⏳ 本任务 | — |
| T-B2 fps_0012 关系 list (Tab 2) | 待启动 | — |
| T-B3 fps_0036 工作 DAG (Tab 3) | 待启动 | — |
| T-B4 fps_0046 业务 list (Tab 4) | 待启动 | — |
| T-B5 fps_0058 投资屏 (Tab 5) | 待启动 | — |
| T-B6 fps_0073 + fps_0080 商店 (Tab 6) | 待启动 | — |
| T-B7~ 全局 modal (字符 / 目标 / 设置 / 幸福 / 健康 / 事件 / 商店货币) | 待启动 | — |
| 后续 Phase B 屏 (约会 / 卖车 / 工作详情 等子流) | 待启动 | — |
