//
//  UICWebView+HookTouch.h
//  WebView
//
//  Created by sonson on 09/11/24.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UICWebView.h"

@interface UICWebView(HookTouch)
+ (void)installTouchEventHook;
@end
