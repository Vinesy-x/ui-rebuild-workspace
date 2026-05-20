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
          <div class="nl-stage" :class="`stg-${npc.stage}`">{{ stageOf(npc.stage).label }}</div>
        </div>
        <span v-if="npc.hasBang" class="bang">!</span>
        <div class="nl-arrow">›</div>
      </div>

      <div class="bottom-fade"></div>
    </div>

    <BottomTabBar />
  </div>
</template>

<style scoped>
.meet {
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

.page { overflow-y: auto; padding: 14px 12px 24px; }

.npc-card {
  display: grid;
  grid-template-columns: 64px 1fr 28px;
  gap: 14px;
  align-items: center;
  background: var(--paper-2);
  border: 1.5px solid var(--paper-edge);
  border-radius: 8px;
  padding: 12px;
  margin-bottom: 10px;
  cursor: pointer;
  position: relative;
  box-shadow: var(--sh-card);
  transition: transform var(--dur-fast) var(--ease-out);
}
.npc-card:active { transform: translateY(1px); }

.nl-avatar {
  width: 56px; height: 56px;
  background: var(--cinnabar-1); color: var(--paper-1);
  border-radius: 6px;
  display: grid; place-items: center;
  font-family: var(--font-display); font-size: 32px;
  position: relative;
  box-shadow: inset 0 0 0 1px rgba(245,235,214,.3);
}
.nl-info { display: flex; flex-direction: column; gap: 2px; min-width: 0; }
.nl-name { font-family: var(--font-display); font-size: var(--fs-h2); color: var(--ink-1); letter-spacing: .04em; }
.nl-stage { font-family: var(--font-num); font-size: var(--fs-meta); }
.stg-stranger { color: var(--ink-3); }
.stg-known    { color: var(--celadon-3); }
.stg-friend   { color: var(--jade); }
.stg-main     { color: var(--cinnabar-1); }

.bang {
  position: absolute; top: 6px; right: 36px;
  width: 18px; height: 18px;
  background: var(--fail-red); color: var(--paper-1);
  border: 1.5px solid var(--paper-1); border-radius: 50%;
  font-family: var(--font-display); font-size: 11px;
  display: grid; place-items: center;
}

.nl-arrow { color: var(--ink-3); font-size: 24px; font-family: var(--font-display); justify-self: end; }

.bottom-fade { height: 24px; }
</style>
