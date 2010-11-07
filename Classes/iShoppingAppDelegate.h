//
//  iShoppingAppDelegate.h
//  iShopping
//
//  Created by Ali Sajjadi on 10/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iShoppingViewController;

@interface iShoppingAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UINavigationController *navController;

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

