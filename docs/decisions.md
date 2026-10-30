# 決策紀錄

需要甲方決定的事都在這裡，由 manager 維護。流程：agent 提問 → manager 寫進「待決定」→ 甲方回覆 → manager 移到「已決定」。
其他文件一律用編號引用（例：見 D-003），不重寫內容。

## 待決定

### D-002 後端技術棧
- 背景：v0.1.0 只做 Todo 後端 API、資料存記憶體；決定語言／框架與相依（決策分級②），定案後由 `stack-scaffold` 落實
- 選項：A. Python 3.12 + FastAPI ／ B. Go + 標準庫 net/http ／ C. Node 22 + TypeScript + Fastify（比較見 `docs/architecture.md` §1）
- 建議：A。輸入驗證與錯誤格式不用手寫，相依也少；CI 本來就有 Python，不用多裝一種語言
- 提出：architect（project-init）

### D-003 CI 抓不到私有工具 repo（agent-engineering），所有 PR 的 CI 都紅
- 背景：`.github/workflows/ci.yml` 兩個 checkout 步驟用 `submodules: true`，沒帶 token，GitHub 回 repository not found。repo 已經有 `AE_TOKEN` secret，但 3ab9b7f 只更新了子模組，ci.yml 沒有改
- 選項：A. 在 project-init 追加一項：兩個 checkout 加 `token: ${{ secrets.AE_TOKEN }}`，由 architect 改，qa 重新驗證 ／ B. 你自己改 ci.yml（或照工具文件設定）
- 建議：A。ci.yml 這張單本來就在改，順便修掉最快。前提是 AE_TOKEN 能讀 Marcus778899/agent-engineering（Contents: read）
- 提出：manager（project-init 的 CI）

<!-- 範本：
### D-001 一句話問題
- 背景：為什麼要決定（1–2 行）
- 選項：A. … ／ B. …
- 建議：A，理由一行
- 提出：architect（todo-design）
-->

## 已決定

### D-001 worktree 少了 `.gitmodules`，`ae pr open` 擋下，sandbox 內無法還原
- 決定：A. 甲方在自己的終端機（sandbox 外）跑 `git -C <worktree> restore .gitmodules`，工具問題另外回報給 agent-engineering
- 理由：先讓本單繼續，不等工具修正
- 影響：project-init；之後新開的 worktree 若同樣缺檔，照此處理
- 日期：2026-10-29

<!-- 範本：
### D-001 一句話問題
- 決定：A. …
- 理由：一行
- 影響：docs/contracts/todos.md §2、BE-01
- 日期：YYYY-MM-DD
-->
