Base repo for TSE's env reboot
==============================

# Contributing

## Feature Branch
There is no need to create a fork, but you can if you want to.  Regardless, create a feature branch from production, add your new content, run tests defined below, and open a PR to production.  The PR requires reviewers and successful CI job execution.

## Testing locally

Pre-reqs:

* Install rbenv (Can use ruby 2.3)
* Install bundler

From root of control-repo:
```
bundle install
bundle exec rake -T (list rake tasks)
bundle exec rake lint
bundle exec rake syntax
bundle exec rake r10k:syntax
```

## Manual Acceptance tests
Here is heat template for a small testing stack: https://github.com/murdok5/tse-stack-slice/blob/master/pe_small.hot.yaml
poing the code manager to your public fork for testing where possible.
