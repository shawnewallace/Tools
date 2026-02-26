#!/usr/bin/env bash
set -euo pipefail

# Deep-clean a .NET project: dotnet clean, clear NuGet cache, remove all bin/obj/node_modules dirs
# Usage: ./dotnet_clean.sh [directory]
#   directory  Root directory to clean (default: current directory)

TARGET_DIR="${1:-.}"
TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"

echo "Cleaning .NET project at: $TARGET_DIR"
echo

# 1. dotnet clean
echo ">> dotnet clean"
dotnet clean "$TARGET_DIR"
echo

# 2. Clear NuGet caches
echo ">> Clearing NuGet cache"
dotnet nuget locals all --clear
echo

# 3. Remove all bin, obj, and node_modules directories
echo ">> Removing bin/, obj/, and node_modules/ directories"
while IFS= read -r -d '' dir; do
  echo "   Removing: $dir"
  rm -rf "$dir"
done < <(find "$TARGET_DIR" -type d \( -name "bin" -o -name "obj" -o -name "node_modules" \) -print0)

echo
echo "Done. This project...is clean."
