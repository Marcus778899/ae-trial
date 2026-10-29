# 專案指令。技術棧待甲方決定（見 docs/architecture.md「待決定」）；定案後由 stack-scaffold 單補上各端的指令。
# docker 不可包在 make 裡（sandbox 限制）：整合測試直接下 docker compose，見 docs/architecture.md §4
-include .env

.PHONY: help setup ci-setup check coverage lint-env

help:
	@echo "setup     本機建立環境（主目錄跑一次，worktree 共用）"
	@echo "ci-setup  CI 安裝相依"
	@echo "check     lint + 不需要容器的測試"
	@echo "coverage  跑全部測試，Cobertura XML 寫到 coverage-reports/（CI 用）"

# 技術棧定案前沒有相依可裝
setup:
	@echo "setup：技術棧未定案，沒有相依要安裝"

ci-setup:
	@echo "ci-setup：技術棧未定案，沒有相依要安裝"

check: lint-env

# .env.example 每個必填變數上一行要有 `# 說明`
lint-env:
	@awk ' \
		/^[A-Za-z_][A-Za-z0-9_]*=/ { if (prev !~ /^# ./) { printf ".env.example:%d %s 缺少上一行的 # 說明\n", NR, $$0; bad = 1 } } \
		{ prev = $$0 } \
		END { exit bad }' .env.example
	@echo "lint-env OK"

# 還沒有程式碼：只建目錄；coverage-gate 在沒改到程式碼時會略過
coverage:
	@mkdir -p coverage-reports
	@echo "coverage：技術棧未定案，沒有測試可跑"
