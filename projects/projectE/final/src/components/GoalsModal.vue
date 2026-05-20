<!--
  GoalsModal · 目標·聲望卷 modal (Phase A globals)
  HTML 真值 L4147-4215
  触发自 HudBar 日历 cal · MainMenu bonus 红包 / task-card / 三堆叠 stack / pouch
  HTML alias: open:work-detail / open:multi-task / open:date / open:bonus / open:cur-pouch 全指向此 (L4778-4782)
  3 sub-tab: 目標(默认)/ 每日任务 / 成就
  reputation chip · goal-row 列表 (含 .gbang 角标 + .gdone ✓ + .gact 按钮)
  复用 JobDetailModal.vue 全局 style: .reputation / .repnum / .replab / .repprog / .goal-row / .gicon / .gname / .greward / .gact / .gdone / .gbang
-->
<script setup lang="ts">
import { ref } from 'vue'
import { useModalStore } from '../stores/useModalStore'
const store = useModalStore()

const pane = ref<'goals' | 'daily' | 'ach'>('goals')

interface Goal { ic: string; iconClass: string; name: string; reward: string; state: 'go' | 'buy' | 'done'; bang?: number }
const goals: Goal[] = [
  { ic: '輦', iconClass: 'ic-jade',  name: '购置三品马车',   reward: '+ 五 聲望', state: 'buy', bang: 1 },
  { ic: '工', iconClass: 'ic-coin',  name: '谋得正六品差事', reward: '+ 五 聲望', state: 'go',  bang: 2 },
  { ic: '工', iconClass: 'ic-coin',  name: '谋得正九品差事', reward: '+ 200 銅', state: 'done' },
  { ic: '運', iconClass: 'ic-jade',  name: '于转账中赚钱',   reward: '+ 200 銅', state: 'done' },
  { ic: '银', iconClass: 'ic-brick', name: '于钱庄领取回返银', reward: '+ 400 銅', state: 'done' },
  { ic: '心', iconClass: 'ic-mood',  name: '心境回升',       reward: '+ 300 銅', state: 'done' }
]
</script>

<template>
  <div class="modal modal--lg">
    <div class="modal-bar">
      <span>目標·聲望卷</span>
      <button class="close" @click="store.close()">✕</button>
    </div>
    <div class="modal-body scroll">
      <!-- 声望 chip -->
      <div class="reputation">
        <div>
          <div class="repnum">廿二</div>
          <div class="replab">尔之声望</div>
        </div>
        <div class="repprog">九／十一</div>
      </div>

      <!-- 3 sub-tabs -->
      <div class="sub-tabs">
        <div class="sub-tab" :class="{ 'is-active': pane === 'goals' }" @click="pane = 'goals'">目&nbsp;標</div>
        <div class="sub-tab" :class="{ 'is-active': pane === 'daily' }" @click="pane = 'daily'">每日任务</div>
        <div class="sub-tab" :class="{ 'is-active': pane === 'ach' }"   @click="pane = 'ach'">成&nbsp;就</div>
      </div>

      <!-- 目標 pane -->
      <div v-show="pane === 'goals'">
        <div v-for="(g, i) in goals" :key="i" class="goal-row" :class="{ done: g.state === 'done' }">
          <span v-if="g.bang" class="gbang">{{ g.bang }}</span>
          <div class="ic-seal gicon" :class="g.iconClass">{{ g.ic }}</div>
          <div>
            <div class="gname">{{ g.name }}</div>
            <div class="greward">{{ g.reward }}</div>
          </div>
          <button v-if="g.state === 'buy'" class="gact">购买</button>
          <button v-else-if="g.state === 'go'" class="gact">前往</button>
          <span v-else class="gdone">✓</span>
        </div>
      </div>

      <div v-show="pane === 'daily'" class="empty-pane">每日任务 · Phase B 补完</div>
      <div v-show="pane === 'ach'"   class="empty-pane">成就 · Phase B 补完</div>
    </div>
  </div>
</template>

<style scoped>
/* sub-tabs / .sub-tab / .reputation / .goal-row / .gicon / .gbang / .gact / .gdone 走全局 components.css · 不重复定义 */

.empty-pane {
  text-align: center;
  padding: 40px 16px;
  font-family: var(--font-display);
  color: var(--ink-3);
  font-size: 17px;
}
</style>
