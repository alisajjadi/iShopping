//
//  CurrentCartViewController.m
//  iShopping
//
//  Created by Ali Sajjadi on 10/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CurrentCartViewController.h"
#import "CartItemViewController.h"
#import "ClosedCartsViewController.h"
#import "TalkToServer.h"

#import <QuartzCore/QuartzCore.h>

@implementation CurrentCartViewController

@synthesize userEmail;
@synthesize cartItems;
@synthesize tableView;



- (void) editCart
{
	[archiveOrAddItemButton setTitle:@"Add New Item" forState:UIControlStateNormal];
	[tableView setEditing:YES animated:YES];

	UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
																			target:self
																			action:@selector(doneEditingCart)];
	self.tabBarController.navigationItem.rightBarButtonItem = button;
	[button release];
	
}


- (void) doneEditingCart
{
	[archiveOrAddItemButton setTitle:@"Archive Cart" forState:UIControlStateNormal];
	[tableView setEditing:NO animated:YES];
	
	UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemEdit
																			target:self
																			action:@selector(editCart)];
	self.tabBarController.navigationItem.rightBarButtonItem = button;
	[button release];
	
}


- (IBAction) archiveCartOrAddNewItem
{
	if ([archiveOrAddItemButton.titleLabel.text isEqualToString: @"Archive Cart"])   //Archive Cart
	{
		UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
														   delegate:self
												  cancelButtonTitle:@"Cancel" 
											 destructiveButtonTitle:nil 
												  otherButtonTitles:@"Archive Cart",nil];
		
		[sheet showInView:self.view];
		[sheet release];		
	}
	else   // Add New Item ... 
	{
		CartItemViewController *cartItemView = [[CartItemViewController alloc] initWithNibName:@"CartItemViewController" bundle:nil];
		ShoppingItem *newItem = [[ShoppingItem alloc] init];
		
		cartItemView.item = newItem;
		cartItemView.callingViewController = self;
		cartItemView.itemIsEditable = EditOnly;
		[self presentModalViewController:cartItemView animated:YES];

		[cartItems addObject:newItem];
		[newItem release];
		[cartItemView release];	
		
		NSArray *lastIndex = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:cartItems.count - 1 inSection:0]];
		[tableView insertRowsAtIndexPaths: lastIndex  withRowAnimation:UITableViewRowAnimationTop];
		[tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:cartItems.count - 1 inSection:0] 
							   animated:YES scrollPosition:UITableViewScrollPositionTop];
	}
		
}


- (void)returnFromModalViewWithItem:(ShoppingItem *) item
{
	if (item.itemName.length > 0)   
	{
		if (tableView.editing)  // New Item Added
		{
			[TalkToServer addItemToDatabase:item forUser:userEmail];
		}
		else 
		{
			// Existing item is edited
		}

	}
	else	// existing item name set to empty string -> item will be deleted
	{
		[cartItems removeObjectAtIndex:tableView.indexPathForSelectedRow.row];
		
		//if (tableView.indexPathForSelectedRow.row != cartItems.count)
		//	[TalkToServer deleteItemFromDatabase:[cartItems objectAtIndex:tableView.indexPathForSelectedRow.row] forUser:userEmail];
	}
	
	// Reload TableView and Select the Selected row again to be deselected with animation in viewWillAppear
	NSIndexPath *indexpath = [tableView indexPathForSelectedRow];
	[tableView reloadData];
	[tableView selectRowAtIndexPath:indexpath animated:NO scrollPosition:UITableViewScrollPositionNone];
	
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	
	if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString: @"Archive Cart"])
	{
		[TalkToServer archiveCurrentCartToDatabaseForUser:userEmail]; 
		[cartItems removeAllObjects];
		[tableView reloadData];
		// Update Closed Carts View Controller
		ClosedCartsViewController *closedCarts = [self.tabBarController.viewControllers objectAtIndex:1];
		[closedCarts.carts release];
		closedCarts.carts = [[TalkToServer closedCartsForUser:userEmail] retain];
		[closedCarts.picker reloadAllComponents];
		[closedCarts pickerView:closedCarts.picker didSelectRow:[closedCarts.picker selectedRowInComponent:0] inComponent:0];	
	}
	
}

