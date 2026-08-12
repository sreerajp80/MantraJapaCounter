# Plan: Fix Keystore Path Configuration

**Status:** Pending Approval

## Problem
Building production release APK with `flutter build apk --flavor prod --release --split-per-abi` failed with:
`Keystore file 'L:\Android\keystore\keystore.jks' not found for signing config 'release'.`

In `android/app/build.gradle.kts`, `storeFile = file(props.getProperty("storeFile"))` resolves relative paths starting from `android/app`.
`storeFile=../../../keystore/keystore.jks` goes 3 levels up from `android/app`, resolving to `L:\Android\keystore\keystore.jks` which does not exist.

The keystore is already correctly placed at `keystore/keystore.jks` in the repository root per project guidelines (`AGENTS.md`).

## Proposed Changes
1. Update `android/key.properties`:
   - Change `storeFile=../../../keystore/keystore.jks` to `storeFile=../../keystore/keystore.jks`.

## Files to Change
- `android/key.properties`

## Verification
- Run `flutter build apk --flavor prod --release --split-per-abi` to confirm successful build.
