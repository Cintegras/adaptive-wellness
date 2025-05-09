# Metro Bundler Fix

## Issue
When running `expo start`, the following error was encountered:

```
Error: Cannot find module 'metro/src/ModuleGraph/worker/importLocationsPlugin'
```

This error occurred because of a version mismatch between the Metro bundler and the @expo/metro-config package.

## Solution
The issue was resolved by:

1. Downgrading Expo from version 53.0.8 to 49.0.0 to ensure compatibility with Metro
2. Installing specific versions of Metro and related packages:
   - metro: 0.73.7
   - metro-core: 0.73.7
   - metro-runtime: 0.73.7
   - metro-source-map: 0.73.7
   - metro-resolver: 0.73.7
   - metro-config: 0.73.7
3. Installing a compatible version of @expo/metro-config:
   - @expo/metro-config: 0.7.1
4. Creating a custom metro.config.js file with a minimal configuration

## Verification
A test script was created to verify that Metro can initialize without errors. The test was successful, indicating that the issue has been resolved.

## Additional Notes
- The application may still take some time to start, but the error about the missing module has been resolved.
- If you encounter similar issues in the future, ensure that all Metro-related packages are at compatible versions.
- Expo 49 is a stable version that works well with Metro 0.73.7 and @expo/metro-config 0.7.1.