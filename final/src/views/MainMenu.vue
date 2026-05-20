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

    <!-- 街景 · v2 canonical 校正：NPC 改纯装饰，无 click 入口 -->
    <main class="scene">
      <div class="mountains">
        <div class="mountain m1"></div>
        <div class="mountain m2"></div>
        <div class="mountain m3"></div>
      </div>
      <div class="pagoda">
        <div class="roof r0"></div><div class="b0"></div>
        <div class="roof r1"></div><div class="b1"></div>
        <div class="roof r2"></div><div class="b2"></div>
        <div class="roof r3"></div><div class="b3"></div>
      </div>
      <div class="canal"></div>
      <span class="boat boat1"></span>
      <span class="boat boat2"></span>
      <div class="bridge"></div>

      <div class="lantern l1"></div>
      <div class="lantern l2"></div>

      <div class="street">
        <div class="shop shop-a"><span class="lant-hang"></span><div class="lattice"></div><div class="door"></div><div class="banner b1">茶</div></div>
        <div class="shop shop-b"><span class="lant-hang"></span><span class="lant-hang r"></span><div class="lattice"></div><div class="door"></div><div class="banner b2">錢莊</div></div>
        <div class="shop shop-c"><span class="lant-hang"></span><div class="lattice"></div><div class="door"></div><div class="banner b3">酒</div></div>
        <div class="shop shop-d"><span class="lant-hang"></span><div class="lattice"></div><div class="door"></div></div>
      </div>

      <!-- NPC 装饰 · canonical v2: 不再 click → npc-req modal -->
      <div class="npcs" aria-hidden="true">
        <div class="npc npc-1"></div>
        <div class="npc npc-2"><span class="npc-name">{{ data.scene.npcName }}</span></div>
      </div>

      <div class="floater f1"></div>
      <div class="floater f2"></div>

      <div class="carriage">
        <div class="shaft"></div>
        <div class="cab"></div>
        <div class="wheel w1"></div>
        <div class="wheel w2"></div>
      </div>

      <div class="ground"></div>
      <div class="scene-ph">背景 placeholder · Phase B 替换为水墨彩绘插画</div>
    </main>

    <!-- 任务卡 + 三堆叠 -->
    <div class="task-row">
      <div class="pouch">玉</div>
      <div class="task-card" @click="store.open('job-detail', {jobKey: data.task.jobKey})">
        <div class="play"></div>
        <div class="label">{{ data.task.title }} <span class="reward">{{ data.task.reward }}</span></div>
        <div class="bar"></div>
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
.menu {
    position: absolute; inset: 0;
    display: grid;
    grid-template-rows: 80px 50px 1fr 100px 90px;
    background: var(--paper-1);
  }

.archway { display: none; }

.pagoda {
    position: absolute;
    top: 9%; left: 62%;
    width: 18px; height: 38px;
    z-index: 1;
    opacity: .35;
  }

.pagoda div { position: absolute; left: 50%; transform: translateX(-50%); background: var(--celadon-3); }

.pagoda .roof { height: 5px; clip-path: polygon(0 100%, 18% 35%, 50% 0, 82% 35%, 100% 100%); }

.pagoda .r0 { top: 0; width: 100%; }

.pagoda .b0 { top: 5px; height: 9px; width: 68%; }

.pagoda .r1 { top: 14px; width: 88%; }

.pagoda .b1 { top: 19px; height: 9px; width: 54%; }

.pagoda .r2 { top: 28px; width: 76%; }

.pagoda .b2 { top: 33px; height: 9px; width: 42%; }

.pagoda .r3 { top: 42px; width: 64%; }

.pagoda .b3 { top: 47px; height: 13px; width: 26%; }

.canal {
    position: absolute;
    left: 0; right: 0;
    top: 30%;
    height: 48px;
    background: linear-gradient(180deg, var(--water-2) 0%, var(--water-1) 100%);
    z-index: 1;
    opacity: .9;
  }

.canal::after {
    content: "";
    position: absolute;
    left: 0; right: 0; bottom: 0; height: 3px;
    background: repeating-linear-gradient(
      90deg, rgba(78,56,35,.18) 0 5px, transparent 5px 11px);
  }

.boat {
    position: absolute;
    width: 26px; height: 6px;
    background: var(--wood-1);
    border-radius: 2px 2px 8px 8px / 2px 2px 6px 6px;
    z-index: 2;
    opacity: .8;
  }

.boat::after {
    content: "";
    position: absolute;
    top: -5px; left: 50%; transform: translateX(-50%);
    width: 8px; height: 5px;
    background: var(--celadon-3);
    clip-path: polygon(0 100%, 50% 0, 100% 100%);
  }

