from charms.reactive import when, when_not


@when('docker.available')
@when_not('discourse.installed')
def install_discourse():
    pass
