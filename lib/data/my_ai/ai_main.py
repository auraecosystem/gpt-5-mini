import argparse, json, sys

def load_json(path):
    try:
        with open(path, "r", encoding="utf-8") as f:
            return json.load(f)
    except Exception as e:
        print(f"Error loading {path}: {e}")
        sys.exit(1)

def merge_configs(core, module):
    # Core is base, module overrides/adds
    merged = core.copy()
    merged.update(module)
    return merged

def main():
    parser = argparse.ArgumentParser(description="AI Loader")
    parser.add_argument("--core", required=True, help="Path to core config")
    parser.add_argument("--module", required=True, help="Path to module config")
    args = parser.parse_args()

    core_config = load_json(args.core)
    module_config = load_json(args.module)

    ai_settings = merge_configs(core_config, module_config)

    print("✅ AI loaded with settings:")
    for k, v in ai_settings.items():
        print(f"  {k}: {v}")

    # ---- Your AI logic goes here ----
    # For now, just simulating
    print("\n🤖 AI is running...")

if __name__ == "__main__":
    main()