.boat1 { top: 32%; left: 14%; }

.boat2 { top: 33%; left: 46%; width: 24px; }

.bridge {
    position: absolute;
    top: 28%; left: 33%;
    width: 90px; height: 22px;
    z-index: 3;
    pointer-events: none;
  }

.bridge::before {
    content: "";
    position: absolute;
    inset: 0 0 4px;
    background: transparent;
    border: 1.5px solid var(--paper-edge);
    border-bottom: 0;
    border-radius: 50% 50% 0 0 / 100% 100% 0 0;
    opacity: .7;
  }

.bridge::after {
    content: "";
    position: absolute;
    bottom: 4px; left: 0; right: 0;
    height: 4px;
    background: #C8B98F;
    border: 1px solid var(--paper-edge);
    border-radius: 1px;
  }

.pedestrian {
    position: absolute;
    width: 5px; height: 12px;
    background: var(--ink-2);
    border-radius: 2px 2px 0 0;
    opacity: .35;
  }

.name-strip {
    position: relative;
    background: var(--paper-1);
    padding: 8px 12px 6px;
    display: flex;
    align-items: center;
    gap: 10px;
    border-bottom: 1px solid var(--paper-edge);
    z-index: 25;
  }

.name-pill {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    background: var(--celadon-3);
    color: var(--paper-1);
    padding: 5px 12px 5px 12px;
    border-radius: var(--r-pill);
    font-family: var(--font-display);
    font-size: 20px;
    letter-spacing: .08em;
    box-shadow: inset 0 1px 0 rgba(255,255,255,.15);
    cursor: pointer;
    white-space: nowrap;
  }

.name-pill .edit {
    font-family: var(--font-serif);
    font-size: 15px;
    opacity: .85;
    border-left: 1px solid rgba(255,255,255,.3);
    padding-left: 6px;
    margin-left: 2px;
    letter-spacing: 0;
  }

.name-meta {
    font-family: var(--font-num);
    font-size: 16px;
    color: var(--ink-3);
    line-height: 1.2;
    white-space: nowrap;
  }

.pause-btn {
    margin-left: auto;
    display: flex;
    gap: 2px;
    align-items: center;
  }

.pause-btn button {
    width: 24px; height: 24px;
    border: 1px solid var(--ink-3);
    background: var(--paper-2);
    border-radius: 4px;
    font-family: var(--font-num);
    color: var(--ink-1);
    cursor: pointer;
    padding: 0;
    display: grid; place-items: center;
    line-height: 1;
  }

.pause-btn button:hover { background: var(--paper-3); }

.bonus-bubble {
    position: absolute;
    top: 138px;
    right: 10px;
    width: 64px;
    z-index: 22;
    cursor: pointer;
    text-align: center;
    font-family: var(--font-display);
  }

.bonus-bubble .pkt {
    width: 56px; height: 64px;
    margin: 0 auto;
    background: linear-gradient(180deg, var(--cinnabar-2), var(--cinnabar-1) 60%, var(--cinnabar-3));
    border-radius: 4px 4px 28px 28px / 4px 4px 18px 18px;
    border: 1.5px solid var(--gold-1);
    color: var(--gold-2);
    font-size: 32px;
    display: grid;
    place-items: center;
    position: relative;
    box-shadow: 0 4px 8px rgba(0,0,0,.18);
  }

.bonus-bubble .pkt::before {
    content: "";
    position: absolute;
    top: 18%; left: 50%; transform: translateX(-50%);
    width: 22px; height: 22px;
    background: var(--gold-1);
    border-radius: 50%;
    box-shadow: inset 0 0 0 1px var(--cinnabar-1);
  }

.bonus-bubble .pkt::after { content: "福"; position: relative; color: var(--cinnabar-1); }

.bonus-bubble .pkt-tag {
    margin-top: 4px;
    display: inline-block;
    background: var(--ink-1);
    color: var(--gold-2);
    font-size: 16px;
    padding: 1px 6px;
    border-radius: var(--r-pill);
    border: 1px solid var(--gold-1);
  }

.scene {
    position: relative;
    overflow: hidden;
    background:
      linear-gradient(180deg,
        var(--sky-1) 0%,
        #DDE2DA 22%,
        var(--paper-1) 50%,
        #E5D6B0 75%,
        var(--paper-3) 100%);
  }

.mountains {
    position: absolute;
    left: 0; right: 0; top: 8%;
    height: 80px;
    pointer-events: none;
    opacity: 1;
    z-index: 1;
  }

