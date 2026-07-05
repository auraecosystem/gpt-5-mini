```makefile
┌───────────────|
│ Fetch OpenAPI │
│ Specs Repo    │
└───────┬───────┘
        ▼
┌───────────────┐
│ Patch Specs   │
│ Validate JSON │
└───────┬───────┘
        ▼
┌────────────────────────────┐
│ Compute Checksums           │
│ Skip unchanged specs        │
└───────┬────────────────────┘
        ▼
┌────────────────────────────┐
│ Generate TypeScript SDK     │
│  - Multi-file services      │
│  - Single-file services     │
│  - Model-only services      │
│  - Apply custom templates   │
└───────┬────────────────────┘
        ▼
┌────────────────────────────┐
│ Post-processing:           │
│  - Lint & Prettier         │
│  - Update index.ts         │
│  - Generate README/examples│
└───────┬────────────────────┘
        ▼
┌────────────────────────────┐
│ Smoke Tests (optional)     │
│ Compile + basic API calls  │
└───────┬────────────────────┘
        ▼
┌─────────────┐
│ Ready SDK   │
│ for use     │
└─────────────┘
