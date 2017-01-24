

@when('docker.available')
@when_not('discourse.installed')
def install_discourse():
    pass
