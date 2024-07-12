#import "APPBackgroundMode.h"
#import "Maintini.h"
#import <Cordova/CDV.h>

@implementation APPBackgroundMode

- (void)setup:(CDVInvokedUrlCommand*)command {
    [Maintini setup];
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)startMaintaining:(CDVInvokedUrlCommand*)command {
    [Maintini startMaintaining];
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)endMaintaining:(CDVInvokedUrlCommand*)command {
    [Maintini endMaintaining];
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

@end
