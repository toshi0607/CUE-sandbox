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

### Validation

```shell
$ cue vet schema.cue data.yaml
languages.1.name: invalid value "dutch" (out of bound =~"^\\p{Lu}"):
    ./schema.cue:3:8
    ./data.yaml:5:12
```

### Order is irrelevant

```shell
$ cue eval -i order.cue
a: {
    x: 1
    y: 2
}
b: {
    x: 1
    y: 2
}
```

### Folding of Single-Field Structs

```shell
$ cue export fold.cue
{
    "outer": {
        "middle1": {
            "inner": 3
        },
        "middle2": {
            "inner": 7
        }
    }
}
```

### Type Hierarchy

```shell
cue eval types.cue
point: {
    x: number
    y: number
}
xaxis: {
    x: number
    y: 0
}
yaxis: {
    x: 0
    y: number
}
origin: {
    x: 0
    y: 0
}
```

### Bottom / Error

```shell
$ cue eval -i bottom.cue
a: _|_ // a: conflicting values 5 and 4
l: [1, _|_, // l.1: conflicting values 3 and 2
]
list: [0, 1, 2]
val: _|_ // val: index out of range [3] with length 3

$ cue eval bottom.cue
a: conflicting values 5 and 4:
    ./bottom.cue:1:4
    ./bottom.cue:2:4
l.1: conflicting values 3 and 2:
    ./bottom.cue:4:9
    ./bottom.cue:5:9
val: index out of range [3] with length 3:
    ./bottom.cue:8:11

$ cue vet bottom.cue
a: conflicting values 5 and 4:
    ./bottom.cue:1:4
    ./bottom.cue:2:4
l.1: conflicting values 3 and 2:
    ./bottom.cue:4:9
    ./bottom.cue:5:9
val: index out of range [3] with length 3:
    ./bottom.cue:8:11
```

### Numbers

```shell
$ cue eval -i numbers.cue
a: 4
b: 4.0
c: _|_ // c: conflicting values int and 4.0 (mismatched types int and float)
d: 4
e: [1_234, 5M, 1.5Gi, 0x1000_0000]
```

### String Literals

```shell
$ cue export stringlit.cue
{
    "a": "😎",
    "b": "Hello\nWorld!"
}
```

### "Raw" Strings

```shell
msg1: #"The sequence "\U0001F604" renders as \#U0001F604."#

msg2: ##"""
    A regular expression can conveniently be written as:

        #"\d{3}"#

    This construct works for bytes, strings and their
    multi-line variants.
    """##

```

### Bytes

```shell
$ cue export bytes.cue
{
    "a": "A2FiYw=="
}

$ echo "A2FiYw==" | base64 -d
abc%
```

### Closed structs

```shell
cue eval -i structs.cue
a: {
    field: int
}
b: {
    field: int
    feild: _|_ // b.feild: field not allowed
}
```

### Definitions (type)

```shell
$ cue eval -ic defs.cue
msg: "Hello world!"
a: {
    field: 3
}
err: {
    field: int
    feild: _|_ // err.feild: field not allowed
}
```

### Structs

```shell
$ cue eval -c structs.cue
b: {
    foo: 3
}
```

### Disjunctions

```shell
$ cue eval disjunctions.cue
#Conn: {
    address:  string
    port:     int
    protocol: "tcp" | "udp"
}
lossy: {
    address:  "1.2.3.4"
    port:     8888
    protocol: "udp"
}
```

### Default Values

```shell
$ cue eval defaults.cue
replicas: 1
protocol: "tcp" | "udp"
```

### Disjunctions of Structs

```shell
$ cue eval sumstruct.cue 
floor: {
    level:   0 | 1
    hasExit: true
} | {
    level:   -1 | 2 | 3
    hasExit: false
}
```

### Bounds

```shell
$ cue eval -ic bounds.cue
a:  3.5
b:  _|_ // b: conflicting values int and 3.5 (mismatched types int and float)
c:  3
d:  "ma"
e:  _|_ // e: invalid value "mu" (out of bound <"mo")
r1: >=5 & <8
```

### Predefined Bounds

```shell
$ cue eval -ic bound.cue
a: _|_ // a: invalid value -1 (out of bound >=0)
b: 128
c: 2000000000
```

### Lists

```shell
$ cue eval -i lists.cue
IP: [uint8, uint8, uint8, uint8]
PrivateIP: [10, uint8, uint8, uint8] | [192, 168, uint8, uint8] | [172, uint & >=16 & <=32, uint8, uint8]
myIP: [10, 2, 3, 4]
yourIP: _|_ // yourIP: 3 errors in empty disjunction: (and 3 more errors)
```

### Templates

```shell
$ cue eval templates.cue
job: {
    list: {
        name:     "list"
        replicas: 1
        command:  "ls"
    }
    nginx: {
        name:     "nginx"
        command:  "nginx"
        replicas: 2
    }
}
```

### References and Scopes

```shell
$ cue eval scopes.cue
v: 1
a: {
    v: 2
    c: 1
    b: 2
}
b: 1
```

### Accessing Fields

```shell
$ cue eval selectors.cue
a: {
    b:     2
    "c-e": 5
}
v: 2
w: 5
```

### Aliases

```shell
$ cue eval alias.cue
a: {
    d: 3
}
b: {
    a: {
        c: 3
    }
}
```

### Emit Values

```shell
$ cue export emit.cue
"Hello world!"
```

### Reference Cycles

```shell
$ cue eval -i -c cycle.cue
x: 200
y: 100
a: b + 100
b: a - 100
```

### Cycles in Fields

```shell
$ cue eval cycleref.cue
labels: {
    app:  "foo"
    name: "bar"
}
selectors: {
    name: "bar"
    app:  "foo"
}
```

### Hidden Fields

```shell
$ cue export hidden.cue
{
    "_foo": 2,
    "foo": 4
}
```
