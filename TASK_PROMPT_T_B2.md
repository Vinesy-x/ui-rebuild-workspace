# T-B2 task prompt · Phase B 第 2 屏(fps_0012-0025 关系 Tab 2)

> ⚠️ **重要**:design 沙箱只能看到 `design-brief/` + `final/` + `screenshots/` + PAGES,**看不到仓库根 .md**(SYNC_PROTOCOL / TASK_PROMPT / BUG_REPORT / 等)。
> 所以**所有同步指令 + 废弃项清单必须 inline 在 prompt 文本里**,design 收到的就是用户复制粘贴的整段。
>
> 给 design 之前用户 checklist:
> - [ ] 确认 GitHub main 最新 commit
> - [ ] 把下面 ``` 整段发给 design
> - [ ] design 出 link → `./scripts/import-design.sh <link>` 拉本地

把下面 ``` 包起来的整段发给 design ⬇️

---

```
projectE · 大掌柜 — Phase B T-B2
fps_0012-0025 关系 Tab 2(7+ 帧,含约会子流)


⚠️⚠️⚠️ 开工前同步(必做)— 避免 canonical 漂移 ⚠️⚠️⚠️

GitHub https://github.com/Vinesy-x/projectE main HEAD = 唯一真值。
你的沙箱状态 ≠ GitHub 真值。你的沙箱里如果有跟 GitHub 不一致的旧版
文件,以 GitHub 为准更新沙箱,不要复制粘贴沙箱里旧版代码到新产出。

详细同步规约:design-brief/SYNC_PROTOCOL.md(必读)

T-B1 import 后已发生 2 次 canonical 漂移(8 处 NPC click 反复回滚),
本轮严格遵循以下 5 条已知废弃项,不要重新引入:

【已废弃项 1】关系详情 4 按钮 → 5 按钮(canonical v2 校正后):
- 旧 4 按钮:打个招呼 / 送礼物 / 雇佣 / 变为主要 ⚠️ 已废
- 新 5 按钮:约 / 送礼物 / 互聊 / 加速看广告 ▶ / 變為主要

【已废弃项 2】NPC tap → 'npc-req' modal:已废
- fps_0037 实为工作详情 modal "焊工"(底板 = 工作 list,跟 0040 同
  类,Vue 工程已用 JobDetailModal 实现),不是主菜单 NPC tap 触发
- HTML 真值里 .npcs 改纯装饰 aria-hidden,不再 click → modal
- 你沙箱里如果 Phase A 主菜单.html / 大掌柜.html 还有 npc-req 相关
  代码,以 GitHub 最新版为准清掉

【已废弃项 3】衣服 sub-tab "裤子 / 鞋" → "包 / 戒指 / 口红"(canonical
v2 校正后):衣服 5 个 2nd sub-tab 实为 帽子/上衣/包/戒指(配饰)/口红
(美妆),不是身体部位

【已废弃项 4】字符窗口第 3 sub-tab 🔒:已废
- 0105-0110 共 6 帧核查,sub-tab 数固定 = 2(交易/升级)

【已废弃项 5】月度结算 modal:不存在(机制不存在,不是没抽到)
- passive HUD-only 月度推进,跨月 2029→2030 始终主屏

⚠️ 任何新产出(HTML 真值 / Vue / data / canonical 文档)都不应包含
上述已废元素。看到沙箱里有 v1/v2 旧代码 → 不要复制 → 以 GitHub 最新
版 + canonical 为准重新写。


【任务范围】

7 帧 + 多 inline state:
- fps_0012 = 关系 list (4 NPC: 萝拉/贝拉/米丝/克西)
- fps_0013 = 关系详情(熟人段)— 5 互动按钮
- fps_0014 = 亲疏度升级 overlay(全屏粉心 ✨ + 段位大字)
- fps_0020 = 礼物 modal "做出选择"
- fps_0021 = 关系详情(送礼后,送礼按钮 CD 灰胶囊)
- fps_0022 = 约会地点 modal
- fps_0025 = 朋友段关系详情 + 约会进行中 overlay (00:15 倒计时)

加备用帧 inline state:
- fps_0015-0019 = "互聊"飘心粒子 inline 序列(❤ 累积 6→22→748)
- fps_0023/0024 = 约会进行中过渡动画(双爱心闪光 + 紫钻奖励飘字)
- fps_0033 = 朋友區段(新发现的第 3 档亲疏度,canonical 已记录)


【产出 4-5 件】

1. final/src/views/MeetList.vue   填实(当前 2 行 placeholder)
   - 4 NPC 卡 + 亲疏度 + 红 ! 角标

2. final/src/views/RelationDetail.vue   新增(fps_0013/0021/0025 三态合一)
   - 4 段式布局(顶 NPC 标题 / 亲疏度进度 + 里程碑 / 立绘 + 5 按钮 / 任务 list)
   - 5 互动按钮:约 / 送礼物 / 互聊 / 加速看广告 ▶ / 變為主要
   - 5 按钮各自 CD(00:01-数日,灰胶囊倒计时)
   - 段位三态:熟人 / 朋友 / 朋友區(任务集随段位变)
   - 飘心粒子动画(互聊点击触发)
   - 约会进行中 overlay(白卡 + 00:15 倒计时,覆盖按钮区)

3. 复用 9 共享 modal(canonical 已锁定,不重写):
   - OptionPickerModal(0020 礼物 + 0022 约会 共享)— 已建,只挂入口
   - UpgradeOverlay(0014 亲疏度升级)— 已建,只挂入口

4. final/src/data/relations.json   新增
   - 4 NPC 完整数据 + 礼物 list(6 项)+ 约会地点 list(4 项)+ 段位任务集
   - 古风化名(参照 Style Lock 古风对照表)

5. router.ts 加 /meet/:npcKey 路由,验证 BottomTabBar Tab 2 → /meet OK


【先读这些(canonical = 唯一真值)】

主屏布局 + inline state(PNG 真值,优先级最高):
  - design-brief/analysis/projectE_fps_0012.png  关系 list
  - design-brief/analysis/projectE_fps_0013.png  熟人段详情
  - design-brief/analysis/projectE_fps_0014.png  亲疏度升级 overlay
  - design-brief/analysis/projectE_fps_0020.png  礼物 modal
  - design-brief/analysis/projectE_fps_0021.png  送礼后 + CD 灰胶囊
  - design-brief/analysis/projectE_fps_0022.png  约会地点 modal
  - design-brief/analysis/projectE_fps_0025.png  朋友段 + 约会进行中 overlay

canonical 文档(spec / 数据 / 行为):
  - design-brief/flows/info-architecture.md (屏映射 + 时序 + ⚠️ 校正区)
  - design-brief/flows/screen-details.md (Tab 2 段)
  - design-brief/flows/screen-details-extras.md (C 组 0015-0019 飘心 +
    0017/0023/0024/0033 段位 + 0024 紫钻奖励)
  - design-brief/flows/screen-details-extras2.md (8 项 canonical v2 校正)
  - design-brief/flows/interaction-spec.md (Tab 2 关系段)
  - design-brief/SYNC_PROTOCOL.md (同步规约)

视觉真值(Phase A 锁定 + T-B1 风格延续):
  - final/Style Lock · 风格定档.html (色板 + 字号 v3.1 + 古风对照表)
  - final/Phase A · 主菜单 大掌柜.html (HUD / BottomTabBar 视觉真值)
  - final/大掌柜.html (T-B1 关系/工作/业务合并 HTML 真值预演,本轮 Vue 落实)
  - final/README.md (Phase A 锁定项 + 9 共享 modal 清单)
  - final/src/styles/tokens.css (色板 / 字号 / motion utility)
  - final/src/views/SkillList.vue (T-B1 已做,模仿其结构)
  - final/src/components/SkillAccelerateModal.vue (T-B1 9 共享之 9)


【强约束(继承 Phase A + T-B1)】

1. tokens.css = 唯一颜色 / 字号源
2. 9 共享 modal + 任何新建 modal 必须先加入 useModalStore ModalName union
   + ModalShell.vue map 注册
3. 印章 + 汉字 = 货币 icon 标准(玫瑰 / 甜甜圈 等礼物 icon 也走印章风)
4. modal scrim 锁定 rgba(0,0,0,.65) + backdrop-filter blur(8px)
5. 中文正文 ≥18px(v3.1)
6. canonical 跟 PNG 冲突时以 PNG 为准,然后更新 canonical
7. 已废弃项清单(见顶部 5 条) — 任何新产出都不应包含


【完成后告诉用户】

- 4 NPC 古风名(canonical 暂用萝拉/贝拉/米丝/克西,你可古风化)
- 关系详情 5 互动按钮古风文案
- 飘心粒子 inline 实现策略(Vue <transition> / Pinia toast queue)
- 约会进行中 overlay 实现策略(覆盖式 / 分屏式)
- 段位三档任务集差异化处理(熟人 / 朋友 / 朋友區)
- relations.json 数据结构

完成停下等用户验收。
```