.mountain {
    position: absolute;
    background: #7E8C92;
    clip-path: polygon(0% 100%, 40% 0%, 70% 30%, 100% 100%);
    opacity: .42;
  }

.m1 { left: -10%; bottom: 0; width: 60%; height: 80px; }

.m2 { right: -8%; bottom: 0; width: 70%; height: 100px; opacity: .35;
        clip-path: polygon(0% 100%, 25% 25%, 55% 50%, 80% 5%, 100% 100%); }

.m3 { left: 25%; bottom: 0; width: 50%; height: 60px; opacity: .25;
        clip-path: polygon(0% 100%, 30% 20%, 60% 60%, 100% 100%); }

.street {
    position: absolute;
    left: 0; right: 0; bottom: 16%;
    height: 44%;
    display: flex;
    align-items: flex-end;
    padding: 0 6px;
    gap: 3px;
    z-index: 4;
  }

.shop {
    position: relative;
    background: #F0E5C8;
    border: 1px solid var(--wood-2);
    box-shadow: inset 0 0 0 1px #FAF1D5;
  }

.shop::before {
    content: "";
    position: absolute;
    top: -12px; left: -10px; right: -10px;
    height: 16px;
    background: var(--celadon-3);
    clip-path: polygon(
      0% 100%, 4% 60%, 10% 40%, 18% 28%, 50% 0%,
      82% 28%, 90% 40%, 96% 60%, 100% 100%);
    box-shadow: 0 2px 4px rgba(31,27,20,.18);
  }

