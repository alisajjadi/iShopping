//
//  EmailCartsViewController.h
//  iShopping
//
//  Created by Ali Sajjadi on 10/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EmailCartsViewController : UIViewController <UITextFieldDelegate , UITableViewDelegate , UITableViewDataSource , UIActionSheetDelegate> {
	
	NSString *userEmail;
	NSMutableArray *carts;
	
	IBOutlet UIButton *emailButton;
	IBOutlet UITextField *fromTextField;
	IBOutlet UITextField *toTextField;
	IBOutlet UITableView *tableView;


}


@property (nonatomic , retain) NSString *userEmail;
@property (nonatomic , retain) 	NSMutableArray *carts;
@property (nonatomic , retain) 	UITableView *tableView;

- (IBAction) sendEmail;

@end
