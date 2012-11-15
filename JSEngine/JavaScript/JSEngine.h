//
//  JSEngine.h
//  BOCiPadX
//
//  Created by Tracy E on 12-3-26.
//  Copyright (c) 2012年 ChinaMWorld Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface JSEngine : NSObject{
    JSGlobalContextRef globalContext_;
}
- (JSGlobalContextRef)GlobalContext;
- (NSString *)execute:(NSString *)script;
@end
