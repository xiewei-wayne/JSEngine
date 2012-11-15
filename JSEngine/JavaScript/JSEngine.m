//
//  JSEngine.m
//  BOCiPadX
//
//  Created by Tracy E on 12-3-26.
//  Copyright (c) 2012年 ChinaMWorld Inc. All rights reserved.
//

#import "JSEngine.h"

#import "JSView.h"

@implementation JSEngine

- (void)dealloc{
    JSGarbageCollect(globalContext_);
    [super dealloc];
}


- (JSGlobalContextRef)GlobalContext{
    if (globalContext_ == NULL) {
        globalContext_ = JSGlobalContextCreate(NULL);
        
        JSObjectRef globalObject = JSContextGetGlobalObject(globalContext_);
        
        //add Window Object
        JSStringRef view = JSStringCreateWithUTF8CString("View");
        JSObjectSetProperty(globalContext_, globalObject, view, JSObjectMakeConstructor(globalContext_, JSView_class(globalContext_), JSView_construct), kJSPropertyAttributeNone, NULL);
        JSStringRelease(view);
        
        [self loadJavaScriptLibrary];
    }
    return globalContext_;
}

- (void)loadJavaScriptLibrary{
    //load ;
    [self execute:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"foundation" ofType:@"js"]  encoding:NSUTF8StringEncoding error:nil]];
    
    //load javascript libraries
    NSString *librariesPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Libraries"];
    NSArray *libraries = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:librariesPath error:nil];
    for (NSString *lib in libraries){
        NSString *libPath = [librariesPath stringByAppendingPathComponent:lib];
        [self execute:[NSString stringWithContentsOfFile:libPath encoding:NSUTF8StringEncoding error:nil]];
    }
}

- (NSString *)execute:(NSString *)script{
//    NSLog(@"script:%@",script);
    if (!script || script.length == 0) {
        return nil;
    }

    JSStringRef scriptJS = JSStringCreateWithUTF8CString([script UTF8String]);
    JSValueRef exception = NULL;
    JSValueRef result = JSEvaluateScript([self GlobalContext], scriptJS, NULL, NULL, 0, &exception);
    
    NSString *res = nil;
    
    if (!result) {
        if (exception) {
            JSStringRef exceptionArg = JSValueToStringCopy([self GlobalContext], exception, NULL);
            NSString* exceptionRes = (NSString*)JSStringCopyCFString(kCFAllocatorDefault, exceptionArg); 
            JSStringRelease(exceptionArg);
            NSLog(@"Exception: %@", exceptionRes);
        }
    }
    else{
        JSStringRef jstrArg = JSValueToStringCopy([self GlobalContext], result, NULL);
        res = (NSString*)JSStringCopyCFString(kCFAllocatorDefault, jstrArg);
        JSStringRelease(jstrArg);
    }
    
    JSStringRelease(scriptJS);
    return [res autorelease];

}

@end
