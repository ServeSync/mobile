//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#import <Foundation/Foundation.h>

NS_INLINE NSException * _Nullable tryBlock(void(^_Nonnull tryBlock)(void)) {
    @try {
        tryBlock();
    }
    @catch (NSException *exception) {
        NSLog(@"tryBlock: %@", exception);
        return exception;
    }
    return nil;
}

NS_INLINE NSException * _Nullable tryCatchBlock(void(^_Nonnull tryBlock)(void), void(^_Nonnull catchBlock)(void)) {
    @try {
        tryBlock();
    }
    @catch (NSException *exception) {
        NSLog(@"tryCatchBlock: %@", exception);
        catchBlock();
    }
    return nil;
}
