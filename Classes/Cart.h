//
//  Cart.h
//  ProjectInterface
//
//  Created by Qiyue Zou on 9/20/10.
//  Copyright 2010 Santa Clara University . All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Cart : NSObject {
	
	NSString *userEmail;
	int userCartID; 
	NSString *createTime; 
	

}

@property (nonatomic, retain) NSString *userEmail; 
@property (nonatomic, assign) int userCartID; 
@property (nonatomic, retain) NSString *createTime; 



@end
