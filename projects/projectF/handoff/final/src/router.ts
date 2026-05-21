import { createRouter, createWebHashHistory } from 'vue-router'
import PomodoroTimer from './views/PomodoroTimer.vue'
import { useModalStore } from './stores/useModalStore'

const router = createRouter({
  history: createWebHashHistory(),
  routes: [
    { path: '/', component: PomodoroTimer, name: 'timer' }
  ]
})

router.afterEach(() => {
  useModalStore().close()
})

export default router
