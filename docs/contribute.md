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

#### Gimme a shortcut

To run all tests together in one command, i.e. execute lint, syntax, r10k:syntax, check for missing spec tests, and launch rspec tests, you can run the following command:

```
bundle exec rake run_tests
Executing Lint Test...
  -> Success!
Executing Syntax Test...
  -> Success!
Executing r10k(Puppetfile) Syntax Test...
  -> Syntax OK
Checking for missing spec tests...
  -> No missing tests!
Launching rspec tests...
Generating Fixtures...Done!
[...truncated...]
```

#### Run the commands individually

From root of control-repo:

```
bundle install
bundle exec rake lint
bundle exec rake syntax
bundle exec rake r10k:syntax
bundle exec rake check_for_spec_tests
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

Next, the rspec tests need to be run.

> Note, only tests compatible with your host platform will be executed.  The CI pipeline will run all tests for all platforms!

```
bundle exec rake spec
[...output truncated...]
```

Correct any failing tests prior to pushing upstream.


## Helpers

These are rake jobs that automate a few simple tasks.

**`bundle exec rake check_for_spec_tests`**:

This rake job is used to validate that tests exist for all puppet code within `site-modules/profile/manifests/*/*` and `site-modules/role/manifests/*/*`.

**`bundle exec rake generate_spec_tests`**:

This rake job is used to generate new files for missing spec test classes.  They will be stubbed out with a basic compile tests, but can (and probably should) be expanded on.

