//
//  TalkToServer.m
//  iShopping
//
//  Created by Ali Sajjadi on 10/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TalkToServer.h"


@implementation TalkToServer

#pragma mark Database Methods

+ (NSString *) pathForDatabase 
{	// Copies database from bundle to Documents if it does not exist (First Launch of Application)
	// Returns database file path in Documents 	
	NSFileManager *fileManager = [NSFileManager defaultManager]; 
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentPath = [paths objectAtIndex:0];
	NSString *filePath = [documentPath stringByAppendingPathComponent:@"ShoppingCarts.sqlite"]; 
	
	if (![fileManager fileExistsAtPath:filePath]) {
		NSString *bundlePath = [[[NSBundle mainBundle] resourcePath]
								stringByAppendingPathComponent:@"ShoppingCarts.sqlite"];
		[fileManager copyItemAtPath:bundlePath toPath:filePath error:nil]; 
	}
	
	return filePath; 
	
}


+ (NSMutableArray *) cartItemsForUsername:(NSString *)userEmail andCartId:(int)userCartId {
	
	NSString *filePath = [TalkToServer pathForDatabase];

	sqlite3 *database; 
	NSMutableArray *cartItems = [[NSMutableArray alloc] init]; 
	
	if (sqlite3_open ([filePath UTF8String], &database) == SQLITE_OK) {
		NSString *sqlStatement = [[NSString alloc] initWithFormat:@"select * from ShoppingItems where userEmail = '%@' and cartID = %d", userEmail, userCartId]; 
		// const char *tempSQLStatement = "select * from ShoppingItems";
		sqlite3_stmt *compiledStatement; 
		if (sqlite3_prepare_v2 (database,[sqlStatement UTF8String],-1,&compiledStatement,NULL)==SQLITE_OK) {
			while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
				NSString *itemName = [NSString stringWithUTF8String:(char *) sqlite3_column_text (compiledStatement, 1)];
				NSString *itemDescription = [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement,2)];
				
				
				ShoppingItem *newItem = [[ShoppingItem alloc] init]; 
				newItem.itemName = itemName; 
				newItem.itemDescription = itemDescription; 
				newItem.itemPicture = nil; 
				
				[cartItems addObject:newItem];
				[newItem release];
			}
			
		}
		
		sqlite3_finalize(compiledStatement);
		
		[sqlStatement release]; 
	}
	
	sqlite3_close (database); 
	return [cartItems autorelease];
}


