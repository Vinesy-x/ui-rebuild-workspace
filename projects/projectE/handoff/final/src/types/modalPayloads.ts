/**
 * modalPayloads · modal props 共享类型
 * caller (view) + receiver (modal) 共用 · 防 stringly-typed drift
 */

/** bank-info modal · 4 信息文案 key */
export type BankInfoMsg = 'cashback' | 'freebie' | 'premium' | 'broker'

/** shop modal · 双 tab */
export type ShopTab = 'money' | 'jade'
