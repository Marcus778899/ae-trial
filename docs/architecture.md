# 專案架構（project-init）

第一階段範圍（v0.1.0）：只做後端 API，不做前端；資料存記憶體、不用資料庫（細節由 manager 記在布告欄與 docs/decisions.md，功能設計見之後的 `todo-design`）。
技術棧尚未定案（見 §7）；本文件定的是與技術棧無關的骨架，選項定案後由 `stack-scaffold` 單（§8）落實。

## 1. 技術棧提案（決策分級②，待甲方決定）

| 選項 | 語言／框架 | 相依數（執行期／開發） | 優點 | 缺點 |
|---|---|---|---|---|
| **A（建議）** | Python 3.12 + FastAPI | 2／4 | 邊界驗證（Pydantic）內建、測試用 TestClient 打真的 app；CI 已有 Python（ae 需要），不用多裝語言 | 執行期多一個 ASGI 伺服器 |
| B | Go + 標準庫 `net/http` | 0／1 | 執行期零第三方套件、單一執行檔 | 輸入驗證與 JSON 錯誤格式要手寫；CI 要多裝 Go |
| C | Node 22 + TypeScript + Fastify | 1／5 | 之後若加前端可共用語言與型別 | 開發相依最多（TS 編譯、lint 設定）；CI 要多裝 Node |

建議 A：在「相依少」與「驗證、錯誤格式不必手寫」之間最平衡，且 CI 不用再裝第二種語言。不需要資料庫，所以三個選項都不需要 `compose.yaml` 與 DB 容器。

### 各選項的相依（版本在 `stack-scaffold` 釘死於清單檔）

| 選項 | 套件 | 用途 |
|---|---|---|
| A | fastapi、uvicorn | Web 框架、ASGI 伺服器 |
| A（開發） | pytest、pytest-cov、httpx、ruff | 測試、Cobertura XML、TestClient、lint + format |
| B（開發） | gocover-cobertura（`go run` 執行，不進執行期） | 把 `cover.out` 轉成 Cobertura XML；lint 用內建 `gofmt`、`go vet` |
| C | fastify | Web 框架（內建 JSON schema 驗證） |
| C（開發） | typescript、vitest、@vitest/coverage-v8、eslint、typescript-eslint | 編譯、測試、Cobertura XML、lint |

## 2. 目錄結構（以選項 A 為例；B、C 只換 `api/` 內部）

| 路徑 | 內容 | 負責 |
|---|---|---|
| `api/app/` | 後端程式（含記憶體儲存） | backend worker |
| `api/tests/unit/` | 後端單元測試 | backend worker |
| `api/tests/conftest.py` | 共用 fixture（app、client） | `stack-scaffold` 建，qa 不改 |
| `docs/design/`、`docs/contracts/` | 設計、契約 | architect |
| `Makefile`、`.env.example`、`.github/workflows/ci.yml`、`.coverage-exempt`、`.gitignore`、清單檔 | 跨界檔 | architect；功能單需要時在設計的「檔案分工」指定 |

## 3. 驗收測試目錄（qa 寫，worker 不可改）

| 目錄 | 每張單的子目錄 | 怎麼跑 |
|---|---|---|
| `api/tests/acceptance/` | `<task_id>/` | `make check`（資料在記憶體，不需要容器） |

只有後端，沒有跨前後端的流程，第一階段不設整合測試目錄；之後加前端或資料庫時再加 `tests/integration/` 與 `compose.yaml`。

## 4. 指令

| 指令 | 用途 | 現況 |
|---|---|---|
| `make setup` | 主目錄建立環境（例：`.venv`），worktree 共用 | 技術棧定案前不做事 |
| `make ci-setup` | CI 安裝相依（跟 `setup` 用同一份清單檔） | 同上 |
| `make check` | lint + 全部測試（單元與驗收測試都不需要容器） | 目前只檢查 `.env.example` 格式 |
| `make coverage` | 全部測試，Cobertura XML 寫到 `coverage-reports/` | 目前只建目錄 |
| `make run-api` | 啟動 API（讀 `API_PORT`） | `stack-scaffold` 加 |

Makefile 用 `-include .env` 讀設定。

## 5. 設定

變數清單與說明只在 `.env.example`；程式只從環境變數讀。目前：`API_PORT`（甲方填）、`HOST_UID`／`HOST_GID`（選填，之後有容器才用到）。

## 6. 自行決定（可逆；甲方核可時一起看）

| 項目 | 決定 |
|---|---|
| 目錄名 | 後端 `api/`、驗收測試 `api/tests/acceptance/` |
| 技術棧定案前的 Makefile | target 都有，不做事並印出原因；`check` 先檢查 `.env.example` 每個必填變數都有說明 |
| 覆蓋率格式 | Cobertura XML（`coverage-reports/api.xml`），不用 JaCoCo，`COVERAGE_SRC_ROOTS` 留空 |
| 錯誤格式 | 照 backend-standards：`{"error": {"code", "message"}}`（實際的 code 在 todo 契約定） |

## 7. 待決定（manager 開 D-編號）

- 技術棧：選項 A／B／C（§1），建議 A
- `API_PORT` 的值：不用開 D-編號，甲方填進 `.env`

## 8. 後續派工

- `stack-scaffold`（技術棧定案後）：清單檔、`api/` 骨架與 `conftest.py`、Makefile 各 target 與 `run-api`、CI 加語言版本（選 B、C 時）
- `todo-design`（architect）：GET／POST `/todos` 的契約與設計，沿用本文件 §2、§3
