#import "JailbreakDetector.h"
#include <dlfcn.h>

NSArray<NSString *> *detectJailbreakApps(void) {
    NSArray *bundleIdentifiers = @[
        @"com.opa334.TrollStore",
        @"org.coolstar.SileoStore",
        @"xyz.willy.Zebra",
        @"com.opa334.Dopamine",
        @"com.opa334.Dopamine-roothide"
    ];

    void *handle = dlopen("/System/Library/PrivateFrameworks/SpringBoardServices.framework/SpringBoardServices", RTLD_LAZY);
    if (!handle) {
        return @[];
    }

    void *sym = dlsym(handle, "SBSLaunchApplicationWithIdentifier");
    if (!sym) {
        dlclose(handle);
        return @[];
    }

    typedef int (*SBSLaunchApplicationWithIdentifierFunc)(NSString *, BOOL);
    SBSLaunchApplicationWithIdentifierFunc launchApp = (SBSLaunchApplicationWithIdentifierFunc)sym;

    NSMutableArray *detectedApps = [NSMutableArray array];

    for (NSString *bundleIdentifier in bundleIdentifiers) {
        int errorCode = launchApp(bundleIdentifier, NO);
        if (errorCode == 9) {
            [detectedApps addObject:bundleIdentifier];
        }
    }

    dlclose(handle);
    
    return detectedApps;
}
/*
NSArray<NSString *> *jailbreakApps = detectJailbreakApps();
NSLog(@"Detected Jailbreak Apps: %@", jailbreakApps);
*/
