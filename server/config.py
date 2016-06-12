# -*- coding: utf-8 -*-

"""
Configuration. how to use ?
"""
import config_default


# Simple dict but support access as x.y style.
class Dict(dict):
    def __init__(self, name=(), values=(), **kw):
        super(Dict, self).__init__(**kw)
        # zip()
        for k, v in zip(name, values):
            self[k] = v

    def __getattr__(self, key):
        try:
            return self[key]
        except KeyError:
            raise AttributeError(r"'Dict' object has no attribute '%s'" % key)

    def __setattr__(self, key, value):
        self[key] = value


# default, override 均为字典类型?
def merge(defaults, override):
    r = {}
    for k, v in defaults.items():
        if k in override:
            if isinstance(v, dict):
                r[k] = merge(v, override[k])
            else:
                r[k] = override[k]
        else:
            r[k] = v
    return r


def to_dict(d):
    dic = Dict()
    for k, v in d.items():
        dic[k] = to_dict(v) if isinstance(v, dict) else v
    return dic

configs = config_default.configs
try:
    import config_override
    configs = merge(configs, config_override.configs)
except ImportError:
    pass

# 最后将混合好的配置字典专程自定义字典类型,方便取值与设值
configs = to_dict(configs)
