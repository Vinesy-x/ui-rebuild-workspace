# 任务清单(projectE · 大掌柜)

## 项目元信息

- 游戏名: **大掌柜**
- 类型: 模拟、互动剧情
- 核心机制: 文字互动情景对话 + 事件经营
- **布局参考**: input/projectE.mp4(现代版同类游戏 50 张抽帧)
- **视觉风格**: 宋朝古风(中国古代,待 style-reference/ 给出参考图)

⚠️ **重要约定**: 视频内容是"现代换皮版",目标实现是"宋朝换皮版"。
设计时:
- **布局结构** 参照视频抽帧(顶部 HUD / 技能 list / 弹窗模板 / 等)
- **美术 / 色板 / 字体 / 装饰元素** 全部用宋朝古风(等用户提供 style-reference/)
- **文字内容** 改成宋朝语境(例:"技能"→"才学" / "魅力"→"声望" / "智略" 保留 / "财富"→"银两" / 等)— 具体由 design 看 PNG 时决定

---

## Phase A — 风格测试屏(1 task)

### 🔒 T-A1: fps_0035 主菜单(街景 + NPC + 任务 CTA + 底部 5 Tab)+ 风格定档

- 输入:
  1. `design-brief/analysis/projectE_fps_0035.png` — 布局 / 内容结构来源
  2. `design-brief/style-reference/*.png` — 视觉风格来源(待用户提供宋朝参考图)
- 要做:
  - 布局 = fps_0035(顶部 4 货币 HUD + 街景背景 + 2 NPC + 头顶名字 + 中央任务 CTA + 底部 5 Tab)
  - 视觉 = 宋朝古风(从 style-reference 提炼)
  - 文字内容 = 改成宋朝语境(智略 / 魅力 / 吸引力 / 运气 / 耐力 / 抗能力 / 创造力 等技能名 — 看是否要古风化)
- 同时交付风格定档:
  - 色板 10-15 色(宋朝主色:朱红 / 青绿 / 米黄 / 墨黑 / 等)
  - 字号 4-6 档
  - 字体(中文衬线 / 仿宋,或者匹配宋朝感的字体)
  - 共享组件命名(HUD / SkillRow / UpgradeButton / LockedItem 等)
  - SVG / PNG 资产清单
- 通过后 → 进入 Phase B,风格不再变

---

## Phase B — 全屏推进(49 张,Phase A 通过后展开)

待 Phase A 风格定档后,按"通用组件复用度"重排 Wave 1-8。

50 张筛选后的 view types(粗分):
- 主菜单 / 街景 NPC 类(fps_0035 类)
- 任务列表(❤+xx% 奖励)
- 角色对话 + 选项 list(大角色立绘)
- 商店 / 道具 / 礼物网格
- 个人资料(角色介绍)
- 进度卡 + 单项体检 / 套餐
- 多场景:操场 / 房间 / 商店 / 户外
- 礼物面板(食物 / 水果 / 道具)
- 选项菜单 modal

---

## 强约束(全程,5 条)

1. 每个内容元素从 PNG 真实提取(布局)+ 用户语境改造(宋朝语境)
2. 图标用 SVG 或 PNG(不用 emoji),宋朝风格统一
3. 跨屏组件 + token 命名一致(Phase A 锁定后 Phase B 沿用)
4. 交互行为按 design-brief/flows/interaction-spec.md(后续补)
5. 产出 = Vite Vue 3 SFC(参照 projectB/ENGINEERING_TEMPLATE.md)
