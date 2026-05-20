import { createRouter, createWebHashHistory } from 'vue-router'

// Phase A 锁定的屏 + Phase B 占位
const routes = [
  { path: '/',             redirect: '/main' },
  { path: '/main',         name: 'main',       component: () => import('./views/MainMenu.vue') },     // fps_0035
  // Phase B 占位（按 info-architecture.md 屏映射）
  { path: '/skill',        name: 'skill',      component: () => import('./views/SkillList.vue') },    // 0001
  { path: '/meet',         name: 'meet',       component: () => import('./views/MeetList.vue') },     // 0012
  { path: '/work',         name: 'work',       component: () => import('./views/WorkDAG.vue') },      // 0036
  { path: '/business',     name: 'business',   component: () => import('./views/BusinessList.vue') },// 0046
  { path: '/invest',       name: 'invest',     component: () => import('./views/InvestBank.vue') },   // 0058
  { path: '/items',        name: 'items',      component: () => import('./views/ShopItems.vue') }     // 0073/0080
]

const router = createRouter({
  history: createWebHashHistory(),
  routes
})

// 切屏自动 reset modal（避免跨屏残留）
import { useModalStore } from './stores/useModalStore'
router.afterEach(() => {
  const m = useModalStore()
  m.close()
})

export default router
