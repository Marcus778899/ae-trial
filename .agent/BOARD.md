# 布告欄

<!-- 只放目前這一階段；只有 manager 透過 ae board 修改；階段完成時整份封存到 .agent/tasks/<tag>.md -->

## 目標與範圍

- 本輪：v0.1.0 Todo 後端 API：GET /todos 列出、POST /todos 新增（title trim 後為空回 400＋錯誤訊息），資料存記憶體；驗收：make check 全過、PR CI（check、security）全綠
- 不做：前端、資料庫

## 已定案決策（細節見 docs/decisions.md；要改先問甲方）

| 日期 | 編號 | 決策 |
|---|---|---|

## 任務狀態

| 任務 | 負責 | 狀態 | 嘗試 | 驗收證據 |
|---|---|---|---|---|
| project-init | architect | blocked | 0 |  |

## 卡住／待甲方決定

- D-001：project-init 的 worktree 缺 .gitmodules，ae pr open 擋下，sandbox 內無法還原（待甲方）

## 注意事項（踩過的坑）

- （無）
