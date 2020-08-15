// Objective-C with automatic reference counting
// clang -O3 -objective-c -framework Foundation -fobjc-arc -o main.a main-ARC.m
// time: 4.344 (2.8 GHz Quad-Core Intel Core i7)

#include <Foundation/Foundation.h>

@interface Node: NSObject
    @property (nonatomic) int x;
    @property (nonatomic) int y;
    @property (nonatomic, strong) Node* left;
    @property (nonatomic, strong) Node* right;

- (instancetype)initWithX:(int)x;

@end

Node* root;

@implementation Node

- (instancetype)initWithX:(int)x {
    self = [super init];
    self.x = x;
    self.y = rand();
    return self;
}

+ (Node*)merge:(Node*)lower greater:(Node*)greater {
    if (!lower)
        return greater;

    if (!greater)
        return lower;

    if (lower.y < greater.y) {
        lower.right = [Node merge:lower.right greater:greater];
        return lower;
    }
    else {
        greater.left = [Node merge:lower greater:greater.left];
        return greater;
    }
}

+ (Node*)merge:(Node*)lower equal:(Node*)equal greater:(Node*)greater {
    return [Node merge:[Node merge:lower greater:equal] greater:greater];
}

+ (void)split:(Node*)orig val:(int)val lower:(Node**)lower higher:(Node**)higher {
    if (!orig) {
        *lower = *higher = nil;
        return;
    }

    if (orig.x < val) {
        *lower = orig;
        Node* right = (*lower).right;
        [Node split:(*lower).right val:val lower:&right higher:higher];
        (*lower).right = right;
    }
    else {
        *higher = orig;
        Node* left = (*higher).left;
        [Node split:(*higher).left val:val lower:lower higher:&left];
        (*higher).left = left;
    }
}

+ (void)split:(Node*)orig val:(int)val lower:(Node**)lower equal:(Node**)equal greater:(Node**)greater {
    Node* higher;
    [Node split:orig val:val lower:lower higher:&higher];
    [Node split:higher val:val + 1 lower:equal higher:greater];
}


+ (int)hasValue:(int)x {
    Node* lower;
    Node* equal;
    Node* greater;
    
    [Node split:root val:x lower:&lower equal:&equal greater:&greater];
    int res = equal != nil;
    root = [Node merge:lower equal:equal greater:greater];
    return res;
}

+ (void)insert:(int)x {
    Node* lower;
    Node* equal;
    Node* greater;
    
    [Node split:root val:x lower:&lower equal:&equal greater:&greater];
    
    if (!equal) {
        equal = [[Node alloc] initWithX:x];
    }

    root = [Node merge:lower equal:equal greater:greater];
}

+ (void)erase:(int)x {
    Node* lower;
    Node* equal;
    Node* greater;
    
    [Node split:root val:x lower:&lower equal:&equal greater:&greater];
    root = [Node merge:lower greater:greater];
}

@end

int main() {
    srand(time(0));

    int cur = 5;
    int res = 0;

    for (int i = 1; i < 1000000; i++) {
        int mode = i % 3;
        cur = (cur * 57 + 43) % 10007;
        if (mode == 0) {
            [Node insert:cur];
        }
        else if (mode == 1) {
            [Node erase:cur];
        }
        else if (mode == 2) {
            res += [Node hasValue:cur];
        }
    }
    printf("%d\n", res);
    return 0;
}
