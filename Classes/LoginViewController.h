//
//  LoginViewController.h
//  iShopping
//
//  Created by Ali Sajjadi on 10/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoginViewController : UIViewController < UITextFieldDelegate> {
	NSString *username;
	NSString *password;
	NSString *nickname;
	
	IBOutlet UIButton *signInButton;
	IBOutlet UITextField *signInUsernameTextField;
	IBOutlet UITextField *signInPasswordTextField; 
	
	UIScrollView *signUpScroller;
	IBOutlet UIButton *signUpButton;
	IBOutlet UIView *signUpView;
	IBOutlet UITextField *signUpUsernameTextField;
	IBOutlet UITextField *signUpPasswordTextField; 	
	IBOutlet UITextField *signUpPasswordVerifyTextField; 	
	IBOutlet UITextField *signUpNicknameTextField; 	
	
	IBOutlet UIView *guestView;


}

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password; 
@property (nonatomic, copy) NSString *nickname; 

- (IBAction)verifyAndLogin:(id)sender;
- (IBAction)signUp:(id)sender;
- (IBAction)proceedAsGuest:(id)sender;
- (IBAction)createAnAccount:(id)sender;

- (void) goToAccountPage:(NSString *)userEmail;


@end
