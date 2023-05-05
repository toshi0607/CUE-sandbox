import "list"

IP: list.Repeat([ uint8 ], 4)

PrivateIP: IP
PrivateIP: [10, ...uint8] |
    [192, 168, ...] |
    [172, >=16 & <=32, ...]

myIP: PrivateIP
myIP: [10, 2, 3, 4]

yourIP: PrivateIP
yourIP: [11, 1, 2, 3]
