#import <Foundation/Foundation.h>
#if __has_include(<UIKit/UIKit.h>) && !TARGET_OS_WATCH
#import <UIKit/UIKit.h>
#endif

@interface Maintini : NSObject

+ (void)setup;
+ (void)startMaintaining;
+ (void)endMaintaining;

@end
