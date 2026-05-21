/**
 * mergeHud · 共享 view utility
 * 各 view 顶部都有相同模式:把 mainMenu.hud 的默认 9 资源
 * 跟本 view 的 `screen.hudOverrides`(可选,覆盖几个 cell + 日期)合并。
 *
 * 用法(InvestBank / BusinessList / WorkDAG / 任何带 screen.hudOverrides 的 view):
 *   const hud = computed(() => mergeHud(mainMenu.hud, data.screen.hudOverrides, data.screen.date))
 */
import type mainMenuJson from '../data/mainMenu.json'

type Hud = typeof mainMenuJson.hud

/** view-local override:9 资源 cell 任意子集 + 必带 date */
export interface HudOverrides extends Partial<Omit<Hud, 'date'>> {}

export interface HudDate { era: string; day: string; m: string }

export function mergeHud (base: Hud, overrides: HudOverrides | undefined, date: HudDate): Hud {
  return {
    ...base,
    ...(overrides ?? {}),
    date
  }
}
