"""
Default configurations.
"""

configs = {
    'debug': True,
    'db': {
        'host': '127.0.0.1',
        'port': 3306,
        'user': 'root',
        'password': 'wxd',
        'db': 'web'
    },
    'session': {
        'secret': 'web'
    }
}
