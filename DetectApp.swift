func detectJailbreakApps() -> [String] {
    let bundleIdentifiers = [
        "com.opa334.TrollStore",
        "org.coolstar.SileoStore",
        "xyz.willy.Zebra",
        "com.opa334.Dopamine",
        "com.opa334.Dopamine-roothide"
        //Add more apps bundle id
    ]
    
    let handle = dlopen("/System/Library/PrivateFrameworks/SpringBoardServices.framework/SpringBoardServices", RTLD_LAZY)
    guard let sym = dlsym(handle, "SBSLaunchApplicationWithIdentifier") else {
        dlclose(handle)
        return []
    }
    
    typealias SBSLaunchApplicationWithIdentifierFunc = @convention(c) (NSString, Bool) -> Int
    let launchApp = unsafeBitCast(sym, to: SBSLaunchApplicationWithIdentifierFunc.self)
    
    var detectedApps: [String] = []
    
    for bundleIdentifier in bundleIdentifiers {
        let errorCode = launchApp(bundleIdentifier as NSString, false)
        if errorCode == 9 {
            detectedApps.append(bundleIdentifier)
        }
    }
    
    dlclose(handle)
    
    return detectedApps
}
