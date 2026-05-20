<!--
  SkillList · fps_0001 技能 list (Phase B T-B1)
  13 技能(5 解锁 + 8 锁定) · 顶部 2 booster · 主动技能大卡 + ▶/加速 · 锁定行
  升级 trans (fps_0002) = inline Vue <transition> (非 modal) · 加速 = useModalStore('skill-accelerate')
-->
<script setup lang="ts">
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import HudBar       from '../components/HudBar.vue'
import BottomTabBar from '../components/BottomTabBar.vue'
import { useModalStore } from '../stores/useModalStore'
import mainMenu from '../data/mainMenu.json'
import skillData from '../data/skillList.json'

const store = useModalStore()
const router = useRouter()

const hud = computed(() => ({ ...mainMenu.hud, date: { era: '崇寧', day: '廿四', m: '秋' } }))

// 升级飘字 (fps_0002) — 演示用,绑定到第 1 技能 (膂力)
const showUpgrade = ref(false)
function triggerUpgradeDemo (key: string) {
  showUpgrade.value = true
  setTimeout(() => { showUpgrade.value = false }, 1600)
}
function openAccel (s: any) {
  store.open('skill-accelerate', {
    skillKey: s.key,
    skillName: s.name,
    multiplier: skillData.accelerate.multiplier,
    cost: skillData.accelerate.cost
  })
}
function fmtTime (sec: number) {
  const m = Math.floor(sec / 60); const ss = sec % 60
  return `${String(m).padStart(2,'0')}分:${String(ss).padStart(2,'0')}秒`
}
</script>

<template>
  <div class="skill" data-screen-label="技能 list · fps_0001">
    <HudBar v-bind="hud" :charName="mainMenu.character.name" />

    <!-- 屏标 -->
    <div class="screen-bar">
      <div class="sb-spacer"></div>
      <div class="sb-title">技&nbsp;&nbsp;能</div>
      <button class="sb-close" @click="router.push('/main')">✕</button>
    </div>

    <!-- 内容滚动区 -->
    <div class="page paper-grain">

      <!-- booster 行: 2 颗丹 -->
      <div class="boosters">
        <button v-for="b in skillData.boosters" :key="b.key" class="booster" :class="b.tone" :title="b.desc">
          <span class="seal seal--md">{{ b.glyph }}</span>
          <span class="plus">+</span>
        </button>
      </div>

      <!-- 主动 (leveling) 技能大卡 -->
      <template v-for="s in skillData.skills" :key="s.key">
        <div v-if="s.state === 'leveling'" class="card active" @click="triggerUpgradeDemo(s.key)">
          <div class="ic-col">
            <span class="seal seal--lg" :class="`tone-${s.tone}`">{{ s.glyph }}</span>
            <span class="lv">級 {{ s.level }}</span>
          </div>
          <div class="mid">
            <div class="name-row">
              <span class="name">{{ s.name }}</span>
              <span class="cost"><span class="seal seal--sm cur cur-coin">銅</span>{{ s.monthly }}／月</span>
            </div>
            <div class="bar-track">
              <div class="bar-fill" :style="{width: (s.progress*100)+'%'}"></div>
              <span class="bar-tip">升&nbsp;！</span>
            </div>
          </div>
          <button class="play pause" @click.stop>‖‖</button>
          <button class="accel-btn" :class="'tone-azure'" @click.stop="openAccel(s)">
            <span class="dial-mini"><span class="needle"></span><span class="plus">+</span></span>
            <span class="lab">加速</span>
            <span class="bang">!</span>
          </button>

          <!-- 升级飘字 trans (fps_0002) -->
          <transition name="upgrade">
            <div v-if="showUpgrade" class="upgrade-pop">
              <div class="trophy">爵</div>
              <div class="lv-up">+1</div>
              <div class="ribbon">+2 級進境</div>
            </div>
          </transition>
        </div>

        <!-- 训练中 (training) 行 -->
        <div v-else-if="s.state === 'training'" class="card row" @click="triggerUpgradeDemo(s.key)">
          <div class="ic-col">
            <span class="seal seal--lg" :class="`tone-${s.tone}`">{{ s.glyph }}</span>
            <span class="lv">級 {{ s.level }}</span>
          </div>
          <div class="mid">
            <div class="name-row">
              <span class="name">{{ s.name }}</span>
              <span class="cost"><span class="seal seal--sm cur cur-coin">銅</span>{{ s.monthly }}／月</span>
            </div>
            <div class="bar-track">
              <div class="bar-fill" :style="{width: (s.progress*100)+'%'}"></div>
              <span class="bar-time">{{ fmtTime(s.duration) }}</span>
            </div>
          </div>
          <button class="play" @click.stop>▶</button>
          <button class="accel-btn" @click.stop="openAccel(s)">
            <span class="dial-mini"><span class="needle"></span><span class="plus">+</span></span>
            <span class="lab">加速</span>
          </button>
        </div>

        <!-- 锁定行 -->
        <div v-else class="card locked">
          <span class="lock-ic">鎖</span>
          <div class="mid">
            <div class="name">{{ s.name }}</div>
            <div class="lock-meta">
              收集 <span class="seal seal--sm cur cur-star">星</span>{{ s.starCost }} 啟用
            </div>
          </div>
        </div>
      </template>

      <div class="bottom-fade"></div>
    </div>

    <BottomTabBar />
  </div>
