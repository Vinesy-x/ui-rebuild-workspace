# 给 design 的 KICKOFF Prompt(projectE · 大掌柜)

> ⏳ **等用户传宋朝风格参考图到 `design-brief/style-reference/` 后,把下面这段发给 design**

---

```
projectE · 大掌柜 — 视频 UI 重建任务

【项目背景】

- 游戏名:大掌柜
- 类型:模拟、互动剧情
- 核心机制:各种文字互动情景对话 + 事件经营
- 布局参考:现代版同类游戏录屏 50 张抽帧(在 design-brief/analysis/)
- 视觉目标:中国古代宋朝古风(参考图在 design-brief/style-reference/)

⚠️ 重要双重源约定:
- 布局结构 来自现代视频抽帧(design-brief/analysis/projectE_fps_NNNN.png)
- 美术风格 来自宋朝参考图(design-brief/style-reference/)
- 文字内容 改成宋朝语境(例:"魅力"→"声望"或保留 / "财富"→"银两" 等,
  你看 PNG 时自主决定怎么古风化)

【工程格式】

按 projectB 工程模板,Vite + Vue 3 + TS + Pinia + Vue Router。

产出 4 类:
- final/src/styles/tokens.css     全局 token(宋朝色板 / 字号 / 间距 / 圆角)
- final/src/components/*.vue       共享组件(HUD / SkillRow / UpgradeButton 等)
- final/src/views/*.vue            屏组件(每帧 1 个)
- final/src/data/*.json            真实数据(从 PNG 提取)

【Phase A 任务】

T-A1:fps_0001 主页(技能 / 属性 list 屏)+ 风格定档

输入:
1. design-brief/analysis/projectE_fps_0001.png — 布局 / 内容结构
2. design-brief/style-reference/*.png — 宋朝视觉风格

要做:
- 布局 = fps_0001(顶部 4 货币 HUD + 用户头像 + 技能列表 + "升级"按钮 + 锁定项)
- 视觉 = 宋朝古风(从 style-reference 提炼色板 / 装饰元素 / 字体感)
- 文字内容 = 改成宋朝语境(看是否要古风化技能名)

同时交付风格定档(锁定):
- 色板 10-15 色 + 5 档品质 + 专用色,自命名
- 字号体系 4-6 档
- 字体(中文衬线 / 仿宋)
- 共享组件命名(HUD / SkillRow / UpgradeButton / LockedItem 等)
- SVG / PNG 资产清单

通过后 → 进入 Phase B,风格不再变。

【强约束 5 条】

1. 每个内容元素从 PNG 真实提取(布局 + 数值)
2. 图标用 SVG / PNG(禁 emoji / unicode)
3. 跨屏组件 + token 命名一致(Phase A 锁定后 Phase B 沿用)
4. 交互行为按 design-brief/flows/interaction-spec.md 实现(Phase B 跟着推)
5. 产出 = Vite Vue 3 SFC

【先读这些再开始】

1. README.md(projectE 总览)
2. design-brief/TASKS.md(任务清单 + 强约束)
3. design-brief/analysis/projectE_fps_0001.png(Phase A 布局)
4. design-brief/style-reference/(宋朝视觉参考图,用户已传)

然后告诉用户:
- 你看完 style-reference 提炼的 5 个宋朝风格关键词
- T-A1 打算产出哪些文件
- 文字内容打算怎么古风化

开始做 T-A1。完成停下等用户验收。
```

---

## 给 design 之前的 Checklist(用户做)

- [ ] 把宋朝风格参考图传到 `design-brief/style-reference/`(色板 / UI 框 / 字体 / 装饰元素)
- [ ] commit + push
- [ ] 然后把上面 ``` 括起来的那段 prompt 发给 design
- [ ] design 出 link → 用户跑 `./scripts/import-design.sh <link>` 拉本地

## Phase B 工作流(跟 projectB 一样)

- 每屏 1 task
- design 沙箱出 link → import → verify → commit → bug 报告 → 新 link
- flows 三件套(info-architecture / interaction-spec / topology)跟着 Phase B 同步补
