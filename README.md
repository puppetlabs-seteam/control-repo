Puppet SE Demo Environment
==========================

This is the control-repo used by the Puppet SE team.

* [Consume](docs/consume.md)
* [Contribute](docs/contribute.md)

## Testing

In order to run tests on this environment install the gems:

```shell
bundle install
```

The run the onceover tests using:

```shell
bundle exec onceover run spec --parallel
```

The config for the testing lives in `spec/onceover.yaml`