</template>

<style scoped>
.skill {
  position: absolute; inset: 0;
  display: grid;
  grid-template-rows: 80px 44px 1fr 90px;
  background: var(--paper-1);
}

/* 屏标 (modal-bar 简化版,因不是 modal) */
.screen-bar {
  background: var(--celadon-3);
  color: var(--paper-1);
  display: grid;
  grid-template-columns: 44px 1fr 44px;
  align-items: center;
  position: relative;
  border-bottom: 1px solid var(--wood-2);
  box-shadow: 0 1px 0 var(--gold-1);
}
.screen-bar::after {
  content: ""; position: absolute; bottom: -6px; left: 50%; transform: translateX(-50%);
  width: 60%; height: 6px; background: var(--wood-1);
  clip-path: polygon(0 0, 10% 100%, 90% 100%, 100% 0);
}
.sb-title {
  font-family: var(--font-display);
  font-size: 22px;
  letter-spacing: .35em;
  text-align: center;
  padding-left: .35em;
}
.sb-close {
  width: 28px; height: 28px;
  border: 1.5px solid var(--paper-1);
  border-radius: 50%;
  background: transparent;
  color: var(--paper-1);
  font-size: 16px;
  cursor: pointer;
  justify-self: center;
}

/* 滚动区 */
.page {
  overflow-y: auto;
  padding: 14px 12px 24px;
  background:
    radial-gradient(circle at 20% 30%, rgba(139,111,71,.04) 0, transparent 30%),
    var(--paper-1);
}

/* booster 行 */
.boosters {
  display: flex; justify-content: center; gap: 18px;
  margin: 4px 0 14px;
}
.booster {
  width: 54px; height: 54px;
  background: var(--paper-2);
  border: 1.5px solid var(--paper-edge);
  border-radius: 8px;
  display: grid; place-items: center;
  position: relative;
  cursor: pointer;
  box-shadow: var(--sh-card);
  transition: transform var(--dur-fast) var(--ease-pop);
}
.booster .seal { background: var(--jade); }
.booster .plus {
  position: absolute; right: -4px; bottom: -4px;
  width: 20px; height: 20px;
  background: var(--jade);
  color: var(--paper-1);
  border: 1.5px solid var(--paper-1);
  border-radius: 50%;
  font-family: var(--font-display); font-size: 16px;
  display: grid; place-items: center;
  box-shadow: 0 1px 0 rgba(0,0,0,.2);
}
.booster:active { transform: translateY(1px); }

