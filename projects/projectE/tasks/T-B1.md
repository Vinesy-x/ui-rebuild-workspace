# T-B1 task prompt · Phase B 第 1 屏(fps_0001 技能 list)

> Phase A 完全收尾,启动 Phase B。
> 工作流:design 出 link → `./scripts/import-design.sh <link>` 拉本地 verify → commit / bug 报告 → 新 link

把下面 ``` 包起来的整段发给 design ⬇️

---

```
projectE · 大掌柜 — Phase B T-B1
fps_0001 + fps_0002 + fps_0007(底栏 Tab 1 技能)

【任务范围】

3 帧:
- fps_0001 = 技能 list(主屏)
- fps_0002 = 升级飘字 trans(inline,不是 modal)
- fps_0007 = 加速 modal(每技能一个,共享 SkillAccelerateModal)

【产出 4 件】

1. final/src/views/SkillList.vue   填实(当前是 2 行 placeholder)
2. final/src/components/SkillAccelerateModal.vue   新增,在 ModalShell 的 map
   注册 'skill-accelerate' → SkillAccelerateModal(useModalStore 已有 name)
3. final/src/data/skillList.json   新增,13 技能数据(从 canonical 提取)
4. 验证 BottomTabBar Tab 1 click → /skill 跳转 OK,router.afterEach 自动 close
   modal 也 OK

【先读这些(canonical = 唯一真值,不要复制到代码注释)】

主屏布局 + inline state:
  - design-brief/analysis/projectE_fps_0001.png        主屏
  - design-brief/analysis/projectE_fps_0002.png        升级飘字
  - design-brief/analysis/projectE_fps_0007.png        加速 modal

13 技能完整数据 + 3 档解锁价 + 香烟 chip 道具系统 + 加速激活 inline 运行态:
  - design-brief/flows/screen-details.md (fps_0001-0007 段)
  - design-brief/flows/screen-details-extras.md (α 组 0005/0006/0008/0010/0011)
  - design-brief/flows/interaction-spec.md (Tab 1 技能段)
  - design-brief/flows/info-architecture.md (屏映射 + 时序)

视觉真值 + tokens + 古风化对照(27+ 项):
  - final/Style Lock · 风格定档.html (色板 / 字号 v3.1 / 货币印章 / 古风对照表)
  - final/Phase A · 主菜单 大掌柜.html (HudBar / BottomTabBar 视觉真值 + 已建 modal 模式)
  - final/README.md (Phase A 锁定项 + 8 共享组件清单 + Modal 3 档尺寸)
  - final/src/styles/tokens.css (色板 + 字号 + motion utility)

【强约束(继承 Phase A,不重写)】

1. tokens.css = 唯一颜色 / 字号源
2. 9 共享 modal(8 + SkillAccelerateModal)走 useModalStore,不允许各屏写
3. 印章 + 汉字 = 货币 icon 标准
4. modal scrim 锁定 rgba(0,0,0,.65) + backdrop-filter blur(8px)
5. 中文正文 ≥18px(v3.1)
6. canonical 跟 PNG 冲突时以 PNG 为准,然后更新 canonical

【完成后告诉用户】

- 13 技能 (5 解锁 + 8 锁定) 你最终敲定的古风名字(canonical 给了建议,你可调)
- 加速 modal 视觉(仪表盘 icon / 6 紫晶按钮颜色)
- 升级飘字 + 加速激活 inline 实现策略(Vue <transition> 还是 Pinia toast queue)
- 顶部 2 强化按钮(绿瓶+ / 绿电池)视觉占位方案
- 整屏背景 / 卡片底色 / 列表行底色

完成停下等用户验收(`npm run dev` → 切到 /skill 看)。
```

---

## 给 design 之前自检

- [x] Phase A 完全收尾(Vue 工程跑通 / canonical 对齐 / Style Lock 锁定)
- [x] canonical 已记录 13 技能 + 3 档解锁价 + inline state + 古风化对照
- [x] useModalStore 已有 'skill-accelerate' modal name(Phase A 占位)
- [x] router 已有 /skill 路由 + SkillList.vue 2 行占位
- [ ] 把上面 ``` 整段发给 design
- [ ] design 出 link → 跑 `./scripts/import-design.sh <link>` 拉本地

## Phase B 节奏

| 屏 | task | 状态 |
|---|---|---|
| T-B1 fps_0001/0002/0007 技能 (Tab 1) | ⏳ 本任务 |
| T-B2 fps_0012-0025 关系 (Tab 2) | 待启动 |
| T-B3 fps_0036+0037+0040+0041 工作 DAG (Tab 3) | 待启动 |
| T-B4 fps_0046-0053 业务 (Tab 4) | 待启动 |
| T-B5 fps_0058-0062 投资 (Tab 5) | 待启动 |
| T-B6 fps_0065-0088 物品商店 含卖车 3 步 (Tab 6) | 待启动 |
| T-B7+ 全局 modal(字符 / 目标 / 设置 / 幸福 / 健康 / 事件 / 商店 货币) | 待启动 |
