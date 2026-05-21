<!--
  App · 根 layout
  router-view + ModalShell · 跟 projectE 一致
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
  background: #1a1a1a;
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
  box-shadow: 0 0 0 1px #000, 0 0 0 6px #1c1610, 0 30px 80px rgba(0,0,0,.6);
  isolation: isolate;
  background: var(--bg, #fff);
}
</style>
