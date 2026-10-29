# 專案架構（project-init）

技術棧尚未定案（見 §7 待決定）；本文件定的是與技術棧無關的骨架，§1 的選項定案後由 `stack-scaffold` 單（§8）落實。

## 1. 技術棧提案（決策分級②，待甲方決定）

| 選項 | 後端 | 前端 | DB | 優點 | 缺點 |
|---|---|---|---|---|---|
| **A（建議）** | Python 3.12 + FastAPI | TypeScript + React + Vite | PostgreSQL（compose） | 邊界驗證（Pydantic）與 OpenAPI 內建、對得上契約；Alembic 每支 migration 有 downgrade；CI 已有 Python | 兩種語言、兩套 lint／測試 |
| B | Node 22 + TypeScript + Fastify + Prisma | 同 A | PostgreSQL（compose） | 單一語言，前後端可共用型別 | Prisma 的 down migration 要手寫；後端相依數較多 |
| C（最輕） | Python 3.12 + FastAPI | 原生 HTML／JS（ES modules，無 build；Makefile 從 `.env` 產生設定檔） | SQLite（檔案） | 相依最少、不需要 DB 容器 | 畫面變多後難維護；SQLite 不適合多人同時寫入 |

建議 A：需求預期是有前後端的 web 應用，A 在「相依少」與「之後不用換」之間最平衡；B 若甲方偏好單一語言也可行。

### 選項 A 的相依（版本在 `stack-scaffold` 釘死於清單檔）

| 套件 | 端 | 理由 |
|---|---|---|
| fastapi、uvicorn | 後端 | Web 框架與 ASGI 伺服器 |
| pydantic-settings | 後端 | 從環境變數讀設定、缺值啟動失敗（fail fast） |
| sqlalchemy、alembic、psycopg | 後端 | ORM 參數綁定、可 down 的 migration、PostgreSQL 驅動 |
| pytest、pytest-cov、httpx | 後端（開發） | 測試、Cobertura XML、TestClient |
| ruff | 後端（開發） | lint + format |
| react、react-dom、vite、typescript | 前端 | UI 與 build |
| vitest、@vitest/coverage-v8、@testing-library/react、jsdom | 前端（開發） | 單元／元件測試與 Cobertura XML |
| eslint、typescript-eslint | 前端（開發） | lint；型別檢查用 `tsc --noEmit` |
| postgres（Docker image） | 服務 | 整合測試與本機開發 DB |

不列 E2E 瀏覽器測試（Playwright）：整合測試先打 API；要加另提（見 §7）。

## 2. 目錄結構（以選項 A 為例；B 相同，只換 `api/` 內部）

| 路徑 | 內容 | 負責 |
|---|---|---|
| `api/app/` | 後端程式 | backend worker |
| `api/migrations/` | Alembic migration | backend worker |
| `api/tests/unit/` | 後端單元測試 | backend worker |
| `web/src/` | 前端程式 | frontend worker |
| `web/src/styles/tokens.css` | 設計 token（前端直接載入） | designer |
| `web/tests/unit/` | 前端單元測試 | frontend worker |
| `docs/design/`、`docs/contracts/` | 設計、契約 | architect |
| `docs/ui/` | UI 規格 | designer |
| `compose.yaml` | `db` 與 `test` 服務 | architect（受保護路徑） |
| `Makefile`、`.env.example`、`.github/workflows/ci.yml`、`.coverage-exempt`、`.gitignore` | 跨界檔 | architect；功能單需要時在設計的「檔案分工」指定 |

## 3. 驗收測試與整合測試目錄（qa 寫，worker 不可改）

| 目錄 | 每張單的子目錄 | 怎麼跑 |
|---|---|---|
| `api/tests/acceptance/` | `<task_id>/` | 不需 DB 的在 `make check`；需 DB 的在 compose `test` 服務 |
| `web/tests/acceptance/` | `<task_id>/` | `make check` |
| `tests/integration/` | `<task_id>/`（整合單） | compose `test` 服務；CI 由 `make coverage` 跑到 |

共用 fixture（例 `api/tests/conftest.py`）放上層，在骨架單建好，qa 不改。

## 4. 指令

| 指令 | 用途 | 現況 |
|---|---|---|
| `make setup` | 主目錄建立 `.venv`、`node_modules`（worktree 共用） | 技術棧定案前是空操作 |
| `make ci-setup` | CI 安裝相依（與 `setup` 同一份清單檔） | 同上 |
| `make check` | lint + 不需要容器的測試 | 目前只檢查 `.env.example` 格式 |
| `make coverage` | 全部測試，每端一份 Cobertura XML 到 `coverage-reports/` | 目前只建目錄 |
| `docker compose --env-file .env -f .worktrees/<id>/compose.yaml run --rm test` | 整合測試（在主目錄直接下，不可包進 make） | 有 DB 後才有 |

Makefile 以 `-include .env` 讀設定；服務啟動指令（`make run-api`、`make run-web`）在 `stack-scaffold` 加。

## 5. 設定

變數清單與說明只在 `.env.example`；程式只從環境變數讀。目前：`API_PORT`、`WEB_PORT`（甲方填）、`HOST_UID`／`HOST_GID`（選填）。DB 連線變數在 `stack-scaffold` 依定案的 DB 加。

## 6. 自行決定（可逆；甲方核可時一起看）

| 項目 | 決定 |
|---|---|
| 目錄名 | 後端 `api/`、前端 `web/`、整合測試 `tests/integration/` |
| 技術棧定案前的 Makefile | target 都存在、空操作並印出原因；`check` 先檢查 `.env.example` 每個必填變數都有說明 |
| 覆蓋率格式 | 各端 Cobertura XML（`coverage-reports/python.xml`、`coverage-reports/web.xml`），不用 JaCoCo，`COVERAGE_SRC_ROOTS` 留空 |
| 錯誤格式、授權、migration | 照 backend-standards（`{"error": {"code", "message"}}`、預設需登入、expand→contract） |

## 7. 待決定（manager 開 D-編號）

- 技術棧：選項 A／B／C（§1），建議 A；含 DB（PostgreSQL 容器或 SQLite）
- 是否加入瀏覽器 E2E 測試工具（Playwright，新套件）；建議第一階段先不加
- `API_PORT`、`WEB_PORT` 的值（甲方填進 `.env`）

## 8. 後續派工

- `stack-scaffold`（architect，技術棧定案後）：清單檔、`api/`、`web/` 骨架與 conftest、`compose.yaml`、Makefile 各 target、CI 加 `setup-node` 與 `docker compose up -d db`
- 第一階段功能設計：需求到了再開，沿用本文件 §2、§3
