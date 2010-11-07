//
//  Cart.m
//  ProjectInterface
//
//  Created by Qiyue Zou on 9/20/10.
//  Copyright 2010 Santa Clara University . All rights reserved.
//

#import "Cart.h"


@implementation Cart

@synthesize userEmail; 
@synthesize userCartID; 
@synthesize createTime; 


- (void) dealloc {
	
	[userEmail release];
	[createTime release]; 
	
	[super dealloc]; 
}

@end
