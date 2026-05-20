<!--
  CharacterModal · 人物卷 modal (Phase A globals)
  HTML 真值 L4217-4312
  触发自 HudBar 王掌柜头像 / 心 cell / 玉 cell · MainMenu 名条
  HTML alias: open:income / open:rename 也指向此 modal (L4775-4777)
  2 sub-tab: 交易(才学属性 5 解锁 + 月度收支三柱)/ 升级(紫晶进阶 7 条目)
-->
<script setup lang="ts">
import { ref } from 'vue'
import { useModalStore } from '../stores/useModalStore'
const store = useModalStore()

const pane = ref<'trade' | 'upgrade'>('trade')

const skills = [
  ['膂', '膂力', '十'],
  ['智', '智略', '十二'],
  ['誉', '声望', '七'],
  ['度', '风度', '三'],
  ['运', '气运', '一']
] as const

const moneyRows = ['+ 工 1.4k', '+ 寳 664', '+ 膂 1', '- 鞋 100', '- 膳 60', '- 飨 450']
const moodRows  = ['+ 车 5', '+ 寳 1', '- 膳 2']
const heartRows = ['+ 膳 3', '+ 膳 5', '- 膳 2', '- 膳 4']

const upgrades = [
  { g: '公', n: '薪俸提升', prog: '0／3', gain: '+10% / 級', price: 12 },
  { g: '寳', n: '产业收入', prog: '0／3', gain: '+10% / 級', price: 10 },
  { g: '鹅', n: '特产毛利', prog: '0／3', gain: '+50% / 級', price: 5  },
  { g: '壽', n: '体魄上限', prog: '—',    gain: '+10% / 級', price: 5  },
  { g: '心', n: '心境上限', prog: '—',    gain: '+10% / 級', price: 5  },
  { g: '宅', n: '资产收入', prog: '0／3', gain: '+10% / 級', price: 10 },
  { g: '緣', n: '相识加速', prog: '0／3', gain: '+20% / 級', price: 5  }
]
</script>

<template>
  <div class="modal modal--lg">
    <div class="modal-bar">
      <span>人物卷</span>
      <button class="close" @click="store.close()">✕</button>
    </div>
    <div class="modal-body scroll">
      <div class="sub-tabs">
        <div class="sub-tab" :class="{ 'is-active': pane === 'trade' }"   @click="pane = 'trade'">交&nbsp;易</div>
        <div class="sub-tab" :class="{ 'is-active': pane === 'upgrade' }" @click="pane = 'upgrade'">升&nbsp;级</div>
      </div>

      <!-- 交易 pane -->
      <div v-show="pane === 'trade'">
        <h3>才学属性 · 五解锁</h3>
        <div class="skill-grid">
          <div v-for="[g, n, v] in skills" :key="n" class="sk-row">
            <div class="sk-glyph">{{ g }}</div>
            <div class="sk-info">
              <span class="sk-name">{{ n }}</span>
              <span class="sk-val">{{ v }}</span>
            </div>
          </div>
          <div v-for="i in 5" :key="'lock'+i" class="sk-row sk-locked">
            <div class="sk-glyph sk-glyph-lock">鎖</div>
            <div class="sk-info">
              <span class="sk-name sk-name-lock">未启</span>
              <span class="sk-val sk-val-lock">??</span>
            </div>
          </div>
        </div>

        <h3>月度收支 · 三柱</h3>
        <div class="budget-grid">
          <div class="budget-col">
            <div class="budget-seal seal-coin">銅</div>
            <div class="budget-rows">
              <div v-for="r in moneyRows" :key="r">{{ r }}</div>
            </div>
            <div class="budget-total">+1.5k</div>
          </div>
          <div class="budget-col">
            <div class="budget-seal seal-mood">心</div>
            <div class="budget-rows">
              <div v-for="r in moodRows" :key="r">{{ r }}</div>
            </div>
            <div class="budget-total">+2</div>
          </div>
          <div class="budget-col">
            <div class="budget-seal seal-heart">壽</div>
            <div class="budget-rows">
              <div v-for="r in heartRows" :key="r">{{ r }}</div>
            </div>
            <div class="budget-total">+4</div>
          </div>
        </div>
      </div>

      <!-- 升级 pane -->
      <div v-show="pane === 'upgrade'">
        <h3>紫晶进阶 · 7+ 条目</h3>
        <div v-for="u in upgrades" :key="u.n" class="up-row">
          <div class="up-glyph">{{ u.g }}</div>
          <div class="up-mid">
            <div class="up-name">{{ u.n }} <span class="up-prog">{{ u.prog }}</span></div>
            <div class="up-gain">{{ u.gain }}</div>
          </div>
          <button class="up-cta">
            <span class="up-seal">玉</span>{{ u.price }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.sub-tabs {
  display: flex; gap: 6px;
  margin-bottom: 12px;
  border-bottom: 1px solid var(--paper-edge);
  padding-bottom: 6px;
}
.sub-tab {
  flex: 1;
  text-align: center;
  padding: 6px;
  font-family: var(--font-display);
  font-size: 17px;
  color: var(--ink-3);
  border-bottom: 2px solid transparent;
  cursor: pointer;
}
.sub-tab.is-active {
  color: var(--cinnabar-1);
  border-bottom-color: var(--cinnabar-1);
}

h3 {
  margin: 12px 0 8px;
  font-family: var(--font-display);
  font-size: var(--fs-h2);
  color: var(--ink-1);
  letter-spacing: .02em;
}
h3:first-of-type { margin-top: 0; }

.skill-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 8px;
  margin-bottom: 18px;
}
.sk-row {
  display: flex; align-items: center; gap: 8px;
  padding: 8px 10px;
  background: var(--paper-2);
  border: 1px solid var(--paper-edge);
  border-radius: 6px;
}
.sk-row.sk-locked { border-style: dashed; border-color: var(--ink-4); opacity: .55; }
.sk-glyph {
  width: 28px; height: 28px;
  background: var(--celadon-3); color: var(--paper-1);
  border-radius: 4px;
  display: grid; place-items: center;
  font-family: var(--font-display); font-size: 17px;
  flex: none;
}
.sk-glyph-lock { background: var(--ink-4); font-size: 16px; }
.sk-info {
  flex: 1;
  display: flex; justify-content: space-between; align-items: baseline;
}
.sk-name { font-family: var(--font-display); font-size: 16px; color: var(--ink-1); }
.sk-name-lock { font-size: 15px; color: var(--ink-3); }
.sk-val { font-family: var(--font-num); font-size: 18px; color: var(--cinnabar-1); font-weight: 700; }
.sk-val-lock { font-size: 16px; color: var(--ink-4); font-weight: 400; }

