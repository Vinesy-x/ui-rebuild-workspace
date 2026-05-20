# projectE · 大掌柜 — 实时进度

> ⚠️ **design 沙箱开工前必拉这一份**(每个 task 都要)。一文知全局:项目快照 + 当前阶段 + 5 条已废清单 + 9 共享 modal 状态。
>
> raw URL: `https://raw.githubusercontent.com/<owner>/<repo>/main/projects/projectE/PROGRESS.md`

---

## 📋 项目快照(design 第一眼看这里就知道全局)

| 项 | 值 |
|---|---|
| **游戏** | 大掌柜(模拟、互动剧情,BitLife 类放置养成 + 经营)|
| **视觉** | 中国古代宋朝古风(江南水乡水墨彩绘)|
| **viewport** | 448×960 竖屏 |
| **抽帧** | 131 帧视频(`input/projectE.mp4`),50 selected + 81 备用全覆盖 |
| **风格定档** | `preview/Style Lock · 风格定档.html`(15 色 / 8 字阶 v3.1 / 9 货币印章 / 7 角标 / 27 古风对照 / motion 体系)— Phase A 锁定不再变 |
| **工程栈** | Vite + Vue 3(`<script setup>` + TS)+ Pinia + Vue Router |
| **Modal 模式** | 9 共享 modal + `useModalStore` + `<ModalShell>` + router.afterEach 自动 reset |
| **完整 KICKOFF 文档** | `projects/projectE/KICKOFF.md`(只 Phase A 启动时需要,Phase B 各屏看本文即可)|

文字内容**全部古风化**(详见 Style Lock 27 项对照,例:John Doyle → 王掌櫃 / 汽车修理工 → 馬車工匠 / 投资股票 → 票號商號股本 / 等)。

底栏 6 Tab(canonical 锁定):**技能 / 遇见 / 工作 / 业务 / 投资 / 物品**。

---

## 项目元信息(详细)

- **游戏名**:大掌柜
- **类型**:模拟、互动剧情(BitLife 类放置养成 + 经营)
- **视觉风格**:中国古代宋朝古风(江南水乡水墨彩绘)
- **viewport**:448×960 竖屏
- **抽帧来源**:130 帧视频(`input/projectE.mp4`)→ ffmpeg → phash 去重 → 83 张 dedup → 50 selected + 33 备用 + 48 raw 备用 = **131 张全覆盖**

---

## 当前阶段:**Phase B 进行中**(T-B1 / T-B2 完成,T-B3 待启动)

| 阶段 | 状态 | 备注 |
|---|---|---|
| Phase A T-A1(fps_0035 主菜单 + 风格定档)| ✅ 完成 | Style Lock 锁定:15 色 + 8 字阶 v3.1 + 9 货币 + 7 角标 + 27 古风对照 + motion 体系 |
| Phase B T-B1(fps_0001/02/07 技能 Tab 1)| ✅ 完成 | SkillList.vue 468 行 + SkillAccelerateModal 209 行 + skillList.json 13 技能 |
| **Phase B T-B2(fps_0012-0025 关系 Tab 2)** | ✅ **完成** | MeetList + RelationDetail 5 按钮 + 飘心 + 约会 overlay + relations.json |
| Phase B T-B3(fps_0036+0037+0040+0041 工作 DAG)| ⏳ **待启动** | 涉及 JobDetailModal(已建)+ JobPromoSplash(已建)+ 5 状态卡 + DAG 拓扑视觉 |
| Phase B T-B4(fps_0046-0053 业务 Tab 4)| 待 | BizHire / BizUpgrade modal |
| Phase B T-B5(fps_0058-0062 投资 Tab 5)| 待 | Bank info modal |
| Phase B T-B6(fps_0065-0088 物品 Tab 6)| 待 | PurchaseConfirm / AsyncWait / Cinematic 联动 |
| Phase B T-B7+(全局 modal:字符/目标/设置/幸福/健康/事件/商店货币)| 待 | 复用既有共享 modal |

---

## canonical 演进

- **当前版本**:v2(2026-05-20 校正后)
- **修订记录**:
  - v1:初版屏映射 + 50 张抽帧分析
  - v2 校正(8 agent + 6 agent 深度分析后):
    1. fps_0037 = 工作详情 modal "焊工"(同 0040 同类),非主菜单 NPC tap
    2. 关系详情 5 按钮(约/送礼物/互聊/加速看广告/變為主要),非 4 按钮
    3. 衣服 5 个 2nd sub-tab = 帽子/上衣/包/戒指/口红,非裤子鞋
    4. 字符窗口 sub-tab = 2(交易/升级),无第 3 个 🔒
    5. 月度结算 modal 不存在(passive HUD-only 月度推进)

