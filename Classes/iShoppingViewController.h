//
//  iShoppingViewController.h
//  iShopping
//
//  Created by Ali Sajjadi on 10/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iShoppingViewController : UIViewController <UITableViewDelegate , UITableViewDataSource> {
	
	IBOutlet UITableView *tableView;

}

@end

