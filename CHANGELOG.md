# Changelog
All notable changes to this project will be documented in this file.

## [Unreleased]

## [2020.1.0] - 2020-1-7

### Added
* NODES!
* Labels
* API documentation
* Post-Processes

### Fixed
* Fix loading of blobs and sound
* Fix rotation
* Fix scene scripts
* Fix image shader

### Changed
* Removed echo physics lib and let devs use their own
* Objects’s x and y are in top-left corner instead of center

## [2019.12.0] - 2019-12-1

### Added
* Shaders!
* Particles:
    * Sprite, Rect, Triangle, Circle
    * Lifetime, speed, start/end angle
* Scripts for scene.
* Improved assets loading.
* More debug:
    * Loaded Images, Fonts and Sounds.
    * Show time taken to update and render.
* You can now set window background color from `window.json`.

### Fixed
* Now delete physics body when object is removed.
* Input coords work properly when moving camera around.

### Changed
* Stringly type keyboard/mouse input is changed to KeyCode/Int type.
* `rice` folder(where scripts are) is renamed to `scripts`.
