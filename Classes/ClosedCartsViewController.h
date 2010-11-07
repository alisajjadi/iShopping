//
//  ClosedCartsViewController.h
//  iShopping
//
//  Created by Ali Sajjadi on 10/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingItem.h"


@interface ClosedCartsViewController : UIViewController <UITableViewDelegate , UITableViewDataSource , UIPickerViewDelegate , UIPickerViewDataSource , UIActionSheetDelegate> {

	NSString *userEmail;
	NSMutableArray *carts;
	NSMutableArray *cartItems;
	NSMutableArray *copyFlags;
	
	IBOutlet UIPickerView *picker;
	IBOutlet UITableView *tableView;
	
}


@property (nonatomic , retain) NSString *userEmail;
@property (nonatomic , retain) 	NSMutableArray *carts;
@property (nonatomic , retain) 	UIPickerView *picker;

- (void)returnFromModalViewWithItem:(ShoppingItem *) item;

@end
