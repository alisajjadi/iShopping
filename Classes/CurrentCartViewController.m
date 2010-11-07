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
#import "EmailCartsViewController.h"
#import "TalkToServer.h"

#import <QuartzCore/QuartzCore.h>

@implementation CurrentCartViewController

@synthesize userEmail;
@synthesize cartItems;
@synthesize tableView;

- (IBAction) archiveCart
{
	UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
													   delegate:self
											  cancelButtonTitle:@"Cancel" 
										 destructiveButtonTitle:nil 
											  otherButtonTitles:@"Archive Cart",nil];
	
	[sheet showInView:self.view];
	[sheet release];
}


- (IBAction) deleteCart
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

	if ([actionSheet buttonTitleAtIndex:buttonIndex] == @"Archive Cart")
	{
		[TalkToServer archiveCurrentCartToDatabaseForUser:userEmail]; 
		[cartItems removeAllObjects];
		[tableView reloadData];
		// Update Closed Carts View Controller
		ClosedCartsViewController *closedCarts = [self.tabBarController.viewControllers objectAtIndex:1];
		[closedCarts.carts release];
		closedCarts.carts = [[TalkToServer closedCartsForUser:userEmail] retain];
		[closedCarts.picker reloadAllComponents];
	}
	
	if ([actionSheet buttonTitleAtIndex:buttonIndex] == @"Delete Cart")
	{	// ******** SHOULD CHANGE TO A FASTER METHOD ********
		for (ShoppingItem *item in cartItems)
			[TalkToServer deleteItemFromDatabase:item forUser:userEmail];
		
		[cartItems removeAllObjects];
		[tableView reloadData];
	}

}

#pragma mark -


- (void) editCart
{
	[tableView setEditing:YES animated:YES];
	
	NSArray *lastIndex = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:cartItems.count inSection:0]];
	[tableView insertRowsAtIndexPaths: lastIndex  withRowAnimation:UITableViewRowAnimationLeft];

	UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
																			target:self
																			action:@selector(doneEditingCart)];
	self.tabBarController.navigationItem.rightBarButtonItem = button;
	[button release];
	
}


- (void) doneEditingCart
{
	NSLog(@"# of Items: %d" , cartItems.count);

	[tableView setEditing:NO animated:YES];
	
	NSArray *lastIndex = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:cartItems.count inSection:0]];
	[tableView deleteRowsAtIndexPaths: lastIndex  withRowAnimation:UITableViewRowAnimationLeft];
	
	UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemEdit
																			target:self
																			action:@selector(editCart)];
	self.tabBarController.navigationItem.rightBarButtonItem = button;
	[button release];
	
}

- (void)addNewItem
{
	CartItemViewController *cartItemView = [[CartItemViewController alloc] initWithNibName:@"CartItemViewController" bundle:nil];
	ShoppingItem *newItem = [[ShoppingItem alloc] init];
	
	cartItemView.item = newItem;
	cartItemView.callingViewController = self;
	cartItemView.itemIsEditable = EditOnly;
	[self presentModalViewController:cartItemView animated:YES];
	[tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:cartItems.count inSection:0] 
						   animated:YES scrollPosition:UITableViewScrollPositionTop];
	
	[newItem release];
	[cartItemView release];
}

- (void)returnFromModalViewWithItem:(ShoppingItem *) item
{
	if (item.itemName.length > 0)
		if (tableView.indexPathForSelectedRow.row == cartItems.count)
		{	// new item added
			[cartItems addObject:item];
			[TalkToServer addItemToDatabase:item forUser:userEmail];
		} else
		{   // current item changed
//			ShoppingItem *oldItem = [cartItems objectAtIndex:tableView.indexPathForSelectedRow.row]; 
//			NSLog(@"old:%@   New:%@",oldItem.itemName,item.itemName);
//			[cartItems replaceObjectAtIndex:tableView.indexPathForSelectedRow.row withObject:item];
//			[TalkToServer replaceItemInDatabase:oldItem withItem:item forUser:userEmail];
		}
	else			// existing item name set to empty string -> item will be deleted
		if (tableView.indexPathForSelectedRow.row != cartItems.count)
		{
//			[TalkToServer deleteItemFromDatabase:[cartItems objectAtIndex:tableView.indexPathForSelectedRow.row] forUser:userEmail];
			[cartItems removeObjectAtIndex:tableView.indexPathForSelectedRow.row];
		}
	
	// Reload TableView and Select the Selected row again to be deselected with animation in viewWillAppear
	NSIndexPath *indexpath = [tableView indexPathForSelectedRow];
	[tableView reloadData];
	[tableView selectRowAtIndexPath:indexpath animated:NO scrollPosition:UITableViewScrollPositionNone];
	
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark UITableViewDataSource/Delegate

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	NSInteger count = cartItems.count;
	if (table.editing)
		count++;
	return count; // < 1 ? 1:count;

}	

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return @"Items in Cart";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	if (cartItems.count == 0)
		return @"Cart is Empty";
	else 
		return nil;

}


- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:@"Cell"];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewStyleGrouped reuseIdentifier:@"Cell"] autorelease];
	}
	
	if (indexPath.row < cartItems.count)
	{
		ShoppingItem *thisItem = [cartItems objectAtIndex:indexPath.row];
		cell.textLabel.text = thisItem.itemName;
		cell.textLabel.textColor = [UIColor blackColor];
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.editingAccessoryType = UITableViewCellAccessoryNone;
//		if (table.editing)
//			cell.selectionStyle = UITableViewCellSelectionStyleNone;
//		else 
			cell.selectionStyle = UITableViewCellSelectionStyleBlue;

	}
	else if (indexPath.row == cartItems.count) {
		cell.textLabel.text = @"Add New Item ...";
		cell.textLabel.textColor = [UIColor lightGrayColor];
		cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	}
	
	return cell;		
}

- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	if (indexPath.row < cartItems.count && !table.editing) // Show current item (editable)
	{
		CartItemViewController *cartItemView = [[CartItemViewController alloc] initWithNibName:@"CartItemViewController" bundle:nil];
		cartItemView.item = [cartItems objectAtIndex:indexPath.row];
		cartItemView.callingViewController = self;
		cartItemView.itemIsEditable = Editable;
		[self presentModalViewController:cartItemView animated:YES];
		[cartItemView release];
	}
	
	if (indexPath.row == cartItems.count && table.editing) // Add new item
		[self addNewItem];
	
}


- (UITableViewCellEditingStyle) tableView : (UITableView *)table editingStyleForRowAtIndexPath : (NSIndexPath *)indexPath
{
	if (indexPath.row < cartItems.count ) 
		return UITableViewCellEditingStyleDelete;
	else if (indexPath.row == cartItems.count )
		return UITableViewCellEditingStyleInsert; 
	else
		return UITableViewCellEditingStyleNone;
	
}


- (void)tableView:(UITableView *)table commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		[TalkToServer deleteItemFromDatabase:[cartItems objectAtIndex:indexPath.row] forUser:userEmail];
		[cartItems removeObjectAtIndex:indexPath.row];
		[table deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
	}
	
	if (editingStyle == UITableViewCellEditingStyleInsert)
		[self addNewItem];
	
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
	[deleteButton release];
	[tableView release];
    [super dealloc];
}




@end
