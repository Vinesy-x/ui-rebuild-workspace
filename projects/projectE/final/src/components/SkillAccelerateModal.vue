<!--
  SkillAccelerateModal · 9 共享之新增 (T-B1)
  出现帧: fps_0007
  modal-sm · 仪表盘 hero + 文案(技能名 + 倍率) + 取消/接受双 CTA
  原游戏文案: "将你的吸引力训练速度提升 6 倍! 永久生效!"  → 古风化
  每技能各自一个 modal 实例 (props: skillKey · skillName · multiplier · cost)
-->
<script setup lang="ts">
import { computed } from 'vue'
import { useModalStore } from '../stores/useModalStore'

interface Props {
  skillKey?: string
  skillName: string         // 古风名,渲染入文案
  multiplier?: number
  cost?: number             // 紫晶 (玉)
  copy?: string             // 文案模板,{name} {x} 占位
}
const props = withDefaults(defineProps<Props>(), {
  multiplier: 6,
  cost: 6,
  copy: '丹氣相助,「{name}」修為速進 {x} 倍,功成永世不墜。'
})

const store = useModalStore()
const emit = defineEmits<{ (e: 'accept', key?: string): void }>()

const text = computed(() =>
  props.copy
    .replace('{name}', props.skillName)
    .replace('{x}', String(props.multiplier))
)

function accept () {
  emit('accept', props.skillKey)
  store.close()
}
</script>

<template>
  <div class="modal modal--sm accel">
    <div class="modal-bar">
      <span>加 速</span>
      <button class="close" @click="store.close()">✕</button>
    </div>

    <div class="modal-body">
      <!-- 仪表盘 hero 古风化 = 罗盘式半圆 三色扇 + 指针 + 印章「速」-->
      <div class="dial-wrap">
        <div class="dial">
          <div class="dial-arc jade"></div>
          <div class="dial-arc amber"></div>
          <div class="dial-arc cinnabar"></div>
          <div class="dial-needle"></div>
          <div class="dial-cap"></div>
          <div class="dial-stand"></div>
          <div class="seal seal--md plus">速</div>
        </div>
      </div>

      <p class="copy">{{ text }}</p>
      <p class="sub"><span class="dot">✦</span>永世生效</p>

      <div class="cta-row">
        <button class="btn ghost" @click="store.close()">罷&nbsp;了</button>
        <button class="btn primary" @click="accept">
          <span class="seal seal--sm cur">玉</span>
          <span class="num">{{ cost }}</span>
        </button>
      </div>
    </div>
  </div>
</template>

<style scoped>
.accel { width: auto; }
.modal-body {
  display: flex;
  flex-direction: column;
  align-items: stretch;
  padding: 16px;
}

/* ─── 仪表盘 ─────────────────────────────── */
.dial-wrap {
  position: relative;
  height: 116px;
  margin: 4px 0 12px;
  display: grid; place-items: center;
}
.dial {
  position: relative;
  width: 168px; height: 96px;
  overflow: visible;
}
.dial-arc {
  position: absolute;
  left: 50%; bottom: 0;
  transform: translateX(-50%);
  width: 168px; height: 168px;
  border-radius: 50%;
  border: 14px solid transparent;
  clip-path: polygon(0 0, 100% 0, 100% 50%, 0 50%);
}
.dial-arc.jade     { border-color: var(--jade);       transform: translateX(-50%) rotate(-90deg); }
.dial-arc.amber    { border-color: var(--amber);      transform: translateX(-50%) rotate(-30deg); }
.dial-arc.cinnabar { border-color: var(--cinnabar-1); transform: translateX(-50%) rotate(30deg);  }
.dial-needle {
  position: absolute;
  left: 50%; bottom: 4px;
  width: 4px; height: 70px;
  background: linear-gradient(180deg, var(--ink-1) 0%, var(--ink-2) 100%);
  border-radius: 2px;
  transform-origin: 50% 100%;
  transform: translateX(-50%) rotate(28deg);
  box-shadow: 0 1px 0 rgba(255,255,255,.25);
}
.dial-cap {
  position: absolute;
  left: 50%; bottom: 0;
  transform: translateX(-50%);
  width: 18px; height: 18px;
  border-radius: 50%;
  background: var(--gold-1);
  border: 1.5px solid var(--ink-1);
  box-shadow: inset 0 -2px 0 var(--wood-2);
}
.dial-stand {
  position: absolute;
  left: 50%; bottom: -10px;
  transform: translateX(-50%);
  width: 110px; height: 10px;
  background: var(--wood-1);
  border: 1px solid var(--wood-2);
  border-radius: 2px 2px 4px 4px;
}

.seal.plus {
  position: absolute;
  left: 100%; bottom: 4px;
  margin-left: -10px;
  background: var(--jade);
  box-shadow: 0 2px 0 rgba(0,0,0,.18);
}

/* ─── 文案 ────────────────────────────────── */
.copy {
  margin: 6px 4px 4px;
  font-family: var(--font-serif);
  font-size: var(--fs-body);
  color: var(--ink-1);
  line-height: 1.55;
  text-align: center;
  text-wrap: pretty;
}
.sub {
  margin: 0 0 16px;
  font-family: var(--font-display);
  font-size: var(--fs-label);
  color: var(--cinnabar-1);
  text-align: center;
  letter-spacing: .08em;
}
.sub .dot { color: var(--gold-1); margin-right: 4px; }

/* ─── CTA row ─────────────────────────────── */
.cta-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 10px;
}
.btn {
  padding: 10px;
  border-radius: 8px;
  font-family: var(--font-display);
  font-size: 22px;
  letter-spacing: .12em;
  cursor: pointer;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  border: 1.5px solid var(--ink-1);
  box-shadow: 0 3px 0 var(--ink-1);
  transition: transform var(--dur-fast) var(--ease-out);
}
.btn:active { transform: translateY(2px); box-shadow: 0 1px 0 var(--ink-1); }

.btn.ghost {
  background: var(--paper-1);
  color: var(--azure);
}

.btn.primary {
  background: var(--jade);
  color: var(--paper-1);
}
.btn.primary .num {
  font-family: var(--font-num);
  font-size: 20px;
  letter-spacing: 0;
}
.btn.primary .seal.cur {
  background: var(--cur-jade);
  width: 22px; height: 22px;
  font-size: 14px;
  border: 1px solid rgba(255,255,255,.4);
}
</style>