.budget-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 8px; }
.budget-col {
  background: var(--paper-2);
  border: 1px solid var(--paper-edge);
  padding: 10px 8px;
  border-radius: 6px;
}
.budget-seal {
  display: block;
  margin: 0 auto 8px;
  width: 28px; height: 28px;
  color: var(--paper-1);
  border-radius: 4px;
  font-family: var(--font-display); font-size: 16px;
  display: grid; place-items: center;
}
.seal-coin  { background: var(--cur-coin); }
.seal-mood  { background: var(--cur-mood); color: var(--ink-1); }
.seal-heart { background: var(--cur-heart); }
.budget-rows {
  font-family: var(--font-num);
  font-size: 18px;
  color: var(--ink-2);
  line-height: 1.7;
}
.budget-total {
  border-top: 1px solid var(--paper-edge);
  margin-top: 6px; padding-top: 6px;
  text-align: center;
  font-family: var(--font-display);
  color: var(--jade);
  font-size: 17px;
}

.up-row {
  display: grid;
  grid-template-columns: 32px 1fr auto;
  gap: 10px;
  align-items: center;
  padding: 10px;
  background: var(--paper-2);
  border: 1px solid var(--paper-edge);
  border-radius: 6px;
  margin-bottom: 6px;
}
.up-glyph {
  width: 28px; height: 28px;
  background: var(--cur-jade); color: var(--paper-1);
  border-radius: 4px;
  display: grid; place-items: center;
  font-family: var(--font-display); font-size: 17px;
}
.up-mid { min-width: 0; }
.up-name { font-family: var(--font-display); font-size: 17px; color: var(--ink-1); }
.up-prog { font-family: var(--font-num); font-size: 14px; color: var(--ink-3); margin-left: 4px; }
.up-gain { font-family: var(--font-num); font-size: 14px; color: var(--jade); margin-top: 2px; }
.up-cta {
  background: var(--jade); color: var(--paper-1);
  border: 1.5px solid var(--ink-1);
  box-shadow: 0 3px 0 var(--ink-1);
  padding: 6px 12px;
  border-radius: 6px;
  font-family: var(--font-display);
  font-size: 17px;
  display: inline-flex; align-items: center; gap: 4px;
  cursor: pointer;
}
.up-cta:active { transform: translateY(2px); box-shadow: 0 1px 0 var(--ink-1); }
.up-seal {
  width: 18px; height: 18px;
  background: var(--cur-jade); color: var(--paper-1);
  border-radius: 2px;
  display: grid; place-items: center;
  font-family: var(--font-display); font-size: 12px;
}
</style>
