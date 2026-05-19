# 工程模板规约

> **本文档替代 v1 的"散装 HTML"模式**。Design 的产出必须按 Vue 3 单文件组件(SFC)格式,放在已经初始化好的 `final/` Vite 工程里。

## 已就位的工程脚手架

`final/` 目录已用 `npm create vite@latest --template vue-ts` 初始化,装好了 Pinia + Vue Router。结构:

```
final/
├── package.json                # Vite + Vue 3 + TS + Pinia + Vue Router
├── vite.config.ts
├── index.html                  # 单入口
├── tsconfig.json / tsconfig.app.json / tsconfig.node.json
├── src/
│   ├── main.ts                 # createApp + Pinia + Router + 挂载
│   ├── App.vue                 # shell(.device-frame 448×960 + <RouterView />)
│   ├── router.ts               # 11 个屏路由(目前 10 个指向 Placeholder.vue)
│   ├── styles/
│   │   └── tokens.css          # CSS 自定义属性(待 Design 填,Phase A 完成)
│   ├── components/             # 跨屏共享组件(.vue SFC)— Design 提炼后填
│   │   └── README.md
│   ├── views/                  # 每屏一个 .vue SFC
│   │   ├── Home.vue            # 导航首页(已实现,作为示范)
│   │   ├── Placeholder.vue     # 占位屏(等被替换)
│   │   └── README.md
│   ├── data/                   # 数据驱动 JSON(待 Design 填)
│   │   └── README.md
│   └── assets/                 # SVG sprite / 图片
└── ...
```

## Design 产出的 4 类文件

| 类别 | 路径 | 内容 |
|---|---|---|
| **token** | `src/styles/tokens.css` | CSS 变量定义(色 / 字号 / 间距 / 圆角 / 阴影) |
| **共享组件** | `src/components/*.vue` | 多屏复用(Button、UnitCard、DialogShell、HUD 等)|
| **屏组件** | `src/views/*.vue` | 每个屏 1 个(MainMenu、DeckList、TalentDetail 等)|
| **数据 JSON** | `src/data/*.json` | 从 PNG 提取的单位/法术/装备/商品池 |

## 强约束(必须遵守)

### 1. token 集中定义,不许 hardcode

**❌ 错**:
```vue
<style scoped>
.btn-battle { background: #3A8FD8; color: #fff; }
</style>
```

**✅ 对**:
```css
/* src/styles/tokens.css */
:root {
  --color-cta-battle: #3A8FD8;
  --color-text-on-cta: #FFFFFF;
}
```
```vue
<style scoped>
.btn-battle { background: var(--color-cta-battle); color: var(--color-text-on-cta); }
</style>
```

### 2. 组件用 props 接收数据,不直接读 JSON

**❌ 错**(组件内部直接读数据):
```vue
<!-- UnitCard.vue 错的版本 -->
<script setup lang="ts">
import units from '@/data/units.json'  // ❌ 不要这样
const unit = units[0]
</script>
```

**✅ 对**:
```vue
<!-- UnitCard.vue 对的版本 -->
<script setup lang="ts">
const props = defineProps<{
  unit: { id: string; name: string; level: number; quality: string }
}>()
</script>
```

调用方:
```vue
<script setup lang="ts">
import units from '@/data/units.json'
import UnitCard from '@/components/UnitCard.vue'
</script>
<template>
  <UnitCard v-for="u in units" :key="u.id" :unit="u" />
</template>
```

### 3. 跨屏组件命名一致

Phase A 完成时把组件 + token 命名全部锁定。Phase B 不许:
- 同一按钮在两屏用不同 class 名
- 同一 token 在两处定义不同值
- 同一组件复制粘贴 N 次而不抽出 SFC

### 4. 跳转用 vue-router

```vue
<script setup lang="ts">
import { useRouter } from 'vue-router'
const router = useRouter()
</script>
<template>
  <button @click="router.push('/deck')">卡组</button>
</template>
```

跳转目标按 [`flows/interaction-spec.md`](flows/interaction-spec.md)。

### 5. SVG sprite,不要每屏复制 SVG

把所有 SVG 放到 `src/assets/icons.svg`(一个 sprite),组件用 `<use>` 引用:

```vue
<template>
  <svg class="icon"><use href="@/assets/icons.svg#icon-sword" /></svg>
</template>
```

或者用 `vite-plugin-svg-icons` 自动注入。

## Phase A 完成时的交付清单

### 工程文件(放到 final/ 里)

1. **`src/styles/tokens.css`** — 完整 token 定义(色 / 字号 / 间距 / 圆角 / 阴影)
2. **`src/assets/icons.svg`** — SVG sprite,含所有提炼到的图标(通用 + 具体单位/法术)
3. **`src/components/*.vue`** — 至少包含 T-A1 卡组列表用到的所有共享组件(`Button.vue` / `UnitCard.vue` / `HUD.vue` / `BottomTabBar.vue` 等)
4. **`src/views/DeckList.vue`** — T-A1 卡组列表屏的完整实现
5. **`src/data/units.json`** — 从 fps_0012 提取的所有单位(每只:id / 名字 / 等级 / 品质 / 解锁状态等)

### 文档同步(放到 design-brief/ 里)

6. **`design-brief/PHASE_A_LOCK.md`**(新建)— 列出 Phase A 锁定的内容:
   - token 命名清单(`--color-bg-scene`、`--font-size-title` 等)
   - 组件清单(`Button.vue` 有几个 variant,`UnitCard.vue` 接哪些 props)
   - SVG icon 清单(`icon-coin`、`icon-knight`、`icon-archer` ...)
   - 数据 schema(`units.json` 每条记录的字段)

Phase B 36 张就严格按这份清单做。

## Phase B 每屏完成时

输出:
1. 1 个 `.vue` 文件放到 `src/views/`
2. 如果新增了共享组件,放到 `src/components/`(并解释为什么必须新建)
3. 如果新增了数据,加到 `src/data/`(或扩展现有 JSON)
4. 1 张截图(在浏览器 `npm run dev` 跑起来截的,不是 mockup)
5. 元素 checklist + 交互行为 checklist(对照 `flows/interaction-spec.md`)

## 怎么跑

```bash
cd final
npm install      # 第一次
npm run dev      # 启动 http://127.0.0.1:5173/
npm run build    # 生产打包到 dist/
npm run preview  # 看 dist/ 效果
```

## 落地到 Claude Code 后(后期)

1. `cd final && code .` 用 IDE 打开
2. Claude Code 在 `final/` 接手:
   - 接 API 替换 `src/data/*.json`(改为 Pinia store + fetch)
   - 加业务逻辑(战斗算法、抽卡概率、用户登录)
   - 加测试(Vitest)
   - 打包成 PWA / Capacitor / Electron 上线