#pragma mark -
#pragma mark UITableViewDataSource/Delegate

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	return cartItems.count;
}	

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return @"Items in Cart";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section 
{
	if (cartItems.count == 0)
		return @"Cart is Empty";
	else 
		return nil;
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:@"Cell"];
	if (cell == nil) 
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewStyleGrouped reuseIdentifier:@"Cell"] autorelease];
	
	ShoppingItem *item = [cartItems objectAtIndex:indexPath.row];
	cell.textLabel.text = [item itemName];
	if (item.cleared)
		cell.textLabel.textColor = [UIColor grayColor];
	else
		cell.textLabel.textColor = [UIColor blackColor];	
//	cell.accessoryType = UITableViewCellAccessoryNone;
//	cell.editingAccessoryType = UITableViewCellAccessoryNone;

	return cell;		
}

- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (!table.editing) // Show current item (editable)
	{
		CartItemViewController *cartItemView = [[CartItemViewController alloc] initWithNibName:@"CartItemViewController" bundle:nil];
		cartItemView.item = [cartItems objectAtIndex:indexPath.row];
		cartItemView.callingViewController = self;
		cartItemView.itemIsEditable = Editable;
		[self presentModalViewController:cartItemView animated:YES];
		[cartItemView release];
	}
	else     // Toggle Cleared/Pending
	{
		[[cartItems objectAtIndex:indexPath.row] setCleared:![[cartItems objectAtIndex:indexPath.row] cleared]];
		[tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
}


- (UITableViewCellEditingStyle) tableView : (UITableView *)table editingStyleForRowAtIndexPath : (NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleDelete;
}


- (void)tableView:(UITableView *)table commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	[TalkToServer deleteItemFromDatabase:[cartItems objectAtIndex:indexPath.row] forUser:userEmail];
	[cartItems removeObjectAtIndex:indexPath.row];
	[table deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}

- (void) tableView: (UITableView*) tableView moveRowAtIndexPath: (NSIndexPath*)fromIndexPath toIndexPath: (NSIndexPath*) toIndexPath
{
	// Move Object in cartItems
	int to = toIndexPath.row;
	int from = fromIndexPath.row;
	if (to != from) 
	{
        id obj = [cartItems objectAtIndex:from];
        [obj retain];
        [cartItems removeObjectAtIndex:from];
        if (to >= [cartItems count]) {
            [cartItems addObject:obj];
        } else {
            [cartItems insertObject:obj atIndex:to];
        }
        [obj release];
    }
}


#pragma mark -
#pragma mark  UISearchBarDelegate


- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
	[searchBar resignFirstResponder];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {  
    searchBar.showsCancelButton = YES;  
	return YES;
}  

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {  
    searchBar.showsCancelButton = NO; 
	return YES;

}  

#pragma mark -



- (void)viewDidLoad {
	tableView.allowsSelectionDuringEditing = YES;
	
	// Set Left Navigation Bar button
	UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Logout" 
											  style:UIBarButtonItemStyleBordered	 
											 target:self	 
											 action:@selector(popViewController)];
	self.tabBarController.navigationItem.leftBarButtonItem = button;
	self.tabBarController.title = @"Current Cart";
	[button release];

	cartItems = [[TalkToServer cartItemsForUsername:userEmail andCartId:0] retain];
	
	[super viewDidLoad];
}


- (void) popViewController
{
	[self.tabBarController.navigationController popViewControllerAnimated:YES];
} 


- (void)viewWillAppear:(BOOL)animated {
	
	// Set Right Navigation Bar button
	UIBarButtonItem *button;
	if (!tableView.editing){
		button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemEdit
																			target:self
																			action:@selector(editCart)];
	} else { 
		button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
																				target:self
																				action:@selector(doneEditingCart)];
	}
	self.tabBarController.navigationItem.rightBarButtonItem = button;
	[button release];

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
	[cartItems release];
	[userEmail release];
	[archiveOrAddItemButton release];
	[tableView release];
    [super dealloc];
}




@end
