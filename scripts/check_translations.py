#!/usr/bin/env python3
import json
import os
import sys
from typing import Dict, Set

# This script checks that en.json and ar.json have identical translation key sets.
# It recursively flattens JSON objects into dot-notated keys, ignoring list contents.

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
TRANSLATIONS_DIR = os.path.join(ROOT, 'assets', 'translations')
EN_PATH = os.path.join(TRANSLATIONS_DIR, 'en.json')
AR_PATH = os.path.join(TRANSLATIONS_DIR, 'ar.json')

IGNORED_PREFIXES = set()  # e.g., {'debug.'}


def load_json(path: str) -> Dict:
    with open(path, 'r', encoding='utf-8') as f:
        return json.load(f)


def flatten_keys(obj, prefix: str = '') -> Set[str]:
    keys: Set[str] = set()
    if isinstance(obj, dict):
        for k, v in obj.items():
            full = f"{prefix}.{k}" if prefix else k
            # Skip ignored prefixes
            if any(full.startswith(p) for p in IGNORED_PREFIXES):
                continue
            keys.add(full)
            keys |= flatten_keys(v, full)
    # lists and primitives are ignored for key structure
    return keys


def main() -> int:
    try:
        en = load_json(EN_PATH)
        ar = load_json(AR_PATH)
    except FileNotFoundError as e:
        print(f"❌ File not found: {e}")
        return 1
    except json.JSONDecodeError as e:
        print(f"❌ JSON parse error: {e}")
        return 1

    en_keys = flatten_keys(en)
    ar_keys = flatten_keys(ar)

    only_in_en = sorted(en_keys - ar_keys)
    only_in_ar = sorted(ar_keys - en_keys)

    if only_in_en or only_in_ar:
        if only_in_en:
            print("❌ Keys missing in ar.json:")
            for k in only_in_en:
                print(f"  - {k}")
        if only_in_ar:
            print("❌ Keys missing in en.json:")
            for k in only_in_ar:
                print(f"  - {k}")
        return 1

    print("✅ Translations OK: en.json and ar.json have matching keys.")
    return 0


if __name__ == '__main__':
    sys.exit(main())
