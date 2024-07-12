#import <Cordova/CDV.h>

@interface APPBackgroundMode : CDVPlugin

// Method to set up the background mode
- (void)setup:(CDVInvokedUrlCommand*)command;

// Method to start maintaining the background mode
- (void)startMaintaining:(CDVInvokedUrlCommand*)command;

// Method to end maintaining the background mode
- (void)endMaintaining:(CDVInvokedUrlCommand*)command;

// Method to maintain with a block
- (void)maintainWithBlock:(CDVInvokedUrlCommand*)command;

@end
