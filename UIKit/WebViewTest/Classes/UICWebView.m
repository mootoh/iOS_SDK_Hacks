//
//  UICWebView.m
//  WebView
//
//  Created by sonson on 09/11/24.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UICWebView.h"

#if TARGET_IPHONE_SIMULATOR
	#import <objc/objc-runtime.h>
#else
	#import <objc/runtime.h>
#endif

const char* kUIWebViewWebViewDelegate = "UIWebViewWebViewDelegate";
static BOOL isAlreadyNewWindowHookInstalled = NO;

@implementation UICWebView

// method to be added into UIWebViewWebViewDelegate
static id webViewcreateWebViewWithRequestIMP(id self, SEL _cmd, id sender, id request) {
	return [sender retain];
}

+ (void)installNewWindowDelegateHook {
	if (isAlreadyNewWindowHookInstalled)
		return;
	isAlreadyNewWindowHookInstalled = YES;
	Class classObject = objc_getClass(kUIWebViewWebViewDelegate);
	if (classObject == nil)
		return;		// unfortunately, UIWebViewWebViewDelegate has gone...
	class_addMethod(classObject, @selector(webView:createWebViewWithRequest:), (IMP)webViewcreateWebViewWithRequestIMP, "@@:@@");
}

@end
