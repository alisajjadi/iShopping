//
//  ShoppingItem.m
//  ProjectInterface
//
//  Created by Qiyue Zou on 9/6/10.
//  Copyright 2010 Santa Clara University . All rights reserved.
//

#import "ShoppingItem.h"


@implementation ShoppingItem

@synthesize itemName;
@synthesize itemDescription; 
@synthesize itemPicture;
@synthesize cleared;


- (void) dealloc {
	[itemName release];
	[itemDescription release]; 
	[itemPicture release];
	[super dealloc]; 
}


@end
