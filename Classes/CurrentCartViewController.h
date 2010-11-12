//
//  CurrentCartViewController.h
//  iShopping
//
//  Created by Ali Sajjadi on 10/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartItemViewController.h"
#import "ShoppingItem.h"


@interface CurrentCartViewController : UIViewController <UITableViewDelegate , UITableViewDataSource,
									UISearchBarDelegate , UIActionSheetDelegate, CartItemViewControllerDelegate> {
	
	NSString *userEmail;
	
	NSMutableArray *cartItems;
	IBOutlet UITableView *tableView;
	IBOutlet UIButton *archiveOrAddItemButton;
	IBOutlet UIButton *mapButton;
	

}

@property (nonatomic , retain) NSString *userEmail;
@property (nonatomic, retain) NSMutableArray *cartItems;
@property (nonatomic, retain) UITableView *tableView;


- (IBAction) archiveCartOrAddNewItem;
- (IBAction) showMap;


@end
