//
//  JSView.h
//  JSEngine
//
//  Created by Tracy E on 12-11-15.
//  Copyright (c) 2012年 Tracy E. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

extern JSObjectRef JSView_new(JSContextRef ctx, UIView *view);

extern JSClassRef JSView_class(JSContextRef ctx);

extern JSObjectRef JSView_construct(JSContextRef ctx, JSObjectRef obj, size_t argumentCount, const JSValueRef arguments[], JSValueRef* exception);

