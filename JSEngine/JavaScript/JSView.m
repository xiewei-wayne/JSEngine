//
//  JSView.m
//  JSEngine
//
//  Created by Tracy E on 12-11-15.
//  Copyright (c) 2012年 Tracy E. All rights reserved.
//

#import "JSView.h"
#import "ESAppDelegate.h"

static JSValueRef JSView_getProperty(JSContextRef ctx, JSObjectRef object, JSStringRef propertyName, JSValueRef* exception){
    if (JSStringIsEqualToUTF8CString(propertyName, "backgroundColor")) {
        //......
    }
    return JSValueMakeUndefined(ctx);
}

static bool JSView_setProperty(JSContextRef ctx, JSObjectRef object, JSStringRef propertyName, JSValueRef value, JSValueRef* exception){
    UIView *view = JSObjectGetPrivate(object);
    if (JSStringIsEqualToUTF8CString(propertyName, "backgroundColor")) {
        JSStringRef stringRef = JSValueToStringCopy(ctx, value, NULL);
        NSString *string = [(NSString *)JSStringCopyCFString(kCFAllocatorSystemDefault, stringRef) autorelease];
        
        string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
        string = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSArray *rgb = [string componentsSeparatedByString:@","];
        view.backgroundColor = [UIColor colorWithRed:[[rgb objectAtIndex:0] floatValue] / 255.0
                                               green:[[rgb objectAtIndex:1] floatValue] / 255.0
                                                blue:[[rgb objectAtIndex:2] floatValue] / 255.0
                                               alpha:1];
        JSStringRelease(stringRef);
    }
    return true;
}


static JSValueRef JSView_setFrame(JSContextRef ctx, JSObjectRef function, JSObjectRef thisObject, size_t argumentCount, const JSValueRef arguments[], JSValueRef* exception){
    UIView *view = JSObjectGetPrivate(thisObject);
    view.frame = CGRectMake(JSValueToNumber(ctx, arguments[0], NULL),
                            JSValueToNumber(ctx, arguments[1], NULL),
                            JSValueToNumber(ctx, arguments[2], NULL),
                            JSValueToNumber(ctx, arguments[3], NULL));
    return JSValueMakeUndefined(ctx);
 }

static JSValueRef JSView_addToWindow(JSContextRef ctx, JSObjectRef function, JSObjectRef thisObject, size_t argumentCount, const JSValueRef arguments[], JSValueRef* exception){
    ESAppDelegate *appDelegate = (ESAppDelegate *)[[UIApplication sharedApplication] delegate];
    UIView *view = JSObjectGetPrivate(thisObject);
    [appDelegate.window addSubview:view];
    return JSValueMakeUndefined(ctx);
}

static JSStaticValue JSView_staticValues[] = {
    {"backgroundColor",NULL, JSView_setProperty, kJSPropertyAttributeDontDelete},
    {0, 0, 0}
};

static JSStaticFunction JSView_staticFunctions[] = {
    {"setFrame", JSView_setFrame, kJSPropertyAttributeDontDelete},
    {"addToWindow",JSView_addToWindow, kJSPropertyAttributeDontDelete},
    {0, 0, 0}
};

static void JSView_initialize(JSContextRef ctx, JSObjectRef object){
}

static void JSView_finalize(JSObjectRef object){
    UIView *view = JSObjectGetPrivate(object);
    [view release];
}

JSObjectRef JSView_construct(JSContextRef ctx, JSObjectRef obj, size_t argumentCount, const JSValueRef arguments[], JSValueRef* exception){
    return JSView_new(ctx, [[UIView alloc] init]);
}

JSObjectRef JSView_new(JSContextRef ctx, UIView *view){
    return JSObjectMake(ctx, JSView_class(ctx), view);
}

JSClassRef JSView_class(JSContextRef context){
    static JSClassRef jsClass;
    if (!jsClass) {
        JSClassDefinition definition = kJSClassDefinitionEmpty;
        definition.staticValues = JSView_staticValues;
        definition.staticFunctions = JSView_staticFunctions;
        definition.initialize = JSView_initialize;
        definition.finalize = JSView_finalize;
        
        jsClass = JSClassCreate(&definition);
    }
    return jsClass;
}
