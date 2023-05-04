# CUE-sandbox

## Introduction

### JSON

```shell
$ cue export json.cue
{
    "one": 1,
    "two": 2,
    "two-and-a-half": 2.5,
    "list": [
        1,
        2,
        3
    ]
}
```

### Duplicate Fields

```shell
$ cue eval dup.cue
a: 4
s: {
    b: 2
    c: 2
}
l: [1, 2]
```

### Constraints

```shell
$ cue eval check.cue
schema: {
    name:  string
    age:   int
    human: true
}
viola: {
    name:  "Viola"
    age:   38
    human: true
}
```

### JSON Superset

```shell
$ cue export json-ss.cue
{
    "one": 1,
    "two": 2,
    "two-and-a-half": 2.5,
    "list": [
        1,
        2,
        3
    ]
}
```

### Definitions

```shell
cue export schema.cue
{
    "lossy": {
        "address": "1.2.3.4",
        "port": 8888,
        "protocol": "udp"
    }
}
```
