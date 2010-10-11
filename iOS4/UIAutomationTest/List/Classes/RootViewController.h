//
//  RootViewController.h
//  List
//
//  Created by sonson on 10/08/26.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddDataViewController.h"

@interface RootViewController : UITableViewController <AddDataViewControllerDelegate> {
	NSMutableArray *array;
}
@end
