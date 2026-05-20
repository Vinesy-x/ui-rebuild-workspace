import { createApp } from 'vue'
import { createPinia } from 'pinia'
import router from './router'
import App from './App.vue'

import './styles/tokens.css'
import './styles/components.css'

createApp(App)
  .use(createPinia())
  .use(router)
  .mount('#app')
