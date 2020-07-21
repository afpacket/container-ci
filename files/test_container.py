import pytest

@pytest.mark.parametrize('file', [
    '/usr/bin/kubectl',
    '/usr/local/bin/helm',
    '/usr/local/bin/istioctl',
    '/usr/local/bin/packer',
    '/usr/local/bin/terraform',
    '/usr/local/bin/vault'
])
def test_bin_files(host, file):
    bin_file = host.file(file)
    assert bin_file.exists
    assert bin_file.is_file
    assert bin_file.user == 'root'
    assert bin_file.group == 'root'
    assert bin_file.mode == 0o755

def test_user_ci(host):
    ci = host.user("ci")
    assert ci.exists
    assert ci.uid == 987
    assert ci.gid == 987
    assert ci.home == '/home/ci'
    assert ci.shell == '/bin/bash'
