Contribute
==========

## Requirements

This repo uses an automated CI pipeline to evaluate any new changes pushed to the repo.  Every time a new commit is pushed, the following things will happen:

* Linting
* Syntax checking (on code, hieradata, and templates)
* Puppetfile syntax checking
* Validate that all code in profile/role has spec tests (currently only checked 1 nested directory level - e.g. profile/manifests/dir/)
* spec tests are run

The GitHub repo is configured to validate that the above tasks have succeeded before the pull request can be merged.  In addition, at least one reviewer is required.

### Feature Branch
All added users have the abilty to create new branches on this repo.  (Contact the puppetlabs-seteam owners if you need added).  The production branch has been protected to prevent direct pushing.  To make changes, the general process will be:

* Checkout
* Create local feature branch
* Make updates (See [helpers](#helpers) section below)
* Run local tests
* Push
* Create PR
* Request Review
* Merge after approval from review and sucessful CI job

## Local Testing
Rather then pushing your code and having to wait until the CI job fails... you can run your tests locally! (So you are almost sure they will pass!).

### Pre-reqs

* Install ruby (CI job currently running 2.3.1)
* Install bundler gem


### Testing

From root of control-repo:

```
bundle install
bundle exec rake lint
bundle exec rake syntax
bundle exec rake r10k:syntax
```

Example output:

> Note for check_for_spec_tests and lint tests there will be no output on success

```
$ bundle exec rake lint
$ bundle exec rake syntax
---> syntax:manifests
---> syntax:templates
---> syntax:hiera:yaml
$ bundle exec rake r10k:syntax
Syntax OK
$ bundle exec rake check_for_spec_tests
```

Next, the rspec tests need to be run.  Currently their are spec tests for only the role/profile module in the control repo.  To execute them, follow the directions below.

> Note, only tests compatible with your host platform will be executed.  The CI pipeline will run all tests for all platforms!

_profile:_
```
$ cd <control-repo>/site/profile
$ bundle install
$ bundle exec rake spec
[...output truncated...]
```

_role:_
```
$ cd <control-repo>/site/role
$ bundle install
$ bundle exec rake spec
[...output truncated...]
```

Correct any failing tests prior to pushing upstream.


## Helpers

These are rake jobs that automate a few simple tasks.

> Note: Helpers in this section exist at the base of control-repo directory - not within the role/profile module

**`bundle exec rake generate_fixtures`**:

This rake job is used to automatically update the `.fixtures` files in profile and role whenever you make updates to the Puppetfile.  If you do not run this when updating the Puppetfile your tests will execute against the old module version. (Note: This process will be automated in a future release)

**`bundle exec rake check_for_spec_tests`**:

This rake job is used to validate that tests exist for all puppet code within `site/profile/manifests/*/*` and `site/role/manifests/*/*`.

**`bundle exec rake generate_spec_tests`**:

This rake job is used to generate new files for missing spec test classes.  They will be stubbed out with a basic compile tests, but can (and probably should) be expanded on.











