<!--
  WorkDAG · fps_0036 工作 DAG (Phase B T-B3)
  级 1→11 树状拓扑 · 13 岗位 5 状态卡 + 细灰竖连线
  - 完成 (is-done) : 绿勾 + 完成 CTA · 节点保留作解锁源
  - 可接 (default) : 蓝绿"接受" CTA → JobDetailModal(jobKey)
  - 进行中 (is-active) : 进度条 35/100 · 银作演示
  - FAIL (is-fail) : 红 × + "重用" CTA · 流商 / 文牘吏
  - 锁定 (is-locked) : ❓ + ??? · 前置未达成
  车坊匠 (级 10) = 換職事 promo 触发点 · click → JobPromoSplash → 二次 tap → JobDetailModal
-->
<script setup lang="ts">
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import HudBar       from '../components/HudBar.vue'
import BottomTabBar from '../components/BottomTabBar.vue'
import { useModalStore } from '../stores/useModalStore'
import mainMenu from '../data/mainMenu.json'
import workData from '../data/workList.json'

const router = useRouter()
const store  = useModalStore()

interface JobReq { ic: string; lbl: string; num?: string; ok: boolean }
interface Job {
  name: string
  illu: string
  level: number
  price: string
  priceVal?: number
  status: 'done' | 'accept' | 'active' | 'fail' | 'locked'
  prereq: string | null
  illuHint?: string
  reqs?: JobReq[]
  progress?: { cur: number; total: number }
  promo?: { prevWage: number; wage: number; delta: string }
  _canonicalMap?: string
}

const jobs   = workData.jobs as Record<string, Job>
const levels = workData.dagLevels

const hud = computed(() => ({
  ...mainMenu.hud,
  coin:      workData.screen.hudOverrides.coin      ?? mainMenu.hud.coin,
  mood:      workData.screen.hudOverrides.mood      ?? mainMenu.hud.mood,
  moodDelta: workData.screen.hudOverrides.moodDelta ?? mainMenu.hud.moodDelta,
  date:      workData.screen.date
}))

function pickJob (jobKey: string) {
  const j = jobs[jobKey]
  if (!j || j.status === 'locked') return

  // 车坊匠 = 換職事 promo target · 先 splash 再 detail
  if (j.promo) {
    store.open('job-promo', {
      jobName:     j.name,
      monthlyWage: j.promo.wage,
      illu:        j.illuHint,
      // promo splash 内置 nextModalName=job-detail · 二次 tap 转 detail
      nextProps:   { jobKey, jobName: j.name, monthlyWage: j.promo.wage, illu: j.illuHint, requirements: j.reqs || [] }
    })
    return
  }

  store.open('job-detail', {
    jobKey,
    jobName:      j.name,
    monthlyWage:  j.priceVal,
    illu:         j.illuHint,
    requirements: j.reqs || []
  })
}

function progressPct (j: Job) {
  if (!j.progress) return 0
  return Math.round((j.progress.cur / j.progress.total) * 100)
}
</script>

<template>
  <div class="work" data-screen-label="工作 DAG · fps_0036">
    <HudBar v-bind="hud" :charName="mainMenu.character.name" />

    <div class="screen-bar">
      <div></div>
      <div class="sb-title" v-html="workData.screen.title"></div>
      <button class="sb-close" @click="router.push('/main')">✕</button>
    </div>

    <div class="wk-page paper-grain">
      <div v-for="lv in levels" :key="lv.level" class="wk-level">
        <div class="wk-level-lab" v-html="lv.label"></div>

        <template v-for="(slot, idx) in lv.slots" :key="lv.level + '-' + idx">
          <div v-if="!slot" class="wk-card is-empty"></div>

          <div v-else
               class="wk-card"
               :class="{
                 'is-done':   jobs[slot].status === 'done',
                 'is-fail':   jobs[slot].status === 'fail',
                 'is-active': jobs[slot].status === 'active',
                 'is-locked': jobs[slot].status === 'locked',
                 'is-promo':  !!jobs[slot].promo && jobs[slot].status !== 'done' && jobs[slot].status !== 'locked'
               }"
               @click="pickJob(slot)">
            <span v-if="jobs[slot].status === 'done'" class="wk-done-tick">✓</span>
            <span v-if="jobs[slot].promo && jobs[slot].status === 'accept'" class="wk-card-bang">⚠</span>

            <div class="wk-card-name">{{ jobs[slot].name }}</div>
            <div class="wk-card-illu">{{ jobs[slot].illu }}</div>

            <div v-if="jobs[slot].status === 'locked'" class="wk-card-lock-q">???</div>

            <div v-else-if="jobs[slot].priceVal" class="wk-card-price">
              <span class="ic-seal">銅</span>{{ jobs[slot].price }}
            </div>

            <div v-if="jobs[slot].status === 'active' && jobs[slot].progress" class="wk-card-progress">
              <div class="bar"><i :style="{ width: progressPct(jobs[slot]) + '%' }"></i></div>
              <div class="ratio">{{ jobs[slot].progress.cur }}／{{ jobs[slot].progress.total }}</div>
            </div>

            <div v-else-if="jobs[slot].status === 'done'"   class="wk-card-cta">完&nbsp;成</div>
            <div v-else-if="jobs[slot].status === 'fail'"   class="wk-card-cta">重&nbsp;用</div>
            <div v-else-if="jobs[slot].status === 'accept'" class="wk-card-cta">接&nbsp;受</div>
          </div>
        </template>
      </div>

      <div class="bottom-fade"></div>
    </div>

    <BottomTabBar />
  </div>
