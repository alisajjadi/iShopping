//
//  iShoppingViewController.m
//  iShopping
//
//  Created by Ali Sajjadi on 10/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "iShoppingViewController.h"
#import "LoginViewController.h"

@implementation iShoppingViewController


#pragma mark -
#pragma mark UITableViewDataSource/Delegate


- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
	return 1;
}	

- (NSInteger)numberOfSectionsInTableView:(UITableView *)table {
	return 3; // Default is 1 if not implemented
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:@"Cell"];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewStyleGrouped reuseIdentifier:@"Cell"] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	cell.textLabel.text = [[NSArray arrayWithObjects:@"Already have an account" , 
													 @"Create an account" , 
													 @"Proceed as a guest" , nil] 
						   objectAtIndex:indexPath.section];
	return cell;		
}

- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	LoginViewController *viewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
	viewController.title = [[NSArray arrayWithObjects:@"User Login" , 
							@"Create Account" , 
							@"Guest Login" , nil] 
						   objectAtIndex:indexPath.section];	
	[self.navigationController pushViewController:viewController animated:YES]; 
	[viewController release];
}


#pragma mark -

- (void)viewWillAppear:(BOOL)animated {
[tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}


/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
	 [super viewDidLoad];
 }
*/


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
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
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