.shop .lattice {     /* 木格窗 */
    position: absolute;
    top: 16%; left: 12%; right: 12%; bottom: 40%;
    background:
      linear-gradient(var(--wood-1), var(--wood-1)) center / 1px 100% no-repeat,
      linear-gradient(90deg, var(--wood-1), var(--wood-1)) center / 100% 1px no-repeat,
      linear-gradient(180deg, #c0a87a, #a08560);
    border: 1px solid var(--wood-2);
  }

.shop .door {
    position: absolute;
    bottom: 0; left: 38%; width: 24%;
    height: 35%;
    background: var(--wood-2);
    border-top: 1px solid var(--wood-1);
  }

.shop .banner {       /* 招幌 */
    position: absolute;
    top: 8%; right: -6px;
    width: 14px; height: 60px;
    background: var(--cinnabar-1);
    border: 1px solid var(--wood-2);
    font-family: var(--font-display);
    color: var(--paper-1);
    font-size: 15px;
    text-align: center;
    writing-mode: vertical-rl;
    padding: 4px 0;
    letter-spacing: 2px;
    box-shadow: 0 2px 4px rgba(0,0,0,.18);
  }

.shop .banner.b2 { background: var(--cinnabar-1); color: var(--paper-1); }

.shop .banner.b3 { background: var(--celadon-3); color: var(--paper-1); }

.shop-a { width: 80px; height: 140px; }

.shop-b { width: 120px; height: 180px; }

.shop-c { width: 90px; height: 130px; }

.shop-d { width: 80px; height: 156px; }

.lant-hang {
    position: absolute;
    top: 6px; left: 22%;
    width: 12px; height: 16px;
    background: radial-gradient(circle at 50% 40%, #d88770 0%, var(--cinnabar-1) 60%, var(--cinnabar-3) 100%);
    border-radius: 50% / 60%;
    border: 1px solid var(--gold-1);
    z-index: 5;
  }

.lant-hang::before {
    content: "";
    position: absolute;
    top: -3px; left: 50%; transform: translateX(-50%);
    width: 1px; height: 4px;
    background: var(--ink-1);
  }

.lant-hang.r { left: auto; right: 22%; }

.lantern {
    position: absolute;
    width: 22px; height: 28px;
    background: radial-gradient(circle at 50% 40%, #d88770 0%, var(--cinnabar-1) 60%, var(--cinnabar-3) 100%);
    border-radius: 50% / 60%;
    border: 1px solid var(--gold-1);
    box-shadow: 0 0 10px rgba(138,69,51,.35);
  }

.lantern::before {
    content: "";
    position: absolute;
    top: -6px; left: 50%; transform: translateX(-50%);
    width: 2px; height: 10px;
    background: var(--ink-1);
  }

.lantern::after {
    content: "";
    position: absolute;
    bottom: -4px; left: 50%; transform: translateX(-50%);
    width: 8px; height: 4px;
    background: var(--gold-1);
    border-radius: 0 0 50% 50%;
  }

.l1 { top: 5%; left: 4%; opacity: .65; }

.l2 { top: 8%; right: 6%; opacity: .65; }

.ground {
    position: absolute;
    left: 0; right: 0; bottom: 0;
    height: 18%;
    background:
      linear-gradient(180deg, #b89668 0%, #8b6f47 100%);
    background-image:
      repeating-linear-gradient(
        90deg,
        rgba(31,27,20,.18) 0, rgba(31,27,20,.18) 1px,
        transparent 1px, transparent 24px),
      repeating-linear-gradient(
        180deg,
        rgba(31,27,20,.1) 0, rgba(31,27,20,.1) 1px,
        transparent 1px, transparent 16px),
      linear-gradient(180deg, #b89668 0%, #8b6f47 100%);
  }

.ph-label {
    position: absolute;
    background: rgba(31,27,20,.78);
    color: var(--paper-1);
    font-family: ui-monospace, "SF Mono", monospace;
    font-size: 14px;
    padding: 2px 6px;
    border: 1px dashed var(--gold-2);
    white-space: nowrap;
    pointer-events: none;
  }

.npcs {
    position: absolute;
    left: 28%;
    bottom: 14%;
    display: flex;
    gap: -10px;
    align-items: flex-end;
    cursor: pointer;
    z-index: 7;
  }

.npc {
    width: 64px; height: 140px;
    position: relative;
    margin-right: -12px;
    filter: drop-shadow(0 4px 3px rgba(31,27,20,.22));
  }

.npc .head {
    position: absolute;
    top: 0; left: 50%; transform: translateX(-50%);
    width: 36px; height: 36px;
    background: #DEC0A0;
    border-radius: 50%;
    border: 1.5px solid var(--ink-2);
  }

.npc .body {
    position: absolute;
    top: 32px; left: 50%; transform: translateX(-50%);
    width: 50px;
    height: 104px;
    border-radius: 4px 4px 6px 6px / 6px 6px 4px 4px;
    border: 1.5px solid var(--ink-2);
  }

.npc.npc-1 .body { background: var(--wood-1); }

.npc.npc-2 .body { background: var(--celadon-3); }

.npc.npc-2 .head::after {
    content: "";
    position: absolute;
    top: -7px; left: -3px; right: -3px;
    height: 16px;
    background: var(--cinnabar-1);
    border-radius: 10px 10px 4px 4px;
    border: 1.5px solid var(--ink-2);
  }

.npc-name {
    position: absolute;
    bottom: 100%;
    left: 50%; transform: translateX(-50%);
    background: rgba(31,27,20,.7);
    color: var(--paper-1);
    font-family: var(--font-display);
    font-size: 16px;
    padding: 1px 8px;
    border-radius: var(--r-pill);
    white-space: nowrap;
    margin-bottom: 4px;
  }

.carriage {
    position: absolute;
    right: 2%;
    bottom: 16%;
    width: 110px;
    height: 64px;
    pointer-events: none;
    z-index: 6;
  }

.carriage .cab {
    position: absolute;
    left: 18%; right: 8%; top: 0; bottom: 24%;
    background: var(--wood-1);
    border: 2px solid var(--gold-1);
    border-radius: 6px 14px 4px 4px;
  }

.carriage .cab::after {
    content: "";
    position: absolute;
    top: -10px; left: -4px; right: -4px;
    height: 14px;
    background: var(--ink-1);
    clip-path: polygon(0 100%, 12% 0, 88% 0, 100% 100%);
  }

.carriage .cab::before {
    content: "馬";
    position: absolute;
    inset: 8px;
    display: grid; place-items: center;
    color: var(--gold-2);
    font-family: var(--font-display);
    font-size: 24px;
    border: 1px solid var(--gold-1);
    border-radius: 4px;
  }

.carriage .wheel {
    position: absolute;
    bottom: 0;
    width: 26px; height: 26px;
    background:
      radial-gradient(circle, var(--gold-1) 2px, transparent 3px),
      conic-gradient(var(--ink-1) 0 12.5%, transparent 0 25%, var(--ink-1) 0 37.5%, transparent 0 50%, var(--ink-1) 0 62.5%, transparent 0 75%, var(--ink-1) 0 87.5%, transparent 0 100%);
    border: 2px solid var(--ink-1);
    border-radius: 50%;
  }

.carriage .w1 { left: 16%; }

.carriage .w2 { right: 16%; }

.carriage .shaft {
    position: absolute;
    left: 0; top: 28%;
    width: 28%; height: 6px;
    background: var(--wood-2);
    border-radius: 3px;
  }

.floater {
    position: absolute;
    width: 24px; height: 24px;
    pointer-events: none;
    animation: float 3.6s ease-in-out infinite;
  }

.floater::before, .floater::after {
    content: "";
    position: absolute;
    width: 14px; height: 22px;
    background: var(--cinnabar-2);
    border-radius: 7px 7px 0 0;
    top: 0;
  }

.floater::before { left: 0; transform: rotate(-30deg); transform-origin: 50% 70%; }

.floater::after  { right: 0; transform: rotate(30deg);  transform-origin: 50% 70%; }

.f1 { left: 8%; top: 60%; animation-delay: 0s; opacity: .55; }

.f2 { left: 12%; top: 70%; animation-delay: 1.2s; opacity: .35; transform: scale(.7); }

@keyframes float {
    0%   { transform: translateY(0)    scale(1);   opacity: .9; }
    50%  { transform: translateY(-30px) scale(1.05); opacity: 1; }
    100% { transform: translateY(-60px) scale(.8);  opacity: 0; }
  }

.scene-ph {
    position: absolute;
    left: 50%;
    bottom: 4px;
    transform: translateX(-50%);
    background: rgba(31,27,20,.5);
    color: var(--paper-1);
    font-family: ui-monospace, "SF Mono", monospace;
    font-size: 14px;
    padding: 2px 6px;
    letter-spacing: .02em;
    z-index: 6;
  }

.task-row {
    background: var(--paper-2);
    border-top: 1px solid var(--paper-edge);
    padding: 10px 10px 8px;
    display: grid;
    grid-template-columns: 38px 1fr 56px;
    gap: 8px;
    align-items: center;
    position: relative;
    z-index: 20;
  }

.pouch {
    width: 38px; height: 38px;
    background: var(--cur-jade);
    border: 1.5px solid var(--ink-1);
    border-radius: 8px 8px 6px 6px;
    display: grid; place-items: center;
    color: var(--paper-1);
    font-family: var(--font-display);
    font-size: 20px;
    box-shadow: inset 0 -3px 0 rgba(0,0,0,.2);
    position: relative;
  }

.pouch::after {
    content: "";
    position: absolute;
    top: -3px; left: 25%; right: 25%;
    height: 4px;
    background: var(--ink-1);
    border-radius: 2px 2px 0 0;
  }

.task-card {
    position: relative;
    background: var(--paper-1);
    border: 1.5px solid var(--ink-2);
    border-radius: 6px;
    padding: 6px 8px 7px 40px;
    box-shadow: var(--sh-card);
  }

.task-card .play {
    position: absolute;
    left: 6px; top: 50%; transform: translateY(-50%);
    width: 30px; height: 30px;
    background: var(--jade);
    border: 1.5px solid var(--ink-1);
    border-radius: 6px;
    display: grid; place-items: center;
    color: var(--paper-1);
  }

.task-card .play::after {
    content: "";
    width: 0; height: 0;
    border-left: 9px solid var(--paper-1);
    border-top: 6px solid transparent;
    border-bottom: 6px solid transparent;
  }

.task-card .label {
    font-family: var(--font-display);
    font-size: 17px;
    color: var(--ink-1);
    line-height: 1.1;
    display: flex; align-items: center; gap: 4px;
  }

.task-card .bar {
    margin-top: 5px;
    height: 6px;
    background: var(--paper-3);
    border: 1px solid var(--ink-2);
    border-radius: 3px;
    overflow: hidden;
  }

.task-card .bar::after {
    content: "";
    display: block;
    height: 100%;
    width: 0%;
    background: var(--celadon-3);
  }

.task-card .ratio {
    font-family: var(--font-num);
    font-size: 15px;
    color: var(--ink-3);
    margin-top: 2px;
  }

.stack {
    position: relative;
    width: 54px; height: 60px;
    cursor: pointer;
  }

.stack .card {
    position: absolute;
    width: 38px; height: 50px;
    border: 1.5px solid var(--ink-1);
    border-radius: 4px;
    box-shadow: 0 1px 0 rgba(0,0,0,.15);
  }

.stack .c1 { background: var(--celadon-2); left: 0;  top: 6px; transform: rotate(-8deg); }

.stack .c2 { background: var(--gold-2);    left: 8px; top: 4px; transform: rotate(0deg); }

.stack .c3 { background: var(--cinnabar-2); left: 16px; top: 0; transform: rotate(6deg); }

.badge-bang {
    position: absolute;
    top: -4px; right: -2px;
    width: 18px; height: 18px;
    background: var(--cinnabar-1);
    color: var(--paper-1);
    border: 1.5px solid var(--paper-1);
    border-radius: 50%;
    font-family: var(--font-display);
    font-size: 17px;
    display: grid; place-items: center;
    line-height: 1;
    box-shadow: 0 0 0 1px var(--cinnabar-3);
    z-index: 5;
  }
</style>