+ (void) deleteItemFromDatabase:(ShoppingItem *)item forUser:(NSString *)userEmail 
{
	NSString *filePath = [TalkToServer pathForDatabase];
	sqlite3 *database; 
	
	if (sqlite3_open([filePath UTF8String], &database) == SQLITE_OK) {
		
		NSString *sqlStatement = [[NSString alloc] initWithFormat:@"delete from ShoppingItems where userEmail = '%@' and itemName = '%@' and cartID = 0 ", userEmail, [item itemName]]; 
		
		sqlite3_stmt *compiledStatement; 
		
		if (sqlite3_prepare_v2 (database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
			if (sqlite3_step(compiledStatement) == SQLITE_DONE)
				sqlite3_finalize(compiledStatement);
		
		[sqlStatement release]; 
	}

	// Delete item from the server database
/*	BOOL isGetResponse=FALSE; 
	NSString *content; 
	
	while (!isGetResponse) { 
		NSString *deleteItemRequestString = [[NSString alloc] initWithFormat : @"userEmail=%@&itemName=%@&cartID=%@",userEmail,[item itemName],@"0"]; 
		NSData *deleteItemRequestData = [ NSData dataWithBytes:[deleteItemRequestString UTF8String] length : [deleteItemRequestString length]];  
		NSMutableURLRequest *request = [ [ NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:@"http://www.qiyuezou.com/phpsessions/deleteShoppingItem.php"]]; 
		[request setHTTPMethod:@"POST"];
		[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
		[request setHTTPBody:deleteItemRequestData];
		NSURLResponse *response;
		NSError *err; 
		NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
		content = [NSString stringWithUTF8String : [returnData bytes]];
		if (content!=nil)
			isGetResponse=TRUE; 
		
	}
	
	if (!isGetResponse) 
	{
		UIAlertView *alertSucceed = [[UIAlertView alloc] initWithTitle:@"Connection Error" 
															   message:@"Error Connecting to Sever! Item will only be deleted locally." 
															  delegate:self 
													 cancelButtonTitle:@"OK" 
													 otherButtonTitles:nil];
		[alertSucceed show];
		[alertSucceed release];	
	} 
*/
}

+ (void) addItemToDatabase: (ShoppingItem *) newItem forUser:(NSString *)userEmail 
{
	
	NSString *filePath = [TalkToServer pathForDatabase];
	sqlite3 *database; 
	
	if (sqlite3_open([filePath UTF8String], &database) == SQLITE_OK) {
		
		const char *sqlStatement = "insert into ShoppingItems (itemName, itemDescription, userEmail, cartID) VALUES (?,?,?,?)";
		sqlite3_stmt *compiledStatement; 
		if (sqlite3_prepare_v2 (database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
		{
			sqlite3_bind_text(compiledStatement, 1, [newItem.itemName UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(compiledStatement, 2, [newItem.itemDescription UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(compiledStatement, 3, [userEmail UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(compiledStatement, 4, "0", -1, SQLITE_TRANSIENT); 
			
		}
		
		if (sqlite3_step(compiledStatement) == SQLITE_DONE) {
			sqlite3_finalize(compiledStatement);
		}
		
	}
	
	sqlite3_close(database); 
	
	// Add item into the server database
/*	BOOL isGetResponse=FALSE; 
	NSString *content; 
	
	while (!isGetResponse) { 
		NSString *addItemRequestString = [[NSString alloc] initWithFormat : @"itemName=%@&itemDescription=%@&userEmail=%@&cartID=%@",newItem.itemName,newItem.itemDescription,userEmail,@"0"]; 
		NSData *addItemRequestData = [ NSData dataWithBytes:[addItemRequestString UTF8String] length : [addItemRequestString length]];  
		NSMutableURLRequest *request = [ [ NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:@"http://www.qiyuezou.com/phpsessions/addShoppingItem.php"]]; 
		[request setHTTPMethod:@"POST"];
		[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
		[request setHTTPBody:addItemRequestData];
		NSURLResponse *response;
		NSError *err; 
		NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
		content = [NSString stringWithUTF8String : [returnData bytes]];
		if (content!=nil)
			isGetResponse=TRUE; 
		
	}
	
	if (!isGetResponse) {
		UIAlertView *alertSucceed = [[UIAlertView alloc] initWithTitle:@"Connection Error" 
															   message:@"Error Connecting to Sever! Item will only be saved locally." 
															  delegate:self 
													 cancelButtonTitle:@"OK" 
													 otherButtonTitles:nil];
		[alertSucceed show];
		[alertSucceed release];	
		
	} 
*/

}	


+ (void) replaceItemInDatabase:(ShoppingItem *)oldItem withItem:(ShoppingItem *)newItem forUser:(NSString *)userEmail 
{
	[TalkToServer deleteItemFromDatabase:oldItem forUser:userEmail];
	[TalkToServer addItemToDatabase:newItem forUser:userEmail];
}


+ (void) archiveCurrentCartToDatabaseForUser:(NSString *)userEmail
{
	NSString *filePath = [TalkToServer pathForDatabase];
	sqlite3 *database; 
	
	if (sqlite3_open([filePath UTF8String], &database) == SQLITE_OK) {
		
		NSString *sqlStatement = [[NSString alloc] initWithFormat:@"update ShoppingItems set cartID = 1 + cartID where userEmail = '%@' ", userEmail];
		sqlite3_stmt *compiledStatement; 
		if (sqlite3_prepare_v2 (database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
			if (sqlite3_step(compiledStatement) == SQLITE_DONE)
				sqlite3_finalize(compiledStatement);
		
		[sqlStatement release]; 
		
		NSString *today = [NSDateFormatter localizedStringFromDate:[NSDate date] 
														 dateStyle:kCFDateFormatterMediumStyle 
														 timeStyle:kCFDateFormatterShortStyle];		
		
		const char *sqlStatement2 = "insert into Carts (userEmail, userCartID, createTime) VALUES (?,?,?)";
		sqlite3_stmt *compiledStatement2; 
		if (sqlite3_prepare_v2 (database, sqlStatement2, -1, &compiledStatement2, NULL) == SQLITE_OK)
		{
			sqlite3_bind_text(compiledStatement2, 1, [userEmail UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(compiledStatement2, 2, "0", -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(compiledStatement2, 3, [today UTF8String], -1, SQLITE_TRANSIENT); 
			if (sqlite3_step(compiledStatement2) == SQLITE_DONE) 
				sqlite3_finalize(compiledStatement2);
			
		}
		
		NSString *sqlStatement3 = [[NSString alloc] initWithFormat:@"update Carts set userCartID = 1 + userCartID where userEmail = '%@' ", userEmail];
		sqlite3_stmt *compiledStatement3; 
		if (sqlite3_prepare_v2 (database, [sqlStatement3 UTF8String], -1, &compiledStatement3, NULL) == SQLITE_OK)
			if (sqlite3_step(compiledStatement3) == SQLITE_DONE)
				sqlite3_finalize(compiledStatement3);
		
		[sqlStatement3 release]; 
		
		// Update the server database 
		
/*		BOOL isGetResponse=FALSE; 
		NSString *content; 
		
		while (!isGetResponse) {
			NSString *updateShoppingCartRequestString = [[NSString alloc] initWithFormat : @"userEmail=%@&userCartID=%@&createTime=%@",userEmail,@"0",[today description]]; 
			NSData *updateShoppingCartRequestData = [ NSData dataWithBytes:[updateShoppingCartRequestString UTF8String] length : [updateShoppingCartRequestString length]];  
			NSMutableURLRequest *request = [ [ NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:@"http://www.qiyuezou.com/phpsessions/archiveCurrentCart.php"]]; 
			[request setHTTPMethod:@"POST"];
			[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
			[request setHTTPBody:updateShoppingCartRequestData];
			NSURLResponse *response;
			NSError *err; 
			NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
			content = [NSString stringWithUTF8String : [returnData bytes]];
			if (content!=nil)
				isGetResponse=TRUE; 
			
		}
		
		if (isGetResponse) {
			
			// NSLog(@"Account Created!");
			
			// AccountCreateViewController * accountCreateDelegate = self; 
			
			UIAlertView *alertSucceed = [[UIAlertView alloc] initWithTitle:@"Archive Current Cart" 
																   message:@"Cart Archived Successfully!" 
																  delegate:self 
														 cancelButtonTitle:@"OK" 
														 otherButtonTitles:nil];
			[alertSucceed show];
			[alertSucceed release];	
			
		} 
	*/	
	}
	
	
	sqlite3_close(database); 
}


+ (void) copyItemToCurrentCart:(ShoppingItem *)item forUser:(NSString *)userEmail
{
	NSString *filePath = [TalkToServer pathForDatabase];
	sqlite3 *database; 
	
	if (sqlite3_open([filePath UTF8String], &database) == SQLITE_OK) {
		
		const char *sqlStatement = "insert into ShoppingItems (itemName, itemDescription, userEmail, cartID) VALUES (?,?,?,?)";
		sqlite3_stmt *compiledStatement; 
		if (sqlite3_prepare_v2 (database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
		{
			sqlite3_bind_text(compiledStatement, 1, [item.itemName UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(compiledStatement, 2, [item.itemDescription UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(compiledStatement, 3, [userEmail UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(compiledStatement, 4, "0", -1, SQLITE_TRANSIENT); 
			
		}
		
		if (sqlite3_step(compiledStatement) == SQLITE_DONE) {
			sqlite3_finalize(compiledStatement);
		}
		
	}
	
	sqlite3_close(database);
	
	// Add item into the server database
	/*
	 BOOL isGetResponse=FALSE; 
	 NSString *content; 
	 
	 while (!isGetResponse) { 
	 NSString *addItemRequestString = [[NSString alloc] initWithFormat : @"itemName=%@&itemDescription=%@&userEmail=%@&cartID=%@",selectedItem.itemName, selectedItem.itemDescription,userEmail,@"0"]; 
	 NSData *addItemRequestData = [ NSData dataWithBytes:[addItemRequestString UTF8String] length : [addItemRequestString length]];  
	 NSMutableURLRequest *request = [ [ NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:@"http://www.qiyuezou.com/phpsessions/copyItem.php"]]; 
	 [request setHTTPMethod:@"POST"];
	 [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
	 [request setHTTPBody:addItemRequestData];
	 NSURLResponse *response;
	 NSError *err; 
	 NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
	 content = [NSString stringWithUTF8String : [returnData bytes]];
	 if (content!=nil)
	 isGetResponse=TRUE; 
	 
	 }
	 
	 if (isGetResponse) {
	 
	 // NSLog(@"Account Created!");
	 
	 // AccountCreateViewController * accountCreateDelegate = self; 
	 
	 UIAlertView *alertSucceed = [[UIAlertView alloc] initWithTitle:@"Copy Item" 
	 message:@"Item Copied Successfully!" 
	 delegate:self 
	 cancelButtonTitle:@"OK" 
	 otherButtonTitles:nil];
	 [alertSucceed show];
	 [alertSucceed release];	
	 
	 } 
	 */
}


+ (NSMutableArray *) closedCartsForUser:(NSString *)userEmail 
{
	NSMutableArray *carts = [[NSMutableArray alloc] init];

	NSString *filePath = [TalkToServer pathForDatabase];
	sqlite3 *database; 
	
	if (sqlite3_open ([filePath UTF8String], &database) == SQLITE_OK) {
		NSString *sqlStatement = [[NSString alloc] initWithFormat:@"select * from Carts where userEmail = '%@' ", userEmail]; 
		sqlite3_stmt *compiledStatement; 
		if (sqlite3_prepare_v2 (database,[sqlStatement UTF8String],-1,&compiledStatement,NULL)==SQLITE_OK) 
			while (sqlite3_step(compiledStatement) == SQLITE_ROW) 
			{
				NSString *userCartID = [NSString stringWithUTF8String:(char *) sqlite3_column_text (compiledStatement, 2)];
				NSString *createTime = [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 3)];
				
				Cart *newItem= [[Cart alloc] init]; 
				newItem.userEmail = userEmail; 
				newItem.userCartID = [userCartID intValue]; 
				newItem.createTime = createTime;  
				
				[carts addObject:newItem];
				[newItem release];			

			}
		
		sqlite3_finalize(compiledStatement);
		[sqlStatement release]; 
	}
	
	sqlite3_close (database); 
	return [carts autorelease];
}




#pragma mark -
#pragma mark Network Communication Methods


+ (LoginStatus) confirmLogin:(NSString *)username password:(NSString *)password 
{
	BOOL isGetResponse=FALSE; 
	NSString *content; 
	
	NSString *loginRequestString = [[NSString alloc] initWithFormat : @"email=%@&password=%@",username,password]; 
	NSData *loginRequestData = [ NSData dataWithBytes:[loginRequestString UTF8String] length : [loginRequestString length]];  
	NSMutableURLRequest *request = [ [ NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:@"http://www.qiyuezou.com/phpsessions/login.php"]]; 
	
	NSURLResponse *response;
	NSError *err;
	
	while (!isGetResponse) {
		
		NSLog(@"username: %@, password: %@", username, password); 
		
		[request setHTTPMethod:@"POST"];
		[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
		[request setHTTPBody:loginRequestData];
		
		NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
		content = [NSString stringWithUTF8String : [returnData bytes]];
		
		if (content!=nil)
			isGetResponse=TRUE; 
	}
	
	[loginRequestString release];
	[request release];
	return [content intValue];
}


#pragma mark -



/*/////////////////////////////// FOR TEST PURPOSE ////////////////////////////////

+ (NSMutableArray *) closedCarts: (NSString *)userEmail
{
	Cart *cart1 = [[Cart alloc] init];
	cart1.userEmail = userEmail; 
	cart1.userCartID = 1; 
	cart1.createTime = @"2010-9-20"; 
	
	Cart *cart2 = [[Cart alloc] init]; 
	cart2.userEmail = userEmail;
	cart2.userCartID = 2; 
	cart2.createTime = @"2010-9-20"; 
	
	Cart *cart3 = [[Cart alloc] init]; 
	cart3.userEmail = userEmail;
	cart3.userCartID = 3; 
	cart3.createTime = @"2010-9-20"; 
	
	
	NSMutableArray *carts = [[NSMutableArray alloc] initWithObjects:cart1, cart2, cart3, nil]; 
	
	[cart1 release]; 
	[cart2 release]; 
	[cart3 release]; 
	
	return [carts autorelease];
}


+ (NSMutableArray *) cartItemsForUsername:(NSString *)userEmail andCartId:(int)userCartId
{
	ShoppingItem *item1 = [[ShoppingItem alloc] init];
	ShoppingItem *item2 = [[ShoppingItem alloc] init]; 
	ShoppingItem *item3 = [[ShoppingItem alloc] init];
	ShoppingItem *item4 = [[ShoppingItem alloc] init];
	ShoppingItem *item5 = [[ShoppingItem alloc] init];
	ShoppingItem *item6 = [[ShoppingItem alloc] init];
	
	NSMutableArray *cartItems;
	
	if (userCartId == 0){
		item1.itemName = @"0Apple";
		item1.itemDescription = @"0Best fruit for every day!";
		item1.itemPicture=[UIImage imageNamed:@"Apple.jpg"]; 
		
		item2.itemName = @"0Milk"; 
		item2.itemDescription = @"0For breakfast";
		item2.itemPicture=[UIImage imageNamed:@"Milk.jpg"];
		
		item3.itemName = @"0Bread";
		item3.itemDescription = @"0The best bread in the world!";
		item3.itemPicture = [UIImage imageNamed:@"Bread.jpg"]; 
		
		item4.itemName = @"0Butter";
		item4.itemDescription = @"0European butter, salted!";
		item4.itemPicture = [UIImage imageNamed:@"Bread.jpg"]; 
		
		item5.itemName = @"0Orange";
		item5.itemDescription = @"Navel Orange";
		item5.itemPicture = [UIImage imageNamed:@"Bread.jpg"]; 
		
		item6.itemName = @"0Beer";
		item6.itemDescription = @"Let's party!";
		item6.itemPicture = [UIImage imageNamed:@"Bread.jpg"]; 
		
		cartItems = [[NSMutableArray alloc] initWithObjects:item1, item2, item3,item4,item5,item6,nil];
		
	}
	
 
 
	if (userCartId ==1){
		item1.itemName = @"Apple";
		item1.itemDescription = @"Best fruit for every day!";
		item1.itemPicture=[UIImage imageNamed:@"Apple.jpg"]; 
		
		item2.itemName = @"Milk"; 
		item2.itemDescription = @"For breakfast";
		item2.itemPicture=[UIImage imageNamed:@"Milk.jpg"];
		
		item3.itemName = @"Bread";
		item3.itemDescription = @"The best bread in the world!";
		item3.itemPicture = [UIImage imageNamed:@"Bread.jpg"]; 
		
		item4.itemName = @"Butter";
		item4.itemDescription = @"European butter, salted!";
		item4.itemPicture = [UIImage imageNamed:@"Bread.jpg"]; 
		
		item5.itemName = @"Orange";
		item5.itemDescription = @"Navel Orange";
		item5.itemPicture = [UIImage imageNamed:@"Bread.jpg"]; 
		
		item6.itemName = @"Beer";
		item6.itemDescription = @"Let's party!";
		item6.itemPicture = [UIImage imageNamed:@"Bread.jpg"]; 
		
		cartItems = [[NSMutableArray alloc] initWithObjects:item1, item2, item3,item4,item5,item6,nil];
		
	}
	
	if (userCartId ==2){
		item1.itemName = @"2222";
		item1.itemDescription = @"22Best fruit for every day!";
		item1.itemPicture=[UIImage imageNamed:@"Apple.jpg"]; 
		
		item2.itemName = @"Milk"; 
		item2.itemDescription = @"For breakfast";
		item2.itemPicture=[UIImage imageNamed:@"Milk.jpg"];
		
		item4.itemName = @"Bread4";
		item4.itemDescription = @"4The best bread in the world!";
		item4.itemPicture = [UIImage imageNamed:@"Bread.jpg"]; 
		
		item5.itemName = @"Bread5";
		item5.itemDescription = @"5The best bread in the world!";
		item5.itemPicture = [UIImage imageNamed:@"Bread.jpg"]; 
		
		item6.itemName = @"Bread6";
		item6.itemDescription = @"6The best bread in the world!";
		item6.itemPicture = [UIImage imageNamed:@"Bread.jpg"];
		
		cartItems = [[NSMutableArray alloc] initWithObjects:item1, item2,item4,item5,item6,nil];
		
	}
	
	if (userCartId ==3){
		item1.itemName = @"Apple";
		item1.itemDescription = @"Best fruit for every day!";
		item1.itemPicture=[UIImage imageNamed:@"Apple.jpg"]; 
		
		
		item6.itemName = @"Bread6";
		item6.itemDescription = @"6The best bread in the world!";
		item6.itemPicture = [UIImage imageNamed:@"Bread.jpg"]; 
		
		cartItems = [[NSMutableArray alloc] initWithObjects:item1, item6,nil];
		
	}
	
	
	
	[item1 release];
	[item2 release];
	[item3 release]; 
	[item4 release];
	[item5 release];
	[item6 release];	
	
	return [cartItems autorelease];
	
}

*/
/////////////////////////////////////////////////////////////////////////////////
@end
