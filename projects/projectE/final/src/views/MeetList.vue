<!--
  MeetList · fps_0012 缘份 / 关系 list (Phase B T-B2)
  4 NPC 卡 + 亲疏度 + 红 ! 角标
  click NPC → router.push('/meet/:npcKey') → RelationDetail.vue
-->
<script setup lang="ts">
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import HudBar       from '../components/HudBar.vue'
import BottomTabBar from '../components/BottomTabBar.vue'
import mainMenu from '../data/mainMenu.json'
import relData  from '../data/relations.json'

const router = useRouter()
const hud = computed(() => ({ ...mainMenu.hud, date: { era: '崇寧', day: '廿四', m: '秋' } }))

function goNpc (key: string) { router.push(`/meet/${key}`) }

function stageOf (stageKey: string) { return (relData.stages as any)[stageKey] }
</script>

<template>
  <div class="meet" data-screen-label="缘份 list · fps_0012">
    <HudBar v-bind="hud" :charName="mainMenu.character.name" />

    <div class="screen-bar">
      <div></div>
      <div class="sb-title">緣&nbsp;&nbsp;份</div>
      <button class="sb-close" @click="router.push('/main')">✕</button>
    </div>

    <div class="page paper-grain">
      <div v-for="npc in relData.npcs" :key="npc.key" class="npc-card" @click="goNpc(npc.key)">
        <div class="nl-avatar">{{ npc.glyph }}</div>
        <div class="nl-info">
          <div class="nl-name">{{ npc.name }}</div>
          <div class="nl-stage" :class="`is-${npc.stage}`">{{ stageOf(npc.stage).label }}</div>
        </div>
        <span v-if="npc.hasBang" class="red-bang">!</span>
        <div class="nl-arrow">›</div>
      </div>

      <div class="bottom-fade"></div>
    </div>

    <BottomTabBar />
  </div>
</template>

<style scoped>
/* .screen-bar / .sb-* / .npc-card / .nl-* / .red-bang 走全局 components.css */
.meet {
  position: absolute; inset: 0;
  display: grid;
  grid-template-rows: 80px 44px 1fr 90px;
  background: var(--paper-1);
}
.page { overflow-y: auto; padding: 14px 12px 24px; }
.bottom-fade { height: 24px; }
</style>
