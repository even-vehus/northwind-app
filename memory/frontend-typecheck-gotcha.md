---
name: frontend-typecheck-gotcha
description: How to actually type-check the frontend; root tsc --noEmit is a no-op
metadata:
  type: project
---

To type-check the frontend, run `npm run build` (which runs `tsc -b && vite build`) from `frontend/`. Running `npx tsc --noEmit` from the frontend root reports **exit 0 while checking nothing** — the root `tsconfig.json` uses project references with no `include`, so the real gate is `tsc -b` against `tsconfig.app.json`.

**Why:** A prior session (Copilot) reported "TypeScript: exit 0, zero errors" but the production build was actually broken with 17 errors — it had only ever run the no-op `tsc --noEmit`.

**How to apply:** Always smoke-test frontend changes with `npm run build`, never trust `tsc --noEmit` alone.

MUI **v9.0.1** is genuinely installed (not aspirational per CLAUDE.md) and enforces breaking API changes:
- TextField `inputProps={X}` → `slotProps={{ htmlInput: X }}`; `InputLabelProps={{ shrink: true }}` → `slotProps={{ inputLabel: { shrink: true } }}`
- `<Typography fontWeight="bold">` → `<Typography sx={{ fontWeight: "bold" }}>`
- `<ToggleButton value={null}>` is rejected — use a string sentinel like `value="all"`
