# Objective-C with manual and automatic reference counting

Author: Mike Kluev

## Compile

Manual:

```
clang -O3 -objective-c -framework Foundation -o main.a main-MRC.m
```

Automatic:

```
clang -O3 -objective-c -framework Foundation -fobjc-arc -o main.a main-ARC.m
```


## Execute

```
./main.a
```
