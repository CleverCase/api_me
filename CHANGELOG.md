# Changelog
All notable changes to this project will be documented in this file.

## [0.14.2] - 2025-10-29
### Added
### Changed
### Deprecated
### Removed
### Fixed
  * Fixed an issue with generating CSV files due to a Rails 7.2 incompatibility.
### Security

## [0.14.1] - 2021-02-02
### Added
  No changes
### Changed
  No changes
### Deprecated
  No changes
### Removed
  No changes
### Fixed
  Fixed a bug where streaming was not working properly.
### Security
  No changes

## [0.14.0] - 2020-12-20
### Added
  Support for CSV streaming
### Changed
  No changes
### Deprecated
  No changes
### Removed
  No changes
### Fixed
  No changes
### Security
  No changes

## [0.13.0] - 2020-08-27
### Added
  No changes
### Changed
  * `create_resource!` and `update_resource!` no longer take params ([@Samsinite][])
  * Controllers can now have custom sorting options ([@Samsinite][])
### Deprecated
  No changes
### Removed
  No changes
### Fixed
  No changes
### Security
  Several Dependency Updates

## [0.12.0] - 2020-01-10
### Added
  No changes
### Changed
  * Update action now responds with the resource instead of nothing. ([@jweakley][])
### Deprecated
  No changes
### Removed
  No changes
### Fixed
  No changes
### Security
  No changes

## [0.11.1] - 2020-01-07
### Added
  * Base controller concern now responds to `ActiveRecord::RecordNotDestroyed` ([@jweakley][])
  * Base controller concern now responds to `ActiveRecord::ReadOnlyRecord` ([@jweakley][])
### Changed
  No changes
### Deprecated
  No changes
### Removed
  No changes
### Fixed
  No changes
### Security
  No changes

## [0.10.5] - 2019-06-25
### Added
  No changes
### Changed
  No changes
### Deprecated
  No changes
### Removed
  No changes
### Fixed
  * Fixed an edge case with ActiveRecord error handling. ([@jweakley][])
### Security
  No changes

## [0.10.4] - 2019-05-13
### Added
  * Added `create_resource!`, `update_resource!`, and `destroy_resource!` method hooks. ([@jweakley][])
  * Added better ActiveRecord error handling. ([@jweakley][])
### Changed
  No changes
### Deprecated
  No changes
### Removed
  No changes
### Fixed
  * Updated `rubocop` violations. ([@jweakley][])
  * Updated broken tests. ([@jweakley][])
### Security
  * Updated `actionview` to 4.2.11.1 per [CVE-2019-5418](https://groups.google.com/forum/#!topic/rubyonrails-security/zRNVOUhKHrg) ([@jweakley][])
  * Updated `activejob` to 4.2.11 per [CVE-2018-16476](https://nvd.nist.gov/vuln/detail/CVE-2018-16476) ([@jweakley][])

## [0.10.3] - 2018-12-17
### Added
  No changes
### Changed
  No changes
### Deprecated
  No changes
### Removed
  No changes
### Fixed
  * Added back `handle_errors` to prevent breakage in apps using this method. ([@samsinite][])
### Security

## [0.10.2] - 2018-12-11
### Added
  * Added CONTRIBUTING.md. ([@jweakley][])
  * Added CHANGELOG.md format. ([@jweakley][])
  * Added Github issue/pull request templates. ([@jweakley][])
  * Added `meta.sort` to index resource responses. git ([@jweakley][])

### Changed
  * Updated README.md to be more inline with other wildland open-source projects. ([@jweakley][])
  * Converted to updated LICENSE.md. ([@jweakley][])

### Deprecated
### Removed
### Fixed
### Security
  * Updated `loofah` to 2.2.3 per [CVE-2018-16468](https://nvd.nist.gov/vuln/detail/CVE-2018-16468)  ([@jweakley][])
  * Updated `rack` to 1.6.1 per [CVE-2018-16471](https://nvd.nist.gov/vuln/detail/CVE-2018-16471)  ([@jweakley][])

[@samsinite]: https://github.com/Samsinite
[@jweakley]: https://github.com/jweakley
