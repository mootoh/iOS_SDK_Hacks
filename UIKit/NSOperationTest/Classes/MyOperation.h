//
//  MyOperation.h
//  NSOperationTest
//
//  Created by sonson on 10/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MyOperation : NSOperation {
	id delegate;
}
- (id)initWithDelegate:(id)aDelegate;
@end
