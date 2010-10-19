//
//  UIWebView+respondToSelector.m
//  respondToSelector
//
//  Created by sonson on 09/04/08.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UIWebView+respondToSelector.h"

#if TARGET_IPHONE_SIMULATOR
	#import <objc/objc-runtime.h>
#else
	#import <objc/runtime.h>
#endif

@implementation UIWebView(hack)

- (BOOL)respondsToSelector:(SEL)aSelector {
	NSLog( @"[%s] %@", class_getName([self class]), NSStringFromSelector(aSelector) );
	return [super respondsToSelector:aSelector];
}

@end
