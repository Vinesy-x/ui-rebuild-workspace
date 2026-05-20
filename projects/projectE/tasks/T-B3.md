# T-B3 task prompt · Phase B 第 3 屏(fps_0036/0037/0040/0041 工作 Tab 3)

> 给 design 之前 checklist:
> - [ ] 确认 GitHub main 最新 commit
> - [ ] 把下面 ``` 整段发给 design,或者用短指令让它拉 raw URL
> - [ ] design 出 link → `./scripts/import-design.sh <link>` 拉本地

把下面 ``` 包起来的整段发给 design ⬇️

---

```
projectE · 大掌柜 — Phase B T-B3
fps_0036 + 0037 + 0040 + 0041 工作 Tab 3(DAG 拓扑 + 工作详情 modal + promo splash)


⚠️⚠️⚠️ 开工前同步(必做)⚠️⚠️⚠️

你的沙箱状态 ≠ GitHub 真值。每次新 task 必须主动拉 GitHub 最新版
覆盖沙箱旧版,否则会出现 canonical 漂移(已发生 2 次回滚事故)。

repo = https://github.com/Vinesy-x/ui-rebuild-workspace  branch = main
raw URL 模板 = https://raw.githubusercontent.com/Vinesy-x/ui-rebuild-workspace/main/<path>


【步骤 1 — 第一时间拉项目全局(新会话 / 新沙箱必做)】

主动拉:
- projects/projectE/PROGRESS.md  ⭐⭐⭐
  → 看顶部「项目快照」一表知全局:游戏 = 大掌柜 / 视觉 = 宋朝古风 /
     viewport 448×960 / 工程栈 Vite+Vue3+Pinia / 9 共享 modal /
     底栏 6 Tab / 文字古风化 / 5 条已废清单 / 当前阶段 = T-B3 待启动

如果是首次接触 projectE(沙箱里没有任何文件),还要拉:
- projects/projectE/KICKOFF.md
  → 完整项目背景(只首次需要,后续靠 PROGRESS 即可)


【步骤 2 — 拉 canonical 演进最新版】

- projects/projectE/design-brief/flows/info-architecture.md
- projects/projectE/design-brief/flows/interaction-spec.md
- projects/projectE/design-brief/flows/screen-details.md
- projects/projectE/design-brief/flows/screen-details-extras.md
- projects/projectE/design-brief/flows/screen-details-extras2.md
- projects/projectE/design-brief/flows/topology.html


【步骤 3 — 拉视觉真值 + 工程层】

- projects/projectE/preview/(整个目录 — Phase A 主菜单 / Style Lock /
  大掌柜.html 合并预演中已含 T-B3 工作 DAG HTML 视觉雏形,可参考)
- projects/projectE/final/(整个目录递归 — T-B1 SkillList / T-B2 MeetList +
  RelationDetail / 9 共享 modal 全部就位)


【步骤 4 — workspace 级规约(首次拉一次即可)】

- docs/DIRECTORY_CONVENTION.md      (目录约定 — preview 放 HTML 真值,link 用 ../final/)
- docs/SYNC_PROTOCOL.md
- docs/COLLABORATION_PROTOCOL.md


拉完 → 沙箱里跟 GitHub 不一致的全部覆盖 → 以 GitHub 为准。


⚠️ 5 条已知废弃项(canonical v2 后,严格遵循不要重新引入):
1. 关系详情 4 按钮(打个招呼/送礼物/雇佣/变为主要)→ 5 按钮(约/送礼物/互聊/加速看广告/變為主要)
2. NPC tap → 'npc-req' modal:作废,fps_0037 实为工作详情 modal(用 JobDetailModal,跟 0040 同类)
3. 衣服 sub-tab "裤子/鞋" → "包/戒指/口红"
4. 字符窗口第 3 sub-tab 🔒 → 仅 2 sub-tab(交易/升级)
5. 月度结算 modal → 不存在(passive HUD-only 月度推进)


【任务范围】

4 帧 + 多 inline state:
- fps_0036 = 工作 list DAG 拓扑(级 7→12 树状,5 状态卡)
- fps_0037 = 工作详情 modal "焊工"(canonical v2 校正后:用 JobDetailModal,跟 0040 同 widget 不同工种)
- fps_0040 = 工作详情 modal "汽车修理工"(同 JobDetailModal,不同 props)
- fps_0041 = 工作 promo splash(用 JobPromoSplash,canonical 已有此组件)

5 状态卡(canonical 锁定):
- 可接(亮 + 价 + 蓝绿"接受" CTA)→ tap → JobDetailModal
- 完成 ✓(绿勾 + "完成"标签)→ 节点保留作解锁源
- FAIL(红 FAIL 角标 + "重用" 按钮)→ 重试入口
- 锁定(❓ + ???)→ 前置未达成
- 促销(黄 ⚠ 角标)→ tap → JobPromoSplash → 再 tap → JobDetailModal

DAG 拓扑视觉:
- 级 7 / 8 / 9 / 10 / 11 / 12(每级 ≈3 卡 + 细灰斜/竖连线父子关系)
- 完成上游 → 解锁下游
- 7 个完整岗位(canonical 已挖掘):箱包工 1K / 直升机 1.40K / 焊工 1.40K /
  服务员 1.43K / 汽车修理工 1.43K(级 10 黄⚠ 促销)/ 汽车检查员 1.76K /
  代驾人 1.85K-1.95K(级 12)

JobDetailModal 已建(canonical v2 后):props 已设计为 `{ jobKey, requirements[] }`,
覆盖 0037 焊工 + 0040 汽车修理工 + 后续所有工种,共用一个 widget。

JobPromoSplash 已建:0041 汽车修理工 promo,黄字大标题 + 立绘 + 月薪 1404 高亮,无 CTA。


【产出 4-5 件】

1. final/src/views/WorkDAG.vue   填实(当前 15 行 placeholder)
   - 顶 HudBar(复用)
   - 屏标 "工作" / "差事" + ✕ 返回 /main
   - 滚动区 DAG 拓扑:级 7→12 树状布局,5 状态卡 + 细灰连线
   - 底 BottomTabBar(复用,Tab 3 active)

2. JobDetailModal.vue 已建,只需在 WorkDAG.vue 挂入口:
   - 5 状态卡 click(可接 / 促销路径)→ store.open('job-detail', { jobKey })

3. JobPromoSplash.vue 已建,只需挂入口:
   - 黄 ⚠ 促销卡 click → store.open('job-promo', { jobKey, monthlyWage })
   - 再 tap promo 后 → 自动转 job-detail

4. final/src/data/workList.json   新增
   - 7 岗位 + 级别 + 月薪 + 状态 + 5 项要求(住房/食物/运输/前置/属性)
   - 古风化命名(参照 Style Lock 古风对照表 + 已用过的"服务员→跑堂"/
     "焊工→銅銲匠"/"銀匠→銀匠" 等)
   - DAG 父子关系(每岗位 prereq: [parentJobKey])

5. (可选,顺手)preview/大掌柜.html 已有 T-B3 工作 DAG HTML 视觉雏形 +
   JobDetail/Promo modal 定义。如发现跟 canonical v2 (JobDetailModal
   共用)有差距,顺手补,但不必重写。


【强约束(继承 Phase A + T-B1/B2,不重写)】

1. tokens.css = 唯一颜色 / 字号源
2. 9 共享 modal 走 useModalStore(JobDetailModal + JobPromoSplash 已在 ModalShell 注册)
3. 印章 + 汉字 = 货币 icon 标准
4. modal scrim 锁定 rgba(0,0,0,.65) + backdrop-filter blur(8px)
5. 中文正文 ≥18px(v3.1)
6. canonical 跟 PNG 冲突时以 PNG 为准,然后更新 canonical
7. 已废弃项不要重新引入


【完成后告诉用户】

- 7 个岗位的最终古风名(canonical 推荐:跑堂/銅銲匠/馬車工匠/銀匠/檢者/驅車人/箱袋匠/直升运货 等,你可定)
- DAG 拓扑视觉策略(连线用什么:细灰斜线 / 毛笔笔触 / 卷轴折痕 / 等)
- 5 状态卡角标视觉(可接/完成/FAIL/锁/黄⚠ 促销 的具体颜色 + 印章字)
- JobDetailModal 在 0037 焊工 + 0040 汽车修理工 上的实例数据
- 顺便更新 PROGRESS.md 标记 T-B3 ✅


完成停下等用户验收。
```

---

## 用法

### 方式 A — 整段复制粘贴(稳)
打开本文件,复制上面 ``` 块整段粘给 design 沙箱。

### 方式 B — 短指令 + raw URL(轻量)
```
继续做 T-B3。拉:
https://raw.githubusercontent.com/Vinesy-x/ui-rebuild-workspace/main/projects/projectE/tasks/T-B3.md
完成出 link
```

design 自己拉 task prompt 文件 + 按 prompt 步骤 1-4 拉全局上下文 + canonical + 工程层。

---

## Phase B 节奏(完成后更新 PROGRESS.md)

| 屏 | task | 状态 |
|---|---|---|
| T-B1 fps_0001/0002/0007 技能 (Tab 1) | ✅ 完成 |
| T-B2 fps_0012-0025 关系 (Tab 2) | ✅ 完成 |
| **T-B3 fps_0036+0037+0040+0041 工作 DAG (Tab 3)** | ⏳ 本任务 |
| T-B4 fps_0046-0053 业务 (Tab 4) | 待启动 |
| T-B5 fps_0058-0062 投资 (Tab 5) | 待启动 |
| T-B6 fps_0065-0088 物品 (Tab 6) | 待启动 |
| T-B7+ 全局 modal | 待启动 |
