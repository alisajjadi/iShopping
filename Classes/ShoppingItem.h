//
//  ShoppingItem.h
//  ProjectInterface
//
//  Created by Qiyue Zou on 9/6/10.
//  Copyright 2010 Santa Clara University . All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ShoppingItem : NSObject {
	
	NSString *itemName;
	NSString *itemDescription; 
	UIImage *itemPicture; 
	BOOL cleared;

}

@property (nonatomic, retain) NSString *itemName;
@property (nonatomic, retain) NSString *itemDescription; 
@property (nonatomic, retain) UIImage *itemPicture; 
@property (nonatomic, assign) BOOL cleared;
 



@end
