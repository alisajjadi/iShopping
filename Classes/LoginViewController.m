//
//  LoginViewController.m
//  iShopping
//
//  Created by Ali Sajjadi on 10/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "TalkToServer.h"
#import "CurrentCartViewController.h"
#import "ClosedCartsViewController.h"
#import "AccountSettingsViewController.h"

@implementation LoginViewController

@synthesize username;
@synthesize password;
@synthesize nickname;


#pragma mark -
#pragma mark UITextFieldDelegate
/*

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	// the user pressed the "Done" button, so dismiss the keyboard
	[textField resignFirstResponder];
	return YES;
}

*/	
#pragma mark -
	
		
- (void)verifyAndLogin:(id)sender 
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	signInButton.enabled = NO;
	
	[NSThread detachNewThreadSelector:@selector(verifyAndLoginBackgroundThread) toTarget:self withObject:nil];
}

- (void)verifyAndLoginBackgroundThread
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	[NSThread sleepForTimeInterval:2];
	self.username=signInUsernameTextField.text;  
	self.password=signInPasswordTextField.text; 
	NSNumber *status = [NSNumber numberWithInt:[TalkToServer confirmLogin:username password:password]];
	
	[self performSelectorOnMainThread:@selector(verifyAndLoginFinished:) withObject:status waitUntilDone:NO];
	[pool release];
}
	
- (void)verifyAndLoginFinished:(NSNumber *)status
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

	NSString *message = nil;
	switch ([status intValue]) {
		case AccountNotExist:{
			message = @"Account does not exist!";
			break;
		}
		case LoginVerified:
		{
			NSLog(@"Username-Password Verified");
			[self goToAccountPage:self.username];
			break;
		}
		case PasswordIsWrong:{
			message = @"Password is wrong!" ;
			break;
		}
		default:{
			message = @"Unknown Error!";
			break;
		}
	}	
	if ([status intValue] != LoginVerified) {
		UIAlertView *alertNoAccount = [[UIAlertView alloc] initWithTitle:@"Login Problem" 
															message:message 
															delegate:self 
															cancelButtonTitle:@"Retry" 
															otherButtonTitles:nil];
	[alertNoAccount show];
	[alertNoAccount release];	
	}
	
	signInButton.enabled = YES;
}



- (IBAction)signUp:(id)sender
{
	
}



- (IBAction)proceedAsGuest:(id)sender
{
	[self goToAccountPage:@"test2"];
}

-(IBAction)createAnAccount:(id)sender
{
	self.title = @"Create Account";
	[UIView transitionFromView:(UIView *)guestView toView:(UIView *)signUpView duration:1 
					   options:UIViewAnimationOptionTransitionCurlDown  
					completion:NULL];	
}



- (void) goToAccountPage:(NSString *)userEmail
{
	
	UITabBarController *tabBarController = [[UITabBarController alloc] init];
		
	CurrentCartViewController *currentCart = [[CurrentCartViewController alloc] init];
	ClosedCartsViewController *closedCarts = [[ClosedCartsViewController alloc] init];
	AccountSettingsViewController *accountSettings = [[AccountSettingsViewController alloc] init];

	currentCart.userEmail = userEmail;
	closedCarts.userEmail = userEmail;
	accountSettings.userEmail  = userEmail;
	
	// Set Tab Bar properties
	UITabBarItem *currentCartItem = [[UITabBarItem alloc] initWithTitle:@"Current Cart" 
																  image:[UIImage imageNamed:@"cart.png"]
																	tag:1];
	UITabBarItem *closedCartsItem = [[UITabBarItem alloc] initWithTitle:@"Closed Carts" 
																  image:[UIImage imageNamed:@"archive.png"]
																	tag:2];
	UITabBarItem *accountSettingsItem = [[UITabBarItem alloc] initWithTitle:@"Account Settings" 
																  image:[UIImage imageNamed:@"settings.png"]
																	tag:4];
	currentCart.tabBarItem = currentCartItem;
	closedCarts.tabBarItem = closedCartsItem;
	accountSettings.tabBarItem = accountSettingsItem;
	tabBarController.viewControllers = [NSArray arrayWithObjects: currentCart , closedCarts , accountSettings , nil];
	
	
	// replace new View i.e. tabBarController with current one i.e. Login View (Back button brings the Home screen)
	NSMutableArray *controllers = [NSMutableArray arrayWithArray: self.navigationController.viewControllers];
	[controllers replaceObjectAtIndex:[controllers count] - 1 withObject:tabBarController];
	[self.navigationController setViewControllers:controllers animated:YES];
	
	
	
	[tabBarController release];
	[currentCart release];
	[closedCarts release];
	[accountSettings release];
	[currentCartItem release];
	[closedCartsItem release];
	[accountSettingsItem release];
}

#pragma mark -


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

- (void)viewWillAppear:(BOOL)animated
{
	// Default view is Login view for self.title == "User Login"
	if ([self.title isEqual:@"Create Account"])
	{ 
		signUpScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 100, 200)];
		signUpScroller.contentSize = signUpView.frame.size;
		[signUpScroller addSubview:signUpView];
		self.view = signUpScroller;  //Signup view
	}
	else if ([self.title isEqual:@"Guest Login"]) 
	{
		self.view = guestView;
	}
	
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	// Set the look of Buttons
	[signInButton setBackgroundImage: [[UIImage imageNamed:@"whiteButton"] 
								 stretchableImageWithLeftCapWidth:12 topCapHeight:0]
								forState:UIControlStateNormal];	
	
	[signUpButton setBackgroundImage: [[UIImage imageNamed:@"whiteButton"] 
									   stretchableImageWithLeftCapWidth:12 topCapHeight:0]
							forState:UIControlStateNormal];	
	
	[proceedAsGuestButton setBackgroundImage: [[UIImage imageNamed:@"whiteButton"] 
									   stretchableImageWithLeftCapWidth:12 topCapHeight:0]
							forState:UIControlStateNormal];
	
	[createAnAccountButton setBackgroundImage: [[UIImage imageNamed:@"whiteButton"] 
											   stretchableImageWithLeftCapWidth:12 topCapHeight:0]
									forState:UIControlStateNormal];
	 
    //Initialize textFields
	for (UITextField *textField in [NSArray arrayWithObjects: signInUsernameTextField , signUpUsernameTextField ,
		signUpNicknameTextField,nil ]) 
	{
		textField.text = [self defaultText:textField];
	}
	 
	
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[signInUsernameTextField release];
	[signInPasswordTextField release];
	[signUpUsernameTextField release];
	[signUpPasswordTextField release];
	[signUpPasswordVerifyTextField release];
	[signUpNicknameTextField release];
	
	[username release];
	[password release]; 
	[nickname release];
	
	[signInButton release];
	[signUpButton release];
	[signUpView release];
	[signUpScroller release];
	[guestView release];
	
	[super dealloc];
}


@end
