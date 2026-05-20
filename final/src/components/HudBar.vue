<!--
  HudBar · 主菜单顶部双行 HUD
  9 类资源 + 角色名条 + Bonus 4x 红包气泡
  对应 fps_0035 顶部
-->
<script setup lang="ts">
import { useModalStore } from '../stores/useModalStore'
interface Props {
  level: number
  coin: number
  coinDelta: string         // "+1.2k/旬"
  mood: number
  moodDelta: string         // "-5.2/月"
  jade: number
  health: number
  healthDelta: string
  star: number
  date: { era: string; day: string; m: string }
  charName: string
}
defineProps<Props>()
const store = useModalStore()
</script>

<template>
  <header class="hud">
    <!-- 头像 (双行) -->
    <div class="avatar-wrap" @click="store.open('character')">
      <div class="avatar-frame">王</div>
      <div class="avatar-dot"></div>
      <div class="avatar-lv">Lv {{ level }}</div>
    </div>

    <!-- 行1 -->
    <div class="hud-cell" @click="store.open('shop', {tab:'money'})">
      <span class="ic-seal ic-coin">銅</span>
      <span class="num">{{ coin.toLocaleString() }}</span>
    </div>
    <div class="hud-cell" @click="store.open('character')">
      <span class="ic-seal ic-mood">心</span>
      <span class="num">{{ mood }}</span>
      <span class="pill pill--loss">{{ moodDelta }}</span>
    </div>
    <div class="hud-cell" @click="store.open('shop', {tab:'jade'})">
      <span class="ic-seal ic-jade">玉</span>
      <span class="num">{{ jade }}</span>
    </div>
    <button class="gear-btn" @click="store.open('settings')"></button>

    <!-- 行2 -->
    <div class="hud-cell">
      <span class="ic-seal ic-coin2">寳</span>
      <span class="pill pill--income">{{ coinDelta }}</span>
    </div>
    <div class="hud-cell" @click="store.open('health')">
      <span class="ic-seal ic-heart">壽</span>
      <span class="num">{{ health }}</span>
      <span class="pill pill--income">{{ healthDelta }}</span>
    </div>
    <div class="hud-cell" @click="store.open('happiness')">
      <span class="ic-seal ic-star">星</span>
      <span class="num">{{ star }}</span>
    </div>
    <div class="cal" @click="store.open('date')">
      <div class="y">{{ date.era }}</div>
      <div class="d">{{ date.day }}</div>
      <div class="m">{{ date.m }}</div>
    </div>
  </header>
</template>
