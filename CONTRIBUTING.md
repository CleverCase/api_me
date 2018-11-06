# Contributing

If you discover issues, have ideas for improvements or new features,
please report them to the [issue tracker][1] of the repository or
submit a pull request. Please, try to follow these guidelines when you
do so.

## Issue reporting

* Check that the issue has not already been reported.
* Check that the issue has not already been fixed in the latest code
  (a.k.a. `master`).
* Be clear, concise and precise in your description of the problem.
* Open an issue with a descriptive title and a summary in grammatically correct,
  complete sentences.
* Include the version of `api_me` that you are using.
* Include any relevant code to the issue summary.

## Pull requests

* Read [how to properly contribute to open source projects on GitHub][2].
* Fork the project.
* Use a topic/feature branch to easily amend a pull request later, if necessary.
* Write [good commit messages][3].
* Use the same coding conventions as the rest of the project.
* Commit and push until you are happy with your contribution.
* If your change has a corresponding open GitHub issue, prefix the commit message with `[Fix #github-issue-number]`.
* Make sure to add tests for it. This is important so I don't break it
  in a future version unintentionally.
* Add an entry to the [Changelog](CHANGELOG.md) accordingly. See [changelog entry format](#changelog-entry-format).
* Please try not to mess with the package.json, version, or history. If
  you want to have your own version, or is otherwise necessary, that
  is fine, but please isolate to its own commit so we can cherry-pick
  around it.
* Make sure the test suite is passing (`bundle exec rake`).
* [Squash related commits together][5].
* Open a [pull request][4] that relates to *only* one subject with a clear title
  and description in grammatically correct, complete sentences.

### Changelog entry format

Locate the `Unreleased` section at the top of the `CHANGELOG.md` and add you entry to the appropriate section.
#### Sections:
- **Added** for new features
- **Changed** for changes in existing functionality
- **Deprecated** for soon-to-be removed features
- **Removed** for now removed features
- **Fixed** for any bug fixes
- **Security** in case of vulnerabilities

Here are some examples:
```
## [Unreleased]
### Added
  * [#56](https://github.com/wildland/api_me/issues/56): Added contribution guidelines and documentations. ([@jweakley][])
### Fixed
  * Fixed minor grammatical errors in README.md. ([@jweakley][])
```

* Mark it up in [Markdown syntax][6].
* The entry line should start with `* ` (an asterisk and a space).
* The entry should be in the most appropriate section.
* If the change has a related GitHub issue (e.g. a bug fix for a reported issue), put a link to the issue as `[#56](https://github.com/wildland/api_me/issues/56): `.
* Describe the brief of the change. The sentence should end with a punctuation.
* At the end of the entry, add an implicit link to your GitHub user page as `([@username][])`.
* If this is your first contribution to `api_me` project, add a link definition for the implicit link to the bottom of the changelog as `[@username]: https://github.com/username`.

[1]: https://github.com/wildland/ember-bootstrap-controls/issues
[2]: http://gun.io/blog/how-to-github-fork-branch-and-pull-request
[3]: http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html
[4]: https://help.github.com/articles/using-pull-requests
[5]: http://gitready.com/advanced/2009/02/10/squashing-commits-with-rebase.html
[6]: http://daringfireball.net/projects/markdown/syntax
[7]: https://github.com/ciena-blueplanet/ember-prop-types
[8]: https://github.com/ember-a11y/ember-a11y-testing
