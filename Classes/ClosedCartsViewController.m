//
//  ClosedCartsViewController.m
//  iShopping
//
//  Created by Ali Sajjadi on 10/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ClosedCartsViewController.h"
#import "CartItemViewController.h"
#import "CurrentCartViewController.h"
#import "Cart.h"
#import "TalkToServer.h"


@implementation ClosedCartsViewController

@synthesize userEmail;
@synthesize carts;
@synthesize picker;


- (void)returnFromModalViewWithItem:(ShoppingItem *) item
{
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark PickerViewDataSource/Delegate

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return carts.count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	[cartItems release];
	cartItems = [[TalkToServer cartItemsForUsername:userEmail andCartId:[[carts objectAtIndex:carts.count - 1 - row] userCartID]] retain];
	
	[copyFlags removeAllObjects];
	for (int i = 0; i < [cartItems count] ; i++)
		[copyFlags addObject:[NSNumber numberWithBool:YES]];
	
	[tableView reloadData];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view 
{
	UILabel *pickerLabel = (UILabel *)view;
	if (!pickerLabel) {
		pickerLabel= [[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)] autorelease];
		pickerLabel.font = [UIFont boldSystemFontOfSize:17];
		pickerLabel.backgroundColor = [UIColor clearColor];
	}
	
	Cart *thisCart = [carts objectAtIndex:carts.count - 1 - row];
	pickerLabel.text = [NSString stringWithFormat: @" Cart %d, %@", thisCart.userCartID, thisCart.createTime]; 
	return pickerLabel;	
}

#pragma mark -
#pragma mark UITableViewDataSource/Delegate

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	return cartItems.count;	
}	

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return @"Items in Cart"; // [(UILabel *)[picker viewForRow:[picker selectedRowInComponent:0] forComponent:0] text];
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:@"Cell"];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewStyleGrouped reuseIdentifier:@"Cell"] autorelease];
		cell.textLabel.textColor = [UIColor blackColor];
		cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		
		//UIButton *accessoryButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
		UIButton *accessoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
		accessoryButton.frame = CGRectMake(0, 0, 24, 24);
		[accessoryButton setImage:[UIImage imageNamed:@"copy.png"] forState:UIControlStateNormal];
		
		[accessoryButton addTarget:self action:@selector(copyItemToCurrentCart:forEvent:) forControlEvents:UIControlEventTouchUpInside ] ;
		cell.accessoryView = accessoryButton;		
	}
	
	cell.textLabel.text = [[cartItems objectAtIndex:indexPath.row]itemName];
	[(UIButton *)[cell accessoryView] setEnabled:[[copyFlags objectAtIndex:indexPath.row] boolValue]];
	return cell;		
}

- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
	CartItemViewController *cartItemView = [[CartItemViewController alloc] initWithNibName:@"CartItemViewController" bundle:nil];
	cartItemView.item = [cartItems objectAtIndex:indexPath.row];
	cartItemView.callingViewController = self;
	cartItemView.itemIsEditable = NotEditable;
	[self presentModalViewController:cartItemView animated:YES];
	[cartItemView release];
}

#pragma mark -

- (void)copyItemToCurrentCart:(id)sender forEvent:(UIEvent *)event
{
	NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:[[[event touchesForView:sender] anyObject] locationInView:tableView]];
	[tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
	
	UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
													   delegate:self
											  cancelButtonTitle:@"Cancel" 
										 destructiveButtonTitle:nil 
											  otherButtonTitles:@"Copy Item to Current Cart",nil];
	
	[sheet showInView:self.view];
	[sheet release];
}


- (void)deleteCart   // Delete Selected Closed Cart
{
	UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
													   delegate:self
											  cancelButtonTitle:@"Cancel" 
										 destructiveButtonTitle:@"Delete Cart" 
											  otherButtonTitles:nil];
	
	[sheet showInView:self.view];
	[sheet release];
	
}

#pragma mark -
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if ([actionSheet buttonTitleAtIndex:0] == @"Delete Cart")
		if (buttonIndex == 0)
		{
			[carts removeObjectAtIndex:[picker selectedRowInComponent:0]];
			[picker reloadAllComponents];
			[self pickerView:picker didSelectRow:[picker selectedRowInComponent:0] inComponent:0];
		}
	
	if ([actionSheet buttonTitleAtIndex:0] == @"Copy Item to Current Cart") 
	{
		NSIndexPath *selectedIndexPath = tableView.indexPathForSelectedRow;
		
		if (buttonIndex == 0) //Copy Button
		{	
			[copyFlags replaceObjectAtIndex:selectedIndexPath.row withObject:[NSNumber numberWithBool:NO]];
			CurrentCartViewController *currentCart = [self.tabBarController.viewControllers objectAtIndex:0];
			[currentCart.cartItems addObject:[cartItems objectAtIndex:selectedIndexPath.row]];
			[currentCart.tableView reloadData];
			[TalkToServer copyItemToCurrentCart:[cartItems objectAtIndex:selectedIndexPath.row] forUser:userEmail];
		}
		
		[tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:selectedIndexPath] withRowAnimation:NO];
		[tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
	}
}

#pragma mark -

- (void)viewDidLoad {

	
	carts = [[TalkToServer closedCartsForUser:userEmail] retain];
	
	[super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
	
	// Set right navigation bar button
	UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash  
															  target:self
															  action:@selector(deleteCart)];
	self.tabBarController.navigationItem.rightBarButtonItem = button;
	[button release];
	self.tabBarController.title = @"Closed Carts";
	
	// read Carts from Disk
//	carts = [[TalkToServer closedCartsForUser:userEmail] retain];
	
	// initialize current picker selection and its associated cart
	[copyFlags release];
	copyFlags = [[NSMutableArray alloc] init];
	[picker reloadAllComponents];
	[self pickerView:picker didSelectRow:[picker selectedRowInComponent:0] inComponent:0];	
	
	[tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
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
	[carts release];
	[cartItems release];
	[copyFlags release];
	[tableView release];
	[picker release];
	
    [super dealloc];
}


@end