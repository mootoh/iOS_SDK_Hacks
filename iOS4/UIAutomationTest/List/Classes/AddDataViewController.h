//
//  AddDataViewController.h
//  List
//
//  Created by sonson on 10/08/26.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddDataViewControllerDelegate <NSObject>
- (BOOL)addNewData:(NSString*)string;
@end

@interface AddDataViewController : UIViewController {
	IBOutlet UITextField *inputField;
	id <AddDataViewControllerDelegate> delegate;
}
@property (nonatomic, assign) id <AddDataViewControllerDelegate> delegate;
@end
