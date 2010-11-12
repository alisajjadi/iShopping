//
//  ClosedCartsViewController.h
//  iShopping
//
//  Created by Ali Sajjadi on 10/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartItemViewController.h"
#import "ShoppingItem.h"
#import <MessageUI/MessageUI.h>


@interface ClosedCartsViewController : UIViewController <UITableViewDelegate , UITableViewDataSource ,
														UIPickerViewDelegate , UIPickerViewDataSource , 
														UIActionSheetDelegate , MFMailComposeViewControllerDelegate,
														CartItemViewControllerDelegate> {

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


@end
