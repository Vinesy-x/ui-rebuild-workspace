/**
 * 全局 modal store (Pinia)
 * 一个 <ModalShell> 挂在根 layout 根据 currentModal 渲染对应 modal
 * router.afterEach 切屏自动 reset
 */
import { defineStore } from 'pinia'

export type ModalName =
  | null
  | 'session-done'

interface ModalState {
  currentModal: ModalName
  props: Record<string, any>
}

export const useModalStore = defineStore('modal', {
  state: (): ModalState => ({
    currentModal: null,
    props: {}
  }),
  actions: {
    open (name: Exclude<ModalName, null>, props: Record<string, any> = {}) {
      this.currentModal = name
      this.props = props
    },
    close () {
      this.currentModal = null
      this.props = {}
    }
  }
})
