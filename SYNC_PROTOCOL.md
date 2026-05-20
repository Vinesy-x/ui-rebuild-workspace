# SYNC_PROTOCOL · design 沙箱 ↔ GitHub 同步规约

> 解决问题:design 沙箱跟 GitHub repo 是**两套独立状态**,不会自动同步。
>
> 已观察的回滚事故 2 次:
> - commit `3a81c3b`:我清 Phase A.html 4 处 NPC click → T-B1 import 后又回来(沙箱版本覆盖)
> - commit `592b62c`:再清一次 + 大掌柜.html 4 处共 8 处 → 如果不立规,T-B2 import 后还会回滚
>
> 此规约写入仓库根,**每个 Phase B task prompt 顶部必须 ref 这个文件**,让 design 在做之前先同步。

---

## 核心事实(给 design 看)

1. **沙箱状态 ≠ GitHub 真值**
   - design 你在沙箱里做改动 → 沙箱 snapshot tarball → 用户 `import-design.sh` rsync 到本地 → push GitHub
   - **反方向不自动**:GitHub 上有变动(用户手动改 / 别的 task 改的 canonical)→ **你沙箱不会自动拉到**
   - **你能主动从 GitHub 拉任何文件**(用 raw URL `https://raw.githubusercontent.com/Vinesy-x/projectE/main/<path>`),**但不会自动拉,必须 prompt 明确指令你拉**
   - 如果不拉,你沙箱里的旧文件会被你"复制粘贴" 到新产出 → 用户 import 时 rsync --delete 覆盖本地 → canonical 漂移

2. **GitHub = 唯一真值**
   - 任何冲突以 GitHub main 分支当前 HEAD 为准
   - 沙箱里如果有跟 GitHub 不一致的文件,**主动拉 GitHub 最新版覆盖沙箱**
   - 不要复制粘贴沙箱里的"旧版" 内容到新产出

3. **canonical 演进**
   - canonical 文档(`design-brief/flows/*.md` + `design-brief/flows/*.html`)由 Claude 维护,Push 到 GitHub
   - 每次新 task 开始前,**主动从 GitHub raw URL 拉 canonical 最新版**作为依据
   - 看到任何 ⚠️ "校正" / "作废" / "废弃" 标注 → 严格遵循,不要重新引入

---

## 给 design 的"开工前同步" 指令(每个 task prompt 顶部 inline)

⚠️ 这一段必须 inline 在每个 task prompt 文本里,不能用"读 SYNC_PROTOCOL.md"这种 ref(沙箱默认状态没拉就读不到):

```
开工前同步(必做):

repo = https://github.com/Vinesy-x/projectE  branch = main
raw URL 模板 = https://raw.githubusercontent.com/Vinesy-x/projectE/main/<path>

1. 主动从 GitHub raw URL 拉下列文件最新版,覆盖你沙箱里对应文件:

   canonical 演进 + 已知废弃项:
   - design-brief/SYNC_PROTOCOL.md
   - design-brief/flows/info-architecture.md
   - design-brief/flows/interaction-spec.md
   - design-brief/flows/screen-details.md
   - design-brief/flows/screen-details-extras.md
   - design-brief/flows/screen-details-extras2.md
   - design-brief/flows/topology.html

   HTML 真值(已清过 8 处 NPC click + 字号 v3.1):
   - final/Phase A · 主菜单 大掌柜.html
   - final/Style Lock · 风格定档.html
   - final/大掌柜.html

   Vue 工程层(T-B1 已落实):
   - final/src/(整个目录递归)
   - final/README.md

2. 拉取完成 → 沙箱里跟 GitHub 不一致的全部覆盖 → 以 GitHub 为准
3. 读 design-brief/SYNC_PROTOCOL.md(刚拉到的最新版)
4. 严格执行 5 条已知废弃项,不要重新引入
5. 写新产出时,从 GitHub 最新版作基底开始,不要复制沙箱里旧版代码

具体已知废弃项(2026-05-20 canonical v2 + follow-up 后):
- 'npc-req' modal:作废(fps_0037 实为工作详情 modal,跟 0040 同类,
  Vue 已用 JobDetailModal 实现)
- 关系详情 4 按钮(打个招呼/送礼物/雇佣/变为主要)
  → 5 按钮(约/送礼物/互聊/加速看广告/變為主要)
- 衣服 sub-tab "裤子/鞋" → "包/戒指/口红"
- 字符窗口第 3 sub-tab 🔒 → 作废(仅 2 sub-tab)
- 月度结算 modal → 不存在(passive HUD-only 月度推进)
```

---

## 给 Claude(我)的"import 后" 防漂移 checklist

每次 `./scripts/import-design.sh` 完后:

```
1. 跑 git diff 看改动
2. 对照 BUG_REPORT_*.md + SYNC_PROTOCOL.md 已知废弃项,grep 沙箱新产出:
   - grep -E "npc-req|data-act=\"open:npc-req\"" → 应 0(只有作废注释)
   - grep -E "打个招呼" 关系系统 → 应 0(已废)
   - grep -E "字符窗口.{0,15}3 sub-tab" → 应 0(已废)
3. 如果发现回滚 → 立刻本地清 → commit → 下次 task prompt 再次提醒
4. commit message 记录"canonical 漂移源头 = 沙箱旧版" 让事故可追踪
```

---

## 治本方案(长期)

`import-design.sh` 不再用 `rsync --delete`,改用 3-way merge:
- 把 design 沙箱产出当作 "feature branch"
- 本地手动改的(NPC click 清理之类)当作 "main"
- merge 时让用户决策冲突

但目前 1-way rsync 仍是默认,**靠规约 + checklist 治标**。

---

## 历史回滚事故 log

| 日期 | commit | 事故 |
|---|---|---|
| 2026-05-20 | `3a81c3b` | 清 Phase A.html 4 处 NPC click |
| 2026-05-20 | T-B1 import (`68d7850`) | 4 处全回滚(沙箱里 design 没修)|
| 2026-05-20 | `592b62c` | 再清 8 处(Phase A.html 4 + 大掌柜.html 4)|
| 待发生 | T-B2 import | 如不立 SYNC_PROTOCOL,还会再回滚 |

