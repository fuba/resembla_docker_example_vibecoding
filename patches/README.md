# Patches

This directory contains patches required to build Resembla on modern systems.

## icu-namespace-fix.patch

This patch fixes ICU namespace issues that occur when building Resembla with newer versions of ICU library on Debian bookworm.

### Problem
The original Resembla code uses ICU classes without proper namespace qualification, causing compilation errors with ICU 72+ where classes are in the `icu::` namespace.

### Solution
The patch adds `using namespace icu;` declarations to the necessary source files:
- `src/string_normalizer.hpp` and `src/string_normalizer.cpp`
- `src/symbol_normalizer.hpp` and `src/symbol_normalizer.cpp`
- `src/string_util.hpp` and `src/string_util.cpp`

### Application
The patch is automatically applied during the Docker build process. If the patch fails to apply, the build process falls back to using `sed` commands to make the necessary changes.

### Compatibility
This patch is tested with:
- Debian bookworm
- ICU 72.1
- GCC 12