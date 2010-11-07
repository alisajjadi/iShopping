//
//  TalkToServer.h
//  iShopping
//
//  Created by Ali Sajjadi on 10/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShoppingItem.h"
#import "Cart.h"

#import <sqlite3.h>

typedef enum {
	AccountNotExist = 0,
	LoginVerified,
    PasswordIsWrong
} LoginStatus;

@interface TalkToServer : NSObject {

}

+ (NSMutableArray *) cartItemsForUsername:(NSString *)userEmail andCartId:(int)userCartId;
+ (void) deleteItemFromDatabase:(ShoppingItem *)item forUser:(NSString *)userEmail;
+ (void) addItemToDatabase: (ShoppingItem *)newItem forUser:(NSString *)userEmail;
+ (void) replaceItemInDatabase:(ShoppingItem *)oldItem withItem:(ShoppingItem *)newItem forUser:(NSString *)userEmail;
+ (void) archiveCurrentCartToDatabaseForUser:(NSString *)userEmail;
+ (void) copyItemToCurrentCart:(ShoppingItem *)item forUser:(NSString *)userEmail;
+ (NSMutableArray *) closedCartsForUser:(NSString *)userEmail; 

	
+ (LoginStatus) confirmLogin:(NSString *)username password:(NSString *)password;

@end
