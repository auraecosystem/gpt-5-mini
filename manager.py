"""
script.pkl manager
Author: Seriki Yakub
"""

import pickle
from pathlib import Path


class PKLManager:

    def __init__(self, folder="storage"):
        self.folder = Path(folder)
        self.folder.mkdir(parents=True, exist_ok=True)

    def _path(self, name):
        if not name.endswith(".pkl"):
            name += ".pkl"
        return self.folder / name

    def save(self, name, obj):
        path = self._path(name)

        with open(path, "wb") as f:
            pickle.dump(obj, f, protocol=pickle.HIGHEST_PROTOCOL)

        print(f"Saved -> {path}")

    def load(self, name):
        path = self._path(name)

        with open(path, "rb") as f:
            return pickle.load(f)

    def exists(self, name):
        return self._path(name).exists()

    def delete(self, name):
        path = self._path(name)

        if path.exists():
            path.unlink()
            print("Deleted:", path)

    def update(self, name, updates):
        data = self.load(name)

        if isinstance(data, dict):
            data.update(updates)
        else:
            raise TypeError("Only dictionaries can be updated.")

        self.save(name, data)

    def list_files(self):
        return [f.name for f in self.folder.glob("*.pkl")]


# =====================================
# Example Usage
# =====================================

manager = PKLManager()

# Save
manager.save("script", {
    "author": "Seriki Yakub",
    "project": "GPT-5 Mini",
    "version": "1.0",
    "languages": ["Python", "JavaScript"],
    "features": [
        "Chat",
        "Vision",
        "Voice",
        "AI Models"
    ]
})

# Check
print(manager.exists("script"))

# Load
data = manager.load("script")
print(data)

# Update
manager.update("script", {
    "version": "2.0",
    "framework": "FastAPI"
})

print(manager.load("script"))

# List all pickle files
print(manager.list_files())

# Delete (optional)
# manager.delete("script")
