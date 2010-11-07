//
//  AccountSettingsViewController.m
//  iShopping
//
//  Created by Ali Sajjadi on 10/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AccountSettingsViewController.h"


@implementation AccountSettingsViewController

@synthesize userEmail;


-(IBAction) changePassword{

}




#pragma mark -
#pragma mark UITableViewDataSource/Delegate


- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
	return 1;
}	

- (NSInteger)numberOfSectionsInTableView:(UITableView *)table {
	return 4; // Default is 1 if not implemented
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:@"Cell"];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewStyleGrouped reuseIdentifier:@"Cell"] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	cell.textLabel.text = [[NSArray arrayWithObjects:@"Edit Account" , 
							@"Manage Nicknames" , 
							@"User's Manual" , 
							@"FAQs",nil] 
						   objectAtIndex:indexPath.section];
	return cell;		
}

- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

	NSArray *viewControllers = [NSArray arrayWithObjects:editAccountViewController , manageNicknamesViewController , manualViewController , FAQViewController , nil];
	
	[self presentModalViewController:[viewControllers objectAtIndex:indexPath.section] animated:YES];


}


#pragma mark -

-(IBAction) done
{
	[self.tabBarController.selectedViewController dismissModalViewControllerAnimated:YES];
	
}

- (void)viewWillAppear:(BOOL)animated {
	// Set right navigation bar button
	self.tabBarController.navigationItem.rightBarButtonItem = nil;
	self.tabBarController.title = @"Account Settings";
	
	[tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[changePasswordButton setBackgroundImage: [[UIImage imageNamed:@"whiteButton"] 
									   stretchableImageWithLeftCapWidth:12 topCapHeight:0]
							forState:UIControlStateNormal];	
	
	
    [super viewDidLoad];
}


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
	
	[userEmail release];
	[tableView release];
	[editAccountViewController release];
    [changePasswordButton release];
	[currentPassword release];
	[newPassword release];
	[verifyPassword release];
	[manageNicknamesViewController release];
	[manualViewController release];
	[FAQViewController release];
	
	
	[super dealloc];
}


@end