## 5 条已知废弃项(每次 task prompt 顶部 inline)

| # | 废弃项 | 替代 |
|---|---|---|
| 1 | 关系详情 4 按钮(打个招呼/送礼物/雇佣/变为主要) | 5 按钮(约/送礼物/互聊/加速看广告/變為主要)|
| 2 | NPC tap → 'npc-req' modal | fps_0037 = 工作详情 modal(JobDetailModal,跟 0040 同类)|
| 3 | 衣服 sub-tab "裤子/鞋" | "包/戒指/口红" |
| 4 | 字符窗口第 3 sub-tab 🔒 | 仅 2 sub-tab |
| 5 | 月度结算 modal | 不存在(机制问题)|

---

## 9 共享 modal 组件(全部就位)

| # | 组件 | 用途 | 复用屏 |
|---|---|---|---|
| 1 | `ProgressListDialog` | 心境 + 體魄 共享 | fps_0123 + fps_0126 |
| 2 | `OptionPickerModal` | 礼物 + 约会 共享 | fps_0020 + fps_0022 |
| 3 | `PurchaseConfirmModal` | 食 + 居 + 大件 | fps_0075 + fps_0082 |
| 4 | `AsyncWaitModal` | 卖车 3 步链 | fps_0067/68/69 |
| 5 | `CinematicScene` | 大件购买过场 | fps_0077 |
| 6 | `UpgradeOverlay` | 亲疏度升级 | fps_0014 |
| 7 | `JobPromoSplash` | 工作促销 | fps_0041 |
| 8 | `JobDetailModal` | 工作详情(0037 焊工/0040 汽车修理工 同 widget)| canonical v2 校正后新增 |
| 9 | `SkillAccelerateModal` | 技能加速(每技能各一实例)| fps_0007 |

---

## 视觉真值锁定(Phase A)

放在 `projects/projectE/preview/`:
- `Phase A · 主菜单 大掌柜.html` — fps_0035 主菜单完整视觉
- `Style Lock · 风格定档.html` — 15 色 + 8 字阶 v3.1 + 9 货币印章 + 7 角标 + 27 古风对照
- `大掌柜.html` — Phase A + T-B1~T-B4 合并 HTML 真值预演

---

## 工程层(`projects/projectE/final/`)

- ✅ Vite + Vue 3(`<script setup>` + TS)+ Pinia + Vue Router
- ✅ `npm install && npm run dev` 可起
- ✅ `vite build` 实测通过(MainMenu css 15kB / SkillList 8.5kB / RelationDetail 7.9kB)
- ✅ 8 view(MainMenu / SkillList / MeetList / RelationDetail / 4 占位)
- ✅ 11 共享 component(9 modal + HudBar + BottomTabBar + ModalShell)
- ✅ 3 data(mainMenu.json / skillList.json / relations.json)
- ✅ router 7 路由(/main /skill /meet /meet/:npcKey /work /business /invest /items)

---

## bug 跟踪

| # | bug | 状态 | 报告 |
|---|---|---|---|
| Phase A 必修 1+2 | Vue scoped style 缺失 + fps_0037 归属错 | ✅ 修完 | `bugs/phase-a.md` |
| Phase A v2 follow-up | HTML 真值 NPC click 未清(8 处)| ✅ 修完(本地手动 + 大掌柜.html 加第 5 按钮)| `bugs/phase-a-v2-followup.md` |
| T-B1 import 漂移 | 4 处 NPC click 回滚 | ✅ commit 592b62c 清 |

**当前无未修 bug**

---

## design 沙箱历史 link

| commit | link 短码 | 任务 |
|---|---|---|
| `9edbf60` | `ifQlvXZGfmG4lFcjAmHI6A` | Phase A v2(2 项必修全修)|
| `68d7850` | `L_Pn9MIcbMnBxkGmRDQvQg` | T-B1 import |
| 该 link | `-Ucu5y3tFvBRd6zOEtlMiA` | (无改动,跟 v2 一致)|

---

## 下一步

**T-B3 工作 DAG**(`fps_0036` + `0037` + `0040` + `0041`):
- Vue:WorkDAG.vue 填实 + JobDetailModal(已建)挂入口 + JobPromoSplash(已建)挂入口
- 5 状态卡(可接/完成/FAIL/锁定/促销 ⚠ 黄角标)
- DAG 拓扑视觉:级 7→12 树状(每级 ≈3 卡 + 细灰斜/竖连线)
- 数据:7 个完整岗位(箱包工/直升机/焊工/服务员/汽车修理工/汽车检查员/代驾人)
