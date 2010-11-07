//
//  CurrentCartViewController.h
//  iShopping
//
//  Created by Ali Sajjadi on 10/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingItem.h"


@interface CurrentCartViewController : UIViewController <UITableViewDelegate , UITableViewDataSource , UISearchBarDelegate , UIActionSheetDelegate> {
	
	NSString *userEmail;
	
	NSMutableArray *cartItems;
	IBOutlet UIButton *deleteButton;
	IBOutlet UIButton *archiveButton;
	IBOutlet UITableView *tableView;
	

}

@property (nonatomic , retain) NSString *userEmail;
@property (nonatomic, retain) NSMutableArray *cartItems;
@property (nonatomic, retain) UITableView *tableView;


- (IBAction) archiveCart;
- (IBAction) deleteCart;

- (void)returnFromModalViewWithItem:(ShoppingItem *) item;


@end
