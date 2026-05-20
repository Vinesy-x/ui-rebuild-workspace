<!--
  App · 根容器
  顶级 layout = <router-view> + <ModalShell>
-->
<script setup lang="ts">
import ModalShell from './components/ModalShell.vue'
</script>

<template>
  <div class="app-stage">
    <div class="phone">
      <router-view />
      <ModalShell />
    </div>
  </div>
</template>

<style>
html, body, #app, .app-stage {
  height: 100%;
  margin: 0;
  padding: 0;
}
.app-stage {
  background: radial-gradient(ellipse at 50% 0%, #3d3526 0%, #1a1610 70%, #0e0c08 100%);
  display: grid;
  place-items: center;
  padding: 24px 0;
  box-sizing: border-box;
  min-height: 100vh;
}
.phone {
  position: relative;
  width: 448px;
  height: 960px;
  overflow: hidden;
  border-radius: 36px;
  box-shadow:
    0 0 0 1px #000,
    0 0 0 6px #1c1610,
    0 0 0 7px var(--gold-1),
    0 30px 80px rgba(0,0,0,.6);
  isolation: isolate;
  background: var(--paper-1);
}
</style>
