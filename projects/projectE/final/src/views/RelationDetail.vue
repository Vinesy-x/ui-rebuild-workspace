<!--
  RelationDetail · fps_0013/0021/0025 三态合一 (Phase B T-B2)

  4 段式:
    HudBar (复用)
    screen-bar (← / NPC 名 / ✕)
    page:
      · 亲疏度进度条 + 3 里程碑(随段位变 lock/unlock)
      · 立绘 + 5 互动按钮(canonical v2:戲談/贈禮/約期/催情/立為主)
      · 要求任务 list(随段位变)
    BottomTabBar (复用)

  inline state:
    · 戲談 click → 飘心粒子 ❤ 累积浮起(0015-0019 揭示)
    · 贈禮 click → openModal('gift-picker')(0020)
    · 約期 click → openModal('date-picker')(0022)→ 接受后约会进行中 overlay
    · 催情 click → 看广告占位(monetization,canonical v2 新增)
    · 立為主 click → triggerUpgrade(下一段位)(全屏 UpgradeOverlay)
    · 5 按钮 click 后变 CD 灰胶囊(00:01-00:15)

  约会进行中 overlay:白卡覆盖 .rel-actions 区域 + "約會進行中" + 倒计时
-->
<script setup lang="ts">
import { ref, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import HudBar       from '../components/HudBar.vue'
import BottomTabBar from '../components/BottomTabBar.vue'
import { useModalStore } from '../stores/useModalStore'
import mainMenu from '../data/mainMenu.json'
import relData  from '../data/relations.json'

const route  = useRoute()
const router = useRouter()
const store  = useModalStore()

const hud = computed(() => ({ ...mainMenu.hud, date: { era: '崇寧', day: '廿五', m: '秋' } }))

const npc = computed(() => {
  const key = route.params.npcKey as string
  return relData.npcs.find(n => n.key === key) || relData.npcs[0]
})
const stage = computed(() => (relData.stages as any)[npc.value.stage])
const heart = computed(() => npc.value.heart)
const heartMax = computed(() => stage.value.heartMax || 1700)
const heartPct = computed(() => Math.min(100, (heart.value / heartMax.value) * 100))

// 5 互动按钮 CD state (key → 剩余秒, 0 = 可用)
const cdMap = ref<Record<string, number>>({})
function startCd (key: string, sec: number) {
  cdMap.value[key] = sec
  const t = setInterval(() => {
    cdMap.value[key]--
    if (cdMap.value[key] <= 0) { clearInterval(t); delete cdMap.value[key] }
  }, 1000)
}
function fmtCd (sec: number) {
  const m = Math.floor(sec / 60); const s = sec % 60
  return `${String(m).padStart(2, '0')}:${String(s).padStart(2, '0')}`
}

// 飘心粒子 (戲談 click 触发)
const hearts = ref<{ id: number; x: number; y: number }[]>([])
let heartSeq = 0
function spawnHearts (count = 3) {
  for (let i = 0; i < count; i++) {
    const id = ++heartSeq
    hearts.value.push({ id, x: 40 + Math.random() * 30, y: 50 + Math.random() * 30 })
    setTimeout(() => { hearts.value = hearts.value.filter(h => h.id !== id) }, 1400)
  }
}

// 约会进行中 overlay
const dating = ref<{ active: boolean; remain: number; date: string }>({
  active: false, remain: 0, date: ''
})
function startDate (dateOption: any) {
  dating.value = { active: true, remain: dateOption.duration || 15, date: dateOption.name }
  const t = setInterval(() => {
    dating.value.remain--
    if (dating.value.remain <= 0) {
      clearInterval(t)
      dating.value.active = false
      // 升段(演示)
      store.open('upgrade-overlay', { motif: 'heart', label: '友' })
    }
  }, 1000)
}

// 5 按钮 click 路由
function actClick (key: string) {
  if (cdMap.value[key] > 0) return  // CD 中,无效
  if (key === 'chat')    { spawnHearts(5); startCd('chat', 2); return }
  if (key === 'gift')    { startCd('gift', 2); store.open('gift-picker', { title: '做出選擇', options: relData.gifts }); return }
  if (key === 'date')    { startCd('date', 15); store.open('date-picker', { title: '做出選擇', options: relData.dates, showRecommend: false }); return }
  if (key === 'ad')      { /* 看广告占位 · 跳过所有 CD */ Object.keys(cdMap.value).forEach(k => delete cdMap.value[k]); return }
  if (key === 'promote') { store.open('upgrade-overlay', { motif: 'heart', label: '主' }); return }
}
</script>

<template>
  <div class="screen" :data-screen-label="`关系详情 · fps_0013 (${npc.name} · ${stage.label})`">
    <HudBar v-bind="hud" :charName="mainMenu.character.name" />

    <div class="screen-bar">
      <button class="sb-back" @click="router.push('/meet')" title="返回 缘份">‹</button>
      <div class="sb-title">{{ npc.name }}</div>
      <button class="sb-close" @click="router.push('/main')">✕</button>
    </div>

    <div class="rel-page paper-grain">
      <!-- 亲疏度进度条 + 3 里程碑 -->
      <div class="rel-progress">
        <div class="rt">
          <span class="rt-name">{{ npc.name }}</span>
          <span class="rt-sep">·情份:</span>
          <span class="rt-stage" :class="`stg-${npc.stage}`">{{ stage.label }}</span>
        </div>
        <div class="bar-row">
          <span class="heart-num">{{ heart }}／{{ heartMax >= 1000 ? (heartMax / 1000) + 'k' : heartMax }}</span>
          <div class="bar"><div class="bar-fill" :style="{ width: heartPct + '%' }"></div></div>
        </div>
        <div class="miles">
          <div v-for="m in relData.milestones" :key="m.key" class="mile is-locked">
            <div class="seal" :class="`bg-${m.color}`">{{ m.seal }}</div>
            <div class="tip">{{ m.tip }}</div>
          </div>
        </div>
      </div>

      <!-- 立绘 + 5 互动按钮 -->
      <div class="rel-main">
        <div class="illu">
          立绘 placeholder<br/>
          <span class="ph">{{ npc.name }} · {{ stage.label }}(Phase B 替换)</span>
        </div>

        <div class="actions">
          <button v-for="act in relData.actions" :key="act.key"
                  class="rel-act"
                  :class="{ 'is-cd': cdMap[act.key] > 0, 'is-ad': act.kind === 'monetization' }"
                  :title="act.hint || act.canonical"
                  @click="actClick(act.key)">
            <template v-if="cdMap[act.key] > 0">
              <span class="cd-pill">{{ fmtCd(cdMap[act.key]) }}</span>
            </template>
            <template v-else>
              <span class="lbl">{{ act.name }}</span>
              <span v-if="act.kind === 'monetization'" class="ad-tri">▶</span>
            </template>
          </button>
        </div>

        <!-- 飘心粒子 inline (戲談 触发) -->
        <transition-group name="floater" tag="div" class="floater-layer">
          <span v-for="h in hearts" :key="h.id" class="floater" :style="{ left: h.x + '%', top: h.y + '%' }">❤</span>
        </transition-group>

        <!-- 约会进行中 overlay (覆盖 actions 区) -->
        <transition name="fade">
          <div v-if="dating.active" class="date-overlay">
            <div class="d-card">
              <div class="d-title">約會進行中</div>
              <div class="d-name">{{ dating.date }}</div>
              <div class="d-bar"><div class="d-fill" :style="{ width: (1 - dating.remain / 15) * 100 + '%' }"></div></div>
              <div class="d-time">{{ fmtCd(dating.remain) }}</div>
            </div>
          </div>
        </transition>
      </div>

      <!-- 任务 list -->
      <div class="tasks-head">要&nbsp;求</div>
      <div v-for="t in npc.tasks" :key="t.key" class="task" :class="`is-${t.state}`">
        <div class="t-seal" :class="`seal-${t.key}`">{{ t.seal }}</div>
        <div class="t-lbl">{{ t.label }} <span class="t-num">{{ t.num }}</span></div>
        <div v-if="t.state === 'ok'" class="t-ok">✓</div>
        <button v-else-if="t.state === 'go'" class="t-go" @click="actClick('gift')">→</button>
        <div v-else></div>
      </div>

      <!-- 朋友區段额外按钮(canonical v2 0033 揭示) -->
      <div v-if="npc.stage === 'main'" class="extra-actions">
        <button class="ex-act" title="约出门">約</button>
        <button class="ex-act" title="邀请 · 特殊事件">邀請<span class="bang">!</span></button>
      </div>
    </div>

    <BottomTabBar />

    <!-- 调试:测试约会启动(canonical demo 用) -->
    <!-- 实际上约会通过 date-picker modal "接受" 触发,但 modal 关闭后回不到这里,
         所以这里给个测试入口让用户能看 overlay 效果 -->
    <button class="demo-date" @click="startDate(relData.dates[0])" title="测试约会 overlay">演示</button>
  </div>
</template>

<style scoped>
/* .screen / .screen-bar / .sb-title / .sb-close / .sb-back 走全局 components.css */

/* page */
.rel-page {
  overflow-y: auto; padding: 12px 12px 80px;
  position: relative;
}

/* 亲疏度进度 */
.rel-progress {
  background: var(--paper-2);
  border: 1px solid var(--paper-edge);
  border-radius: 8px;
  padding: 12px 14px;
  margin-bottom: 12px;
  box-shadow: var(--sh-card);
}
.rt { font-family: var(--font-display); font-size: var(--fs-h2); display: flex; align-items: baseline; gap: 8px; }
.rt-name { color: var(--ink-1); }
.rt-sep { color: var(--ink-3); font-size: var(--fs-meta); }
.rt-stage { font-size: var(--fs-h2); margin-left: 2px; }
.stg-stranger { color: var(--ink-3); }
.stg-known    { color: var(--celadon-3); }
.stg-friend   { color: var(--jade); }
.stg-main     { color: var(--cinnabar-1); }

.bar-row { display: grid; grid-template-columns: 90px 1fr; gap: 10px; margin-top: 10px; align-items: center; }
.heart-num { font-family: var(--font-num); font-size: var(--fs-meta); color: var(--ink-3); }
.bar { height: 12px; background: var(--paper-3); border: 1px solid var(--paper-edge); border-radius: 6px; overflow: hidden; position: relative; }
.bar-fill {
  height: 100%;
  background: linear-gradient(90deg, var(--cinnabar-2), var(--cinnabar-1));
  transition: width var(--dur-modal) var(--ease-out);
}
.miles { display: flex; gap: 16px; margin-top: 12px; justify-content: space-around; }
.mile { display: flex; flex-direction: column; align-items: center; gap: 4px; }
.mile.is-locked { opacity: .5; }
.mile .seal {
  width: 28px; height: 28px; border-radius: 4px;
  display: grid; place-items: center;
  font-family: var(--font-display); color: var(--paper-1);
  font-size: 14px;
}
.bg-cur-mood  { background: var(--cur-mood); color: var(--ink-1) !important; }
.bg-cur-heart { background: var(--cur-heart); }
.bg-cur-coin  { background: var(--cur-coin); }
.mile .tip { font-family: var(--font-num); font-size: var(--fs-micro); color: var(--ink-3); }

/* 主区:立绘 + 5 按钮 */
.rel-main {
  display: grid;
  grid-template-columns: 1fr 110px;
  gap: 12px;
  background: var(--paper-2);
  border: 1px solid var(--paper-edge);
  border-radius: 8px;
  padding: 12px;
  margin-bottom: 12px;
  position: relative;
}
.illu {
  background: var(--paper-3);
  border: 1px dashed var(--paper-edge);
  border-radius: 6px;
  display: grid; place-items: center;
  font-family: var(--font-display); color: var(--ink-3);
  padding: 16px;
  font-size: var(--fs-meta); text-align: center;
  min-height: 200px;
}
.illu .ph { font-size: var(--fs-micro); opacity: .7; display: block; margin-top: 6px; }

.actions { display: flex; flex-direction: column; gap: 6px; }
.rel-act {
  background: var(--jade); color: var(--paper-1);
  border: 1.5px solid var(--ink-1);
  border-radius: 6px;
  padding: 8px 10px;
  font-family: var(--font-display); font-size: var(--fs-label);
  letter-spacing: .12em;
  cursor: pointer;
  position: relative;
  box-shadow: 0 2px 0 var(--ink-1);
  transition: transform var(--dur-fast) var(--ease-out);
}
.rel-act:active { transform: translateY(1px); box-shadow: 0 1px 0 var(--ink-1); }
.rel-act.is-cd  { background: var(--ink-4); cursor: not-allowed; }
.rel-act.is-cd  .cd-pill { font-family: var(--font-num); font-size: var(--fs-meta); letter-spacing: 0; }
.rel-act.is-ad  { background: var(--amber); color: var(--ink-1); }
.rel-act.is-ad  .ad-tri { margin-left: 4px; font-size: 12px; }

/* 飘心粒子 */
.floater-layer { position: absolute; inset: 0; pointer-events: none; }
.floater {
  position: absolute;
  font-size: 24px;
  color: var(--cinnabar-1);
  text-shadow: 0 0 6px rgba(168, 95, 69, 0.4);
  animation: heart-float 1.4s ease-out;
  user-select: none;
}
@keyframes heart-float {
  0%   { opacity: 0; transform: translateY(0) scale(.5); }
  20%  { opacity: 1; transform: translateY(-10px) scale(1.1); }
  100% { opacity: 0; transform: translateY(-60px) scale(.8); }
}
.floater-leave-active { transition: opacity .3s; }
.floater-leave-to { opacity: 0; }

/* 约会进行中 overlay */
.date-overlay {
  position: absolute;
  inset: 0;
  background: rgba(245, 235, 214, 0.92);
  backdrop-filter: blur(2px);
  display: grid; place-items: center;
  border-radius: 8px;
  z-index: 5;
}
.d-card {
  background: var(--paper-1);
  border: 1.5px solid var(--cinnabar-1);
  border-radius: 8px;
  padding: 16px 24px;
  text-align: center;
  box-shadow: var(--sh-card);
}
.d-title { font-family: var(--font-display); font-size: var(--fs-h2); color: var(--cinnabar-1); letter-spacing: .15em; }
.d-name  { font-family: var(--font-display); font-size: var(--fs-h3); color: var(--ink-1); margin: 4px 0 10px; }
.d-bar   { height: 8px; background: var(--paper-3); border: 1px solid var(--paper-edge); border-radius: 4px; overflow: hidden; }
.d-fill  { height: 100%; background: var(--cinnabar-1); transition: width 1s linear; }
.d-time  { font-family: var(--font-num); font-size: var(--fs-meta); color: var(--ink-3); margin-top: 6px; }
.fade-enter-active, .fade-leave-active { transition: opacity .3s; }
.fade-enter-from, .fade-leave-to { opacity: 0; }

/* 任务 list */
.tasks-head { font-family: var(--font-display); font-size: var(--fs-h3); color: var(--ink-2); letter-spacing: .2em; margin: 4px 4px 8px; }
.task {
  display: grid;
  grid-template-columns: 36px 1fr 32px;
  gap: 10px;
  align-items: center;
  background: var(--paper-2);
  border: 1px solid var(--paper-edge);
  border-radius: 6px;
  padding: 8px 12px;
  margin-bottom: 6px;
}
.t-seal {
  width: 28px; height: 28px;
  background: var(--paper-3); color: var(--ink-2);
  border: 1px solid var(--paper-edge);
  border-radius: 4px;
  font-family: var(--font-display); font-size: 14px;
  display: grid; place-items: center;
}
.t-lbl { font-family: var(--font-serif); font-size: var(--fs-body); color: var(--ink-1); }
.t-num { font-family: var(--font-num); font-size: var(--fs-meta); color: var(--ink-3); margin-left: 6px; }
.t-ok  { color: var(--jade); font-size: 18px; font-weight: bold; }
.t-go  {
  background: var(--azure); color: var(--paper-1);
  border: 1.5px solid var(--ink-1); border-radius: 50%;
  width: 28px; height: 28px; font-size: 14px;
  cursor: pointer;
}

/* 朋友區段额外按钮 */
.extra-actions {
  display: flex; gap: 10px; margin: 12px 4px 0;
}
.ex-act {
  flex: 1;
  background: var(--cinnabar-1); color: var(--paper-1);
  border: 1.5px solid var(--ink-1);
  border-radius: 6px;
  padding: 10px;
  font-family: var(--font-display); font-size: var(--fs-h3);
  cursor: pointer;
  position: relative;
}
.ex-act .bang {
  position: absolute; top: -6px; right: -6px;
  width: 18px; height: 18px;
  background: var(--fail-red); color: var(--paper-1);
  border: 1.5px solid var(--paper-1); border-radius: 50%;
  font-family: var(--font-display); font-size: 11px;
  display: grid; place-items: center;
}

/* 调试 演示 按钮 */
.demo-date {
  position: absolute;
  right: 8px; bottom: 96px;
  background: var(--paper-2);
  border: 1px dashed var(--paper-edge);
  border-radius: 4px;
  padding: 4px 8px;
  font-family: var(--font-num); font-size: var(--fs-micro);
  color: var(--ink-3);
  cursor: pointer;
  z-index: 4;
}
</style>
