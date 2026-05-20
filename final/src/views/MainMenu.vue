<!--
  MainMenu (fps_0035) · 大掌柜 主菜单街景 hub
  Phase A 锁定屏。布局 = canonical, 视觉 = 宋朝古风 (Style Lock)。
  数据见 ../data/mainMenu.json，互动入口走 useModalStore.
  HTML 静态参考: 项目根 Phase A · 主菜单 大掌柜.html
-->
<script setup lang="ts">
import HudBar       from '../components/HudBar.vue'
import BottomTabBar from '../components/BottomTabBar.vue'
import { useModalStore } from '../stores/useModalStore'
import data from '../data/mainMenu.json'

const store = useModalStore()
</script>

<template>
  <div class="menu" data-screen-label="主菜单 街景 hub">

    <HudBar v-bind="data.hud" :charName="data.character.name" />

    <!-- 名条 -->
    <div class="name-strip">
      <span class="name-pill" @click="store.open('rename')">
        {{ data.character.name }}<span class="edit">改 ✎</span>
      </span>
      <span class="name-meta">{{ data.character.ageLabel }}</span>
      <div class="pause-btn">
        <button title="暂停">‖‖</button>
        <button title="加速">»</button>
      </div>
    </div>

    <!-- 红包气泡 -->
    <div class="bonus-bubble" @click="store.open('bonus')">
      <div class="pkt"></div>
      <span class="pkt-tag">{{ data.bonus }}</span>
    </div>

    <!-- 街景 (Phase B: 替换为真插画背景) -->
    <main class="scene">
      <div class="bg-illu" :style="`background-image: url(${data.scene.bgIllu})`"></div>

      <div class="npcs" @click="store.open('npc-req', {jobKey: data.npcJobRequirement})">
        <div class="npc npc-1"></div>
        <div class="npc npc-2"><span class="npc-name">{{ data.scene.npcName }}</span></div>
      </div>

      <div class="floater f1"></div>
      <div class="floater f2"></div>
    </main>

    <!-- 任务卡 + 三堆叠 -->
    <div class="task-row">
      <div class="pouch">玉</div>
      <div class="task-card" @click="store.open('job-detail', {key: data.task.jobKey})">
        <div class="play"></div>
        <div class="label">{{ data.task.title }} <span class="reward">{{ data.task.reward }}</span></div>
        <div class="bar" :style="`--p: ${data.task.progress * 100}%`"></div>
        <div class="ratio">{{ data.task.progress * data.task.total }}／{{ data.task.total }}</div>
      </div>
      <div class="stack" @click="store.open('multi-task')">
        <div class="card c1"></div><div class="card c2"></div><div class="card c3"></div>
        <span class="badge-bang">!</span>
      </div>
    </div>

    <BottomTabBar />
  </div>
</template>

<style scoped>
/* 局部样式从项目根 Phase A · 主菜单 大掌柜.html 提炼 */
/* 实做时拆 tokens.css + main-menu.css 引入 */
</style>
