# T-B2 task prompt · Phase B 第 2 屏(fps_0012-0025 关系 Tab 2)

> 给 design 之前用户 checklist:
> - [ ] 确认 GitHub main 最新 commit
> - [ ] 把下面 ``` 整段发给 design
> - [ ] design 出 link → `./scripts/import-design.sh <link>` 拉本地

把下面 ``` 包起来的整段发给 design ⬇️

---

```
projectE · 大掌柜 — Phase B T-B2
fps_0012-0025 关系 Tab 2(7+ 帧,含约会子流)

⚠️ 开工前同步(必做,避免 canonical 漂移)⚠️

T-B1 import 后已发生 2 次 canonical 漂移(8 处 NPC click 反复回滚)。
开工前必读仓库根 SYNC_PROTOCOL.md,严格执行"开工前同步"清单。

核心原则:
- GitHub https://github.com/Vinesy-x/projectE main HEAD = 唯一真值
- 你沙箱里如果有跟 GitHub 不一致的旧版文件,以 GitHub 为准更新沙箱
- 不要复制粘贴沙箱里旧版"npc-req / 打个招呼 / 雇佣 / 裤子鞋"等已作废
  v1 代码到新产出
- 必读 SYNC_PROTOCOL.md 的"具体已知废弃项"清单

【任务范围】

7 帧 + 多 inline state:
- fps_0012 = 关系 list (4 NPC: 萝拉/贝拉/米丝/克西)
- fps_0013 = 关系详情(熟人段)— 5 互动按钮(canonical v2 校正后)
- fps_0014 = 亲疏度升级 overlay(全屏粉心 ✨ + 段位大字)
- fps_0020 = 礼物 modal "做出选择"
- fps_0021 = 关系详情(送礼后,送礼按钮 CD 灰胶囊)
- fps_0022 = 约会地点 modal
- fps_0025 = 朋友段关系详情 + 约会进行中 overlay (00:15 倒计时)

加备用帧 inline state:
- fps_0015-0019 = "互聊"飘心粒子 inline 序列(❤ 累积 6→22→748)
- fps_0023/0024 = 约会进行中过渡动画(双爱心闪光 + 紫钻奖励飘字)
- fps_0033 = 朋友區段(新发现的第 3 档亲疏度)

【产出 4-5 件】

1. final/src/views/MeetList.vue   填实(当前 2 行 placeholder)
   - 4 NPC 卡 + 亲疏度 + 红 ! 角标
   - 点 NPC → push 路由 /meet/:npcKey 进详情(单独 view)
   或:store.open('relation-detail', { npcKey }) 走 modal(看 design 判断)

2. final/src/views/RelationDetail.vue   新增(fps_0013/0021/0025 三态合一)
   - 4 段式布局(顶 NPC 标题 / 亲疏度进度 + 里程碑 / 立绘 + 5 按钮 / 任务 list)
   - 5 互动按钮(canonical v2 校正后):约 / 送礼物 / 互聊 / 加速看广告 ▶ / 變為主要
   - 5 按钮各自 CD(00:01-数日,灰胶囊倒计时)
   - 段位三态:熟人 / 朋友 / 朋友區(任务集随段位变)
   - 飘心粒子动画(互聊点击触发)
   - 约会进行中 overlay(白卡 + 00:15 倒计时,覆盖按钮区)

3. 复用 7+1+1 = 9 共享 modal(canonical 已锁定,不重写):
   - OptionPickerModal(0020 礼物 + 0022 约会 共享)— 已建,只挂入口
   - UpgradeOverlay(0014 亲疏度升级)— 已建,只挂入口

4. final/src/data/relations.json   新增
   - 4 NPC 完整数据 + 礼物 list(6 项)+ 约会地点 list(4 项)+ 段位任务集
   - 古风化名(参照 Style Lock 古风对照表)

5. (顺手) router.ts 加 /meet/:npcKey 路由(或 /relation/:npcKey),
   验证 BottomTabBar Tab 2 → /meet 跳转 OK

【先读这些(canonical = 唯一真值)】

主屏布局 + inline state:
  - design-brief/analysis/projectE_fps_0012.png  关系 list
  - design-brief/analysis/projectE_fps_0013.png  熟人段详情
  - design-brief/analysis/projectE_fps_0014.png  亲疏度升级 overlay
  - design-brief/analysis/projectE_fps_0020.png  礼物 modal
  - design-brief/analysis/projectE_fps_0021.png  送礼后 + CD 灰胶囊
  - design-brief/analysis/projectE_fps_0022.png  约会地点 modal
  - design-brief/analysis/projectE_fps_0025.png  朋友段 + 约会进行中 overlay

5 互动按钮(canonical v2 校正)+ 飘心粒子 inline + 朋友區段:
  - design-brief/flows/screen-details.md (Tab 2 段)
  - design-brief/flows/screen-details-extras.md (C 组 0015/16/18/19 飘心累积 +
    0017/0023/0024/0033 段位 + 0024 紫钻奖励)
  - design-brief/flows/screen-details-extras2.md (8 项 canonical v2 校正中关于
    关系 5 按钮)
  - design-brief/flows/interaction-spec.md (Tab 2 关系段)

视觉真值参考(Phase A 已锁定 + T-B1 风格延续):
  - 大掌柜.html(design 在 T-B1 已做 T-B2 关系 list / 详情的 HTML 真值预演,
    Vue 工程层这次落实)
  - final/Phase A · 主菜单.html(HUD / BottomTabBar 视觉真值)
  - final/Style Lock · 风格定档.html(色板 + 字号 v3.1 + 古风对照表)
  - final/README.md(Phase A 锁定项 + 9 共享 modal 清单)
  - final/src/styles/tokens.css(色板 / 字号 / motion utility)
  - final/src/views/SkillList.vue (T-B1 已做,模仿其结构组织 view)
  - final/src/components/SkillAccelerateModal.vue (T-B1 9 共享之 9, 模仿)

【强约束(继承 Phase A + T-B1)】

1. tokens.css = 唯一颜色 / 字号源
2. 9 共享 modal(8 + SkillAccelerateModal)+ 任何新建 modal 必须先加入
   useModalStore ModalName union + ModalShell.vue map 注册
3. 印章 + 汉字 = 货币 icon 标准(玫瑰 / 甜甜圈 / 饮料 等礼物 icon 也走印章风)
4. modal scrim 锁定
5. 中文正文 ≥18px(v3.1)
6. canonical 跟 PNG 冲突时以 PNG 为准,然后更新 canonical
7. ⚠️ 不要复制粘贴沙箱里旧版"打个招呼 / 雇佣 / npc-req"代码,这些已废

【完成后告诉用户】

- 4 NPC 古风名(canonical 暂用萝拉/贝拉/米丝/克西,你可古风化)
- 关系详情 5 互动按钮古风文案(约/送礼物/互聊/加速看广告/變為主要)
- 飘心粒子 inline 实现策略
- 约会进行中 overlay 实现策略(覆盖式还是分屏式)
- 段位三档任务集差异化处理
- relations.json 数据结构

完成停下等用户验收。
```

---

## Phase B 节奏

| 屏 | task | 状态 |
|---|---|---|
| T-B1 fps_0001/0002/0007 技能 (Tab 1) | ✅ 完成 |
| T-B2 fps_0012-0025 关系 (Tab 2) | ⏳ 本任务 |
| T-B3 fps_0036+0037+0040+0041 工作 DAG (Tab 3) | 待启动 |
| T-B4 fps_0046-0053 业务 (Tab 4) | 待启动 |
| T-B5 fps_0058-0062 投资 (Tab 5) | 待启动 |
| T-B6 fps_0065-0088 物品商店 含卖车 3 步 (Tab 6) | 待启动 |
| T-B7+ 全局 modal | 待启动 |