</template>

<style scoped>
.work {
  position: absolute; inset: 0;
  display: grid;
  grid-template-rows: 80px 44px 1fr 90px;
  background: var(--paper-1);
}

.screen-bar {
  background: var(--celadon-3);
  color: var(--paper-1);
  display: grid; grid-template-columns: 44px 1fr 44px;
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
.sb-title { font-family: var(--font-display); font-size: 22px; letter-spacing: .35em; text-align: center; padding-left: .35em; }
.sb-close {
  width: 28px; height: 28px;
  border: 1.5px solid var(--paper-1); border-radius: 50%;
  background: transparent; color: var(--paper-1);
  font-size: 16px; cursor: pointer; justify-self: center;
}

.wk-page {
  overflow: auto;
  padding: 12px 4px 24px;
  background: var(--paper-1);
  scrollbar-width: thin;
  scrollbar-color: var(--paper-edge) transparent;
}
.wk-page::-webkit-scrollbar { width: 6px; height: 6px; }
.wk-page::-webkit-scrollbar-thumb { background: var(--paper-edge); border-radius: 3px; }

.wk-level {
  display: grid;
  grid-template-columns: 44px repeat(3, 1fr);
  gap: 14px 12px;
  align-items: stretch;
  padding: 10px 6px;
  position: relative;
}
.wk-level-lab {
  align-self: center;
  font-family: var(--font-display);
  font-size: 14px;
  color: var(--ink-3);
  background: var(--paper-2);
  border: 1px solid var(--paper-edge);
  border-radius: var(--r-pill);
  padding: 4px;
  text-align: center;
  letter-spacing: .04em;
  position: sticky;
  left: 4px;
  z-index: 6;
  box-shadow: 1px 0 0 var(--paper-edge);
  line-height: 1.1;
}

.wk-card {
  background: var(--paper-2);
  border: 1.5px solid var(--paper-edge);
  border-radius: 8px;
  padding: 6px 4px 4px;
  text-align: center;
  cursor: pointer;
  position: relative;
  box-shadow: var(--sh-card);
  transition: transform var(--dur-fast) var(--ease-out);
  min-height: 90px;
  display: flex; flex-direction: column;
  justify-content: space-between; align-items: center;
}
.wk-card:active { transform: scale(.97); }
.wk-card-name {
  font-family: var(--font-display);
  font-size: 13px;
  color: var(--ink-2);
  line-height: 1.1;
  margin-bottom: 2px;
  letter-spacing: .02em;
}
.wk-card-illu {
  width: 44px; height: 36px;
  margin: 2px auto;
  background: var(--paper-3);
  border: 1px solid var(--paper-edge);
  border-radius: 6px;
  display: grid; place-items: center;
  font-family: var(--font-display);
  font-size: 22px;
  color: var(--ink-2);
}
.wk-card-price {
  font-family: var(--font-num);
  font-size: 13px;
  color: var(--ink-1);
  display: inline-flex; align-items: center; gap: 3px;
  margin-bottom: 3px;
}
.wk-card-price .ic-seal {
  width: 14px; height: 14px; font-size: 10px;
  border-radius: 2px;
  display: grid; place-items: center;
  font-family: var(--font-display);
  background: var(--jade); color: var(--paper-1);
}
.wk-card-cta {
  display: block;
  margin: 2px 0 0;
  padding: 2px 4px;
  background: var(--jade);
  color: var(--paper-1);
  border: 1px solid var(--ink-1);
  border-radius: 4px;
  font-family: var(--font-display);
  font-size: 12px;
  letter-spacing: .04em;
  line-height: 1.3;
}

/* 5 状态卡 */
.wk-card.is-locked { opacity: .6; background: var(--paper-3); }
.wk-card.is-locked .wk-card-illu { background: var(--ink-4); color: var(--paper-1); font-size: 26px; }
.wk-card.is-locked .wk-card-price { color: var(--ink-4); }
.wk-card.is-locked .wk-card-cta { display: none; }
.wk-card-lock-q { font-family: var(--font-display); font-size: 13px; color: var(--ink-4); margin-top: 4px; }

.wk-card.is-done { background: var(--celadon-3); border-color: var(--wood-2); color: var(--paper-1); }
.wk-card.is-done .wk-card-name { color: var(--paper-1); }
.wk-card.is-done .wk-card-illu { background: var(--paper-1); }
.wk-card.is-done .wk-card-price { color: var(--paper-1); }
.wk-card.is-done .wk-card-cta { background: var(--jade); border-color: var(--paper-1); }
.wk-done-tick {
  position: absolute; top: -6px; right: -4px;
  width: 18px; height: 18px;
  background: var(--jade); color: var(--paper-1);
  border: 1.5px solid var(--paper-1); border-radius: 50%;
  display: grid; place-items: center;
  font-size: 11px; line-height: 1;
  z-index: 3;
}

.wk-card.is-fail .wk-card-illu {
  background: var(--fail-red); color: var(--paper-1);
  font-family: var(--font-display); font-weight: 700; font-size: 16px;
  letter-spacing: -.02em;
}
.wk-card.is-fail .wk-card-cta { background: var(--paper-1); color: var(--fail-red); border-color: var(--fail-red); }

.wk-card.is-promo .wk-card-bang {
  position: absolute; top: -6px; right: -4px;
  width: 18px; height: 18px;
  background: var(--amber); color: var(--ink-1);
  border: 1.5px solid var(--paper-1); border-radius: 50%;
  font-family: var(--font-display); font-size: 14px;
  display: grid; place-items: center; line-height: 1;
  z-index: 3;
}

.wk-card.is-empty { background: transparent; border: none; box-shadow: none; cursor: default; }
.wk-card.is-empty:active { transform: none; }

.wk-card.is-active { background: var(--celadon-3); border-color: var(--wood-2); color: var(--paper-1); }
.wk-card.is-active .wk-card-name { color: var(--paper-1); }
.wk-card.is-active .wk-card-illu { background: var(--paper-1); }
.wk-card.is-active .wk-card-price { color: var(--paper-1); }
.wk-card.is-active .wk-card-cta { display: none; }

.wk-card-progress { width: 100%; margin-top: 2px; }
.wk-card-progress .bar {
  height: 8px;
  background: rgba(0,0,0,.28);
  border: 1px solid rgba(0,0,0,.4);
  border-radius: var(--r-pill);
  overflow: hidden;
}
.wk-card-progress .bar > i {
  display: block; height: 100%;
  background: linear-gradient(90deg, var(--jade) 0%, #7CA887 100%);
  box-shadow: inset 0 1px 0 rgba(255,255,255,.25);
}
.wk-card-progress .ratio {
  font-family: var(--font-num);
  font-size: 10px;
  color: var(--paper-1);
  margin-top: 2px;
  letter-spacing: .02em;
  line-height: 1;
}

/* 连线 (拓扑) · ink-3 竹线 · 上下两端套圆点 */
.wk-card:not(.is-empty)::after {
  content: "";
  position: absolute;
  bottom: -14px; left: 50%;
  transform: translateX(-50%);
  width: 3px; height: 24px;
  background: var(--ink-3);
  border-radius: 2px;
  box-shadow: 0 0 0 1px var(--paper-1);
  z-index: 0;
}
.wk-card:not(.is-empty)::before {
  content: "";
  position: absolute;
  top: -8px; left: 50%;
  transform: translateX(-50%);
  width: 8px; height: 8px;
  background: var(--ink-3);
  border-radius: 50%;
  box-shadow: 0 0 0 2px var(--paper-1);
  z-index: 1;
}
.wk-level:first-child .wk-card::before { display: none; }
.wk-level:last-child .wk-card::after { display: none; }

.bottom-fade { height: 24px; }
</style>
