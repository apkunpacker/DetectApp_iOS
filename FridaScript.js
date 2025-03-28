Interceptor.attach(Module.findExportByName(null, "dlsym"),{
    onEnter: function(args){
        this.symbol = args[1].readCString();
    },
    onLeave: function(retval){
        if(this.symbol == "SBSLaunchApplicationWithIdentifier"){
            console.log("Unauthorized iOS private API call Detected. Skipping...");
            retval.replace(ptr(0));
        }
    }
})
