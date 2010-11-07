//
//  AccountSettingsViewController.h
//  iShopping
//
//  Created by Ali Sajjadi on 10/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AccountSettingsViewController : UIViewController <UITableViewDelegate , UITableViewDataSource> {

	NSString *userEmail;
	IBOutlet UITableView *tableView;
	
	IBOutlet UIViewController *editAccountViewController;
	IBOutlet UIViewController *manageNicknamesViewController;
	IBOutlet UIViewController *manualViewController;
	IBOutlet UIViewController *FAQViewController;

	IBOutlet UIButton *changePasswordButton;
	IBOutlet UITextField *currentPassword;
	IBOutlet UITextField *newPassword;
	IBOutlet UITextField *verifyPassword;

}

@property (nonatomic , retain) NSString *userEmail;


-(IBAction) done;

-(IBAction) changePassword;


@end
