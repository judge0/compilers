#import <Foundation/Foundation.h>

int main() {
    @autoreleasepool {
        char name[10];
        scanf("%s", name);
        NSString *message = [NSString stringWithFormat:@"hello, %s\n", name];
        printf("%s", message.UTF8String);
    }
    return 0;
}