---

## design 沙箱能读到的文档位置(我新发现的限制)

| 文档 | 位置 | design 可读? |
|---|---|---|
| canonical flows | `design-brief/flows/*` | ✅ |
| 抽帧 PNG | `design-brief/analysis/*` | ✅ |
| 同步规约 | `design-brief/SYNC_PROTOCOL.md` | ✅(新加) |
| Phase A HTML 真值 | `final/Phase A · 主菜单.html` 等 | ✅(沙箱 PAGES 概念) |
| Vue 工程 | `final/src/*` | ✅ |
| Style Lock | `final/Style Lock · 风格定档.html` | ✅ |
| 任务 prompt | `TASK_PROMPT_T_B*.md`(仓库根) | ❌ 看不到 |
| Bug 报告 | `BUG_REPORT_*.md`(仓库根) | ❌ 看不到 |
| KICKOFF | `KICKOFF_PROMPT.md`(仓库根) | ❌ 看不到 |
| 仓库根 SYNC_PROTOCOL | `SYNC_PROTOCOL.md` | ❌ 看不到 |

所有给 design 的指令 = 用户**复制粘贴整段** prompt,prompt 内容必须自包含,不能 ref 仓库根文档。

---

## Phase B 节奏

| 屏 | task | 状态 |
|---|---|---|
| T-B1 fps_0001/0002/0007 技能 (Tab 1) | ✅ 完成 |
| T-B2 fps_0012-0025 关系 (Tab 2) | ⏳ 本任务 |
| T-B3 fps_0036+0037+0040+0041 工作 DAG (Tab 3) | 待启动 |
| T-B4 fps_0046-0053 业务 (Tab 4) | 待启动 |
| T-B5 fps_0058-0062 投资 (Tab 5) | 待启动 |
| T-B6 fps_0065-0088 物品商店 (Tab 6) | 待启动 |
| T-B7+ 全局 modal | 待启动 |
