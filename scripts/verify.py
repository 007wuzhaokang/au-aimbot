#!/usr/bin/env python3
"""
Au Aimbot 发布包校验脚本
用法: python scripts/verify.py
校验 release/Au.exe 的 SHA256 / MD5 / 文件大小，确保与官方发布一致。
"""
import hashlib
import os
import sys

EXPECTED = {
    "path": "release/Au.exe",
    "size": 77716480,
    "sha256": "847fe9361927df2b204a07c8bd3967fd18f7ad3e5b58a921f587d0f13e693841",
    "md5": "bac16255f92289c937bbd0923d506b2b",
}


def main() -> int:
    root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    target = os.path.join(root, EXPECTED["path"])
    if not os.path.isfile(target):
        print(f"[失败] 未找到 {EXPECTED['path']}")
        return 1

    size = os.path.getsize(target)
    sha256 = hashlib.sha256()
    md5 = hashlib.md5()
    with open(target, "rb") as f:
        for chunk in iter(lambda: f.read(65536), b""):
            sha256.update(chunk)
            md5.update(chunk)

    ok = True
    if size != EXPECTED["size"]:
        print(f"[失败] 大小不符: 实际 {size}, 期望 {EXPECTED['size']}")
        ok = False
    else:
        print(f"[通过] 大小: {size}")

    sha = sha256.hexdigest()
    if sha != EXPECTED["sha256"]:
        print(f"[失败] SHA256 不符:\n  实际   {sha}\n  期望   {EXPECTED['sha256']}")
        ok = False
    else:
        print(f"[通过] SHA256: {sha}")

    md = md5.hexdigest()
    if md != EXPECTED["md5"]:
        print(f"[失败] MD5 不符:\n  实际   {md}\n  期望   {EXPECTED['md5']}")
        ok = False
    else:
        print(f"[通过] MD5: {md}")

    print("\n校验" + ("通过 ✅" if ok else "失败 ❌"))
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
