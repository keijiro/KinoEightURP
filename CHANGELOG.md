# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [2.0.1] - 2026-01-01

### Changed

- Switched color distance calculations to OKLab space for improved reduction accuracy.
- Optimized OKLab conversion with a Burst-compiled path.

### Fixed

- Fixed bias in dithering.
- Fixed sampling point bias by offsetting half a pixel.

## [2.0.0] - 2025-12-31

### Added

- Added a custom inspector UI for EightColorController.
- Added extended mode with 16-color palette support.

### Changed

- Migrated the EightColor shader from Shader Graph to HLSL and refactored it.
- Updated palette uploads to use SetColorArray.
- Refined shader property types and precision.
- Updated the README.

## [1.0.1] - 2025-12-29

### Added

- Added signing for Unity 6.3.

## [1.0.0] - 2024-12-27

### Added

- Initial release
