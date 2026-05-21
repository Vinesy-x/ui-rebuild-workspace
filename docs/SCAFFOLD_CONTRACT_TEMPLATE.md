# scaffold-contract · 模板

> 复制到 `projects/<name>/handoff/spec/scaffold-contract.md`,改 `{{...}}` 占位符。
> 每次 Claude scaffold 新 .vue 时,**同步更新这份 contract**(单一真值)。
> design 拉 handoff/ 时这是它**第二份必看**文档(PROGRESS.md 之后)。

---

# scaffold-contract · scaffold 暴露给 template 的所有 binding

> ⭐ design 沙箱开工前**先看这一份**,而不是凭空猜 binding 名。
> Claude 维护这份文档,确保跟 `final/src/views/*.vue` 和 `final/src/components/*.vue` 的 `<script setup>` 段 100% 一致。
> design 写 template 时**只用这里列的 binding**,不要假设 scaffold 有别的。

---

## 每个 .vue 一段(Claude 按这个模板填)

### `views/{{XxxView}}.vue`

#### refs / computed(直接用 · 已 reactive)

| binding | 类型 | 含义 |
|---|---|---|
| `{{name}}` | `Ref<{{T}}>` 或 `ComputedRef<{{T}}>` | {{含义}} |
| ... | ... | ... |

#### 常量(直接用)

| binding | 类型 | 值 / 含义 |
|---|---|---|

#### 方法(template `@click` 用)

| method | 行为 |
|---|---|

#### helper(`@click` 或 `:class` 用)

| helper | 签名 | 行为 |
|---|---|---|

---

### `components/{{XxxModal}}.vue`

#### props(由 `modal.open('xxx', { ... })` 传 · template 直接读)

| binding | 类型 | 含义 |
|---|---|---|

#### click handler

| method | 行为 |
|---|---|

---

## 通用约定(workspace 级 · 所有项目共用)

1. **不用 $emit / defineEmits** · modal 通过 import store 直接调 action · 不用 emit 上抛
2. **不要在 template 里 import 任何文件** · scaffold 都 import 好了
3. **不要在 template 里 `ref()`** · 所有 reactive state 都在 script · template 只用
4. **数据 JSON 字段名固定** · 在 contract 各 view 的 props 段列明
5. **缺什么不要私自加** · 在 `_design-notes.md` 风险段提"建议 scaffold 加 X" → Claude 下一轮扩

---

## 命名约定(workspace 级)

- 布尔 ref 用 `is*` prefix:`isRunning` / `isLoading` / `isOpen` 等
- 数值 ref 用具体名:`timeLeft` / `completedToday` / `nextMinutes`
- 字符串 computed 用 `*Label` 或 `*Text` suffix:`modeLabel` / `subText`
- helper 函数小驼峰:`pipClass(i)` / `formatDuration(s)`
- click handler 用 `on*` prefix(modal)或动词原型(view):`onContinue` / `toggle` / `reset`

---

## 实例参考

`projects/projectF/handoff/spec/scaffold-contract.md` 是 v1 落地版(Pomodoro Phase 0)。