/* 卡 通用 */
.card {
  background: var(--paper-2);
  border: 1.5px solid var(--paper-edge);
  border-radius: 8px;
  display: grid;
  align-items: center;
  margin-bottom: 8px;
  box-shadow: var(--sh-card);
  position: relative;
  padding: 8px 10px;
}
.card.row, .card.active {
  grid-template-columns: 60px 1fr 36px 56px;
  gap: 8px;
}
.card.active {
  background: var(--celadon-3);
  border-color: var(--wood-2);
  color: var(--paper-1);
  box-shadow: var(--sh-card), inset 0 1px 0 rgba(255,255,255,.1);
}
.card.locked {
  grid-template-columns: 60px 1fr;
  gap: 8px;
  background: var(--paper-3);
  opacity: .85;
}

.ic-col { display: flex; flex-direction: column; align-items: center; gap: 4px; }
.ic-col .seal { font-size: 22px; }
.tone-cinnabar { background: var(--cinnabar-1) !important; }
.tone-jade     { background: var(--jade) !important; }
.tone-azure    { background: var(--azure) !important; }
.tone-amber    { background: var(--amber) !important; }
.tone-celadon  { background: var(--celadon-1) !important; }
.tone-wood     { background: var(--wood-1) !important; }
.ic-col .lv {
  font-family: var(--font-display); font-size: 14px;
  color: inherit; opacity: .85; letter-spacing: .04em;
}

.mid { min-width: 0; }
.name-row { display: flex; align-items: baseline; justify-content: space-between; gap: 8px; }
.name { font-family: var(--font-display); font-size: var(--fs-h2); letter-spacing: .04em; color: inherit; }
.cost {
  font-family: var(--font-num); font-size: var(--fs-meta);
  color: var(--ink-3); display: inline-flex; align-items: center; gap: 4px;
}
.card.active .cost { color: var(--paper-3); }
.cost .seal { width: 16px; height: 16px; font-size: 11px; }
.cur-coin  { background: var(--cur-coin);  color: var(--paper-1); }
.cur-star  { background: var(--cur-star);  color: var(--ink-1); }

