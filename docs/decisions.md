# 決策紀錄

需要甲方決定的事都在這裡，由 manager 維護。流程：agent 提問 → manager 寫進「待決定」→ 甲方回覆 → manager 移到「已決定」。
其他文件一律用編號引用（例：見 D-003），不重寫內容。

## 待決定

<!-- 範本：
### D-001 一句話問題
- 背景：為什麼要決定（1–2 行）
- 選項：A. … ／ B. …
- 建議：A，理由一行
- 提出：architect（todo-design）
-->

### D-001 worktree 少了 `.gitmodules`，`ae pr open` 擋下，sandbox 內無法還原
- 背景：`ae task new` 建的 worktree 沒有 checkout `.gitmodules`，git 視為未提交的刪除，`ae pr open` 拒絕；sandbox 禁止在 worktree 寫 `.gitmodules`，agent 無法還原。之後每張單都可能遇到
- 選項：A. 甲方在自己的終端機（sandbox 外）跑 `git -C /Users/marcus/sandbox/ae-trial/.worktrees/project-init restore .gitmodules`，本單先繼續；工具問題另外回報給 agent-engineering ／ B. 甲方先修工具（worktree 的 sparse 設定或 `ae pr open` 的檢查）再繼續
- 建議：A 先解這張單；同時把問題回報工具，否則之後每張單都要手動還原一次
- 提出：manager（project-init）

## 已決定

<!-- 範本：
### D-001 一句話問題
- 決定：A. …
- 理由：一行
- 影響：docs/contracts/todos.md §2、BE-01
- 日期：YYYY-MM-DD
-->
