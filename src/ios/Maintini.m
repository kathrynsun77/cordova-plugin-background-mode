#import "Maintini.h"

@implementation Maintini

static NSInteger activityCount = 0;
static id<NSObject> foregroundObserver;
static id<NSObject> backgroundObserver;
static BOOL appInBackground = NO;
static id bgTask;
static dispatch_source_t debounceTimer;
static BOOL debounceActive = NO;

+ (void)setup {
#if __has_include(<UIKit/UIKit.h>) && !TARGET_OS_WATCH
    if (!foregroundObserver) {
        foregroundObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification
                                                                               object:nil
                                                                                queue:[NSOperationQueue mainQueue]
                                                                           usingBlock:^(NSNotification * _Nonnull note) {
            [self unPush];
            appInBackground = NO;
            [self endTask];
        }];
    }
    
    if (!backgroundObserver) {
        backgroundObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification
                                                                               object:nil
                                                                                queue:[NSOperationQueue mainQueue]
                                                                           usingBlock:^(NSNotification * _Nonnull note) {
            [self appBackgrounded];
        }];
    }
#endif
}

+ (void)maintainWithBlock:(void (^)(void))block {
    [self startMaintaining];
    block();
    [self endMaintaining];
}

+ (void)startMaintaining {
#if !TARGET_OS_WATCH
    [self unPush];
    NSInteger count = activityCount;
    activityCount = count + 1;
    if (count == 0 && !bgTask) {
#if TARGET_OS_OSX
        NSProcessInfo *processInfo = [NSProcessInfo processInfo];
        bgTask = [processInfo beginActivityWithOptions:NSActivityUserInitiated reason:@"Maintini"];
#elif TARGET_OS_IOS
        if (appInBackground) {
            [self appBackgrounded];
        }
#endif
    }
#endif
}

+ (void)endMaintaining {
#if !TARGET_OS_WATCH
    activityCount--;
    if (activityCount == 0 && bgTask) {
        [self push];
    }
#endif
}

#if !TARGET_OS_WATCH

+ (void)endTask {
    if (bgTask) {
        [self unPush];
#if TARGET_OS_OSX
        [[NSProcessInfo processInfo] endActivity:bgTask];
#elif TARGET_OS_IOS
        [[UIApplication sharedApplication] endBackgroundTask:(UIBackgroundTaskIdentifier)bgTask];
#endif
        bgTask = nil;
    }
}

+ (void)push {
    if (!debounceActive) {
        debounceActive = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            debounceActive = NO;
            [self endTask];
        });
    }
}

+ (void)unPush {
    if (debounceActive) {
        debounceActive = NO;
    }
}

#if TARGET_OS_IOS

+ (void)appBackgrounded {
    appInBackground = YES;
    if (activityCount != 0 && !bgTask) {
        bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            [self endTask];
        }];
    }
}

#endif

#endif

@end
