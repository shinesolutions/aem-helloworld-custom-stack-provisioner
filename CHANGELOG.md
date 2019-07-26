# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased
### Changed
- Restrict iptables and auditd stopping only for RedHat
- Change auditd stopping to use exec instead of service Puppet type

## 0.13.0 - 2019-07-25
### Added
- Enforce auditd stopping temporarily while trialling CIS-benchmarked RHEL7

## 0.12.0 - 2019-06-30
### Added
- Enforce iptables stopping temporarily while trialling CIS-benchmarked RHEL7

## 0.11.0 - 2019-06-17
### Added
- Add HOME env var to inspec exec on post-common.sh as a workaround to latest pry release

## 0.10.0 - 2019-05-31
### Added
- Add HOME env var to inspec exec on pre-common.sh as a workaround to latest pry release

## 0.9.1 - 2019-05-15
### Changed
- Update tests with latest Rubocop

## 0.9.0 - 2019-03-07
### Added
- Initial version
