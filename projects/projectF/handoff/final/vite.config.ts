import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],
  resolve: { alias: { '@': '/src' } },
  // projectF 固定 5180 · 避免跟 projectE (5173) / AI-Battle / 其他 vite 冲突
  // strictPort: 端口被占就报错 · 不静默切其他端口
  server: { port: 5180, strictPort: true },
  preview: { port: 5180, strictPort: true }
})