/* 进度条 */
.bar-track {
  margin-top: 6px;
  height: 18px;
  background: var(--paper-3);
  border: 1px solid var(--paper-edge);
  border-radius: 4px;
  position: relative;
  overflow: hidden;
}
.card.active .bar-track {
  background: rgba(0,0,0,.25);
  border-color: rgba(0,0,0,.4);
}
.bar-fill {
  position: absolute; left:0; top:0; bottom:0;
  background: linear-gradient(180deg, var(--jade) 0%, #406F50 100%);
  box-shadow: inset 0 1px 0 rgba(255,255,255,.25);
  transition: width var(--dur-base);
}
.bar-time {
  position: absolute; inset: 0;
  display: grid; place-items: center;
  font-family: var(--font-num);
  font-size: var(--fs-meta);
  color: var(--ink-1);
  letter-spacing: .03em;
}
.card.active .bar-time { color: var(--paper-1); }
.bar-tip {
  position: absolute; inset: 0;
  display: grid; place-items: center;
  font-family: var(--font-display);
  font-size: var(--fs-h2);
  color: var(--paper-1);
  letter-spacing: .2em;
}

/* play / pause btn */
.play {
  width: 36px; height: 36px;
  border-radius: 6px;
  background: var(--paper-1);
  border: 1.5px solid var(--azure);
  color: var(--azure);
  font-family: var(--font-display);
  font-size: 18px;
  cursor: pointer;
  display: grid; place-items: center;
}
.play.pause {
  background: var(--paper-1);
  color: var(--ink-1);
  border-color: var(--ink-1);
  font-size: 13px;
  letter-spacing: -.04em;
}

/* 加速 btn (仪表盘 mini) */
.accel-btn {
  position: relative;
  width: 56px; height: 56px;
  background: var(--paper-1);
  border: 1.5px solid var(--paper-edge);
  border-radius: 8px;
  display: flex; flex-direction: column; align-items: center; justify-content: center;
  gap: 2px;
  cursor: pointer;
  box-shadow: var(--sh-card);
}
.accel-btn .lab {
  font-family: var(--font-display);
  font-size: 12px;
  color: var(--ink-2);
  letter-spacing: .05em;
  line-height: 1;
}
.dial-mini {
  position: relative;
  width: 32px; height: 18px;
  border-radius: 16px 16px 0 0;
  background:
    conic-gradient(from 270deg,
      var(--jade) 0deg 30deg,
      var(--amber) 30deg 60deg,
      var(--cinnabar-1) 60deg 90deg,
      transparent 90deg 360deg);
  border: 1.5px solid var(--ink-1);
  border-bottom: none;
}
.dial-mini .needle {
  position: absolute; left: 50%; bottom: 0;
  width: 2px; height: 12px;
  background: var(--ink-1);
  transform-origin: 50% 100%;
  transform: translateX(-50%) rotate(28deg);
  border-radius: 1px;
}
.dial-mini .plus {
  position: absolute; right: -6px; bottom: -2px;
  width: 14px; height: 14px;
  background: var(--jade);
  color: var(--paper-1);
  border: 1.5px solid var(--paper-1);
  border-radius: 50%;
  font-family: var(--font-display);
  font-size: 12px;
  display: grid; place-items: center;
  line-height: 1;
}
.accel-btn .bang {
  position: absolute; top: -5px; right: -5px;
  width: 16px; height: 16px;
  background: var(--cinnabar-1); color: var(--paper-1);
  border: 1.5px solid var(--paper-1);
  border-radius: 50%;
  font-family: var(--font-display); font-size: 13px;
  display: grid; place-items: center;
  line-height: 1;
}

/* 锁定行 */
.card.locked .lock-ic {
  width: 38px; height: 38px;
  background: var(--ink-4); color: var(--paper-1);
  border: 1.5px solid var(--ink-3);
  border-radius: 50%;
  display: grid; place-items: center;
  font-family: var(--font-display); font-size: 18px;
  justify-self: center;
}
.card.locked .name {
  color: var(--ink-3);
}
.card.locked .lock-meta {
  margin-top: 4px;
  font-family: var(--font-num); font-size: var(--fs-meta);
  color: var(--ink-3);
  display: inline-flex; align-items: center; gap: 4px;
}
.card.locked .lock-meta .seal { width: 16px; height: 16px; font-size: 11px; }

/* 升级飘字 trans (fps_0002) */
.upgrade-pop {
  position: absolute; left: 50%; top: 0;
  transform: translateX(-50%);
  display: flex; flex-direction: column; align-items: center;
  pointer-events: none;
  z-index: 5;
}
.upgrade-pop .trophy {
  width: 44px; height: 44px;
  background: linear-gradient(180deg, var(--gold-2), var(--cur-coin));
  border: 2px solid var(--paper-1);
  border-radius: 50%;
  font-family: var(--font-display);
  font-size: 24px;
  color: var(--cinnabar-3);
  display: grid; place-items: center;
  box-shadow: 0 4px 12px rgba(0,0,0,.35);
}
.upgrade-pop .lv-up {
  margin-top: -6px;
  background: var(--cinnabar-1);
  color: var(--paper-1);
  font-family: var(--font-display);
  font-size: 14px;
  padding: 1px 8px;
  border-radius: var(--r-pill);
  border: 1.5px solid var(--paper-1);
  letter-spacing: .05em;
}
.upgrade-pop .ribbon {
  margin-top: 8px;
  background: var(--jade);
  color: var(--paper-1);
  font-family: var(--font-display);
  font-size: 15px;
  padding: 3px 14px;
  border-radius: var(--r-pill);
  border: 1.5px solid var(--paper-1);
  box-shadow: 0 4px 8px rgba(0,0,0,.25);
  letter-spacing: .06em;
  position: relative;
}
.upgrade-pop .ribbon::before {
  content: "";
  position: absolute; top: -6px; left: 50%; transform: translateX(-50%);
  border: 4px solid transparent; border-bottom-color: var(--jade);
}

.upgrade-enter-active { animation: popIn var(--dur-modal) var(--ease-pop) both; }
.upgrade-leave-active { animation: fadeOut var(--dur-base) var(--ease-in) both; }

.bottom-fade { height: 24px; }
</style>
