//
//  UICWebView+HookTouch.m
//  WebView
//
//  Created by sonson on 09/11/24.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UICWebView+HookTouch.h"

#if TARGET_IPHONE_SIMULATOR
	#import <objc/objc-runtime.h>
#else
	#import <objc/runtime.h>
#endif

const char* kUIWebDocumentView= "UIWebDocumentView";
static BOOL isAlreadyHookTouchInstalled = NO;

#pragma mark -
#pragma mark UIView (private)

@interface UICWebView (private)
- (void)hookedTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)hookedTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)hookedTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)hookedTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
@end

@interface NSObject (UICWebViewDelegate)
- (void)touchesBegan:(NSSet*)touches inWebView:(UIWebView*)sender withEvent:(UIEvent*)event;
- (void)touchesMoved:(NSSet*)touches inWebView:(UIWebView*)sender withEvent:(UIEvent*)event;
- (void)touchesEnded:(NSSet*)touches inWebView:(UIWebView*)sender withEvent:(UIEvent*)event;
- (void)touchesCancelled:(NSSet*)touches inWebView:(UIWebView*)sender withEvent:(UIEvent*)event;
@end

#pragma mark -
#pragma mark UIView (__TapHook)

@implementation UIView (__TapHook)

- (void)__replacedTouchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
	if( [self respondsToSelector:@selector(__replacedTouchesBegan:withEvent:)] )
		[self __replacedTouchesBegan:touches withEvent:event];		// call @selector(touchesBegan:withEvent:)
	if( [self.superview.superview isMemberOfClass:[UICWebView class]] ) {
		[(UICWebView*)self.superview.superview hookedTouchesBegan:touches withEvent:event];
	}
}
- (void)__replacedTouchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
	if( [self respondsToSelector:@selector(__replacedTouchesEnded:withEvent:)] )
		[self __replacedTouchesMoved:touches withEvent:event];		// call @selector(touchesMoved:withEvent:)
	if( [self.superview.superview isMemberOfClass:[UICWebView class]] ) {
		[(UICWebView*)self.superview.superview hookedTouchesMoved:touches withEvent:event];
	}
}

- (void)__replacedTouchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
	if( [self respondsToSelector:@selector(__replacedTouchesEnded:withEvent:)] )
		[self __replacedTouchesEnded:touches withEvent:event];		// call @selector(touchesEnded:withEvent:)
	if( [self.superview.superview isMemberOfClass:[UICWebView class]] ) {
		[(UICWebView*)self.superview.superview hookedTouchesEnded:touches withEvent:event];
	}
}

- (void)__replacedTouchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event {
	if( [self respondsToSelector:@selector(__replacedTouchesCancelled:withEvent:)] )
		[self __replacedTouchesCancelled:touches withEvent:event];	// call @selector(touchesCancelled:withEvent:)
	if( [self.superview.superview isMemberOfClass:[UICWebView class]] ) {
		[(UICWebView*)self.superview.superview hookedTouchesCancelled:touches withEvent:event];
	}
}

@end

@implementation UICWebView(HookTouch)

+ (void)installTouchEventHook {
	Class classObject = objc_getClass(kUIWebDocumentView);
	
	if(classObject == nil)
		return;		// if there is no UIWebDocumentView in the future.
	
	if(isAlreadyHookTouchInstalled)
		return;
	isAlreadyHookTouchInstalled = YES;
	
	// replace touch began event
	method_exchangeImplementations(
								   class_getInstanceMethod(classObject, @selector(touchesBegan:withEvent:)), 
								   class_getInstanceMethod(classObject, @selector(__replacedTouchesBegan:withEvent:)) );
	
	// replace touch moved event
	method_exchangeImplementations(
								   class_getInstanceMethod(classObject, @selector(touchesMoved:withEvent:)), 
								   class_getInstanceMethod(classObject, @selector(__replacedTouchesMoved:withEvent:))
								   );
	
	// replace touch ended event
	method_exchangeImplementations(
								   class_getInstanceMethod(classObject, @selector(touchesEnded:withEvent:)), 
								   class_getInstanceMethod(classObject, @selector(__replacedTouchesEnded:withEvent:))
								   );
	
	// replace touch cancelled event
	method_exchangeImplementations(
								   class_getInstanceMethod(classObject, @selector(touchesCancelled:withEvent:)), 
								   class_getInstanceMethod(classObject, @selector(__replacedTouchesCancelled:withEvent:))
								   );
}

#pragma mark -
#pragma mark Original method for call delegate method

- (void)hookedTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if( [self.delegate respondsToSelector:@selector(touchesBegan:inWebView:withEvent:)] )
		[(NSObject*)self.delegate touchesBegan:touches inWebView:self withEvent:event];
}

- (void)hookedTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if( [self.delegate respondsToSelector:@selector(touchesMoved:inWebView:withEvent:)] )
		[(NSObject*)self.delegate touchesMoved:touches inWebView:self withEvent:event];
}

- (void)hookedTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if( [self.delegate respondsToSelector:@selector(touchesEnded:inWebView:withEvent:)] )
		[(NSObject*)self.delegate touchesEnded:touches inWebView:self withEvent:event];
}

- (void)hookedTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	if( [self.delegate respondsToSelector:@selector(touchesCancelled:inWebView:withEvent:)] )
		[(NSObject*)self.delegate touchesCancelled:touches inWebView:self withEvent:event];
}

@end
