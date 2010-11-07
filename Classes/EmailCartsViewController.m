//
//  EmailCartsViewController.m
//  iShopping
//
//  Created by Ali Sajjadi on 10/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EmailCartsViewController.h"
#import "Cart.h"
#import "TalkToServer.h"



@implementation EmailCartsViewController

@synthesize userEmail;
@synthesize carts;
@synthesize tableView;


- (IBAction) sendEmail
{
	
	Cart *thisCart = [carts objectAtIndex:carts.count - 1 - [[tableView indexPathForSelectedRow] row]];
	NSString *message = [NSString stringWithFormat: @"Send Cart %d, %@ from %@ to %@", 
						 thisCart.userCartID, thisCart.createTime,fromTextField.text,toTextField.text];
	
	UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:message
													delegate:self
											  cancelButtonTitle:@"Cancel" 
										 destructiveButtonTitle:nil 
											  otherButtonTitles:@"Send",nil];
	
	[sheet showInView:self.view];
	[sheet release];
	
}


#pragma mark -
#pragma mark UITableViewDataSource/Delegate

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	return carts.count;	
}	

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return @"Select a Cart";
}


- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:@"Cell"];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewStyleGrouped reuseIdentifier:@"Cell"] autorelease];
	}
	
	
	Cart *thisCart = [carts objectAtIndex:carts.count - 1 - indexPath.row];
	cell.textLabel.text = [NSString stringWithFormat: @"Cart %d, %@", thisCart.userCartID, thisCart.createTime]; 
	cell.textLabel.textColor = [UIColor blackColor];
	cell.accessoryType = UITableViewCellAccessoryNone;
	
	return cell;		
}


#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	// the user pressed the "Done" button, so dismiss the keyboard
	[textField resignFirstResponder];
	return YES;
}


#pragma mark -

- (void)viewWillAppear:(BOOL)animated {
	// Set right navigation bar button
	self.tabBarController.navigationItem.rightBarButtonItem = nil;
	self.tabBarController.title = @"Email Cart";
	[carts release];
	carts = [[TalkToServer closedCartsForUser:userEmail] retain];
	[tableView reloadData];
}


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
	[emailButton release];
	[fromTextField release];
	[toTextField release];
	[tableView release];
	[carts release];
	
	
    [super dealloc];
}


@end
