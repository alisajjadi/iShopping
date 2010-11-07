//
//  CartItemViewController.m
//  iShopping
//
//  Created by Ali Sajjadi on 10/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CartItemViewController.h"


@implementation CartItemViewController

@synthesize item;
@synthesize callingViewController;
@synthesize itemIsEditable;

- (void) copyItemToView
{
	nameLabel.text = item.itemName; 
	descriptionLabel.text = item.itemDescription;
}

- (void) copyViewToItem
{
	item.itemName = nameLabel.text;
	item.itemDescription = descriptionLabel.text;	
}

-(IBAction) editOrCancelEditing
{
		
	if (nameLabel.editable)  // cancel Editing
	{
		nameLabel.editable = NO;
		descriptionLabel.editable = NO;
		[self copyItemToView];
		leftBarButton.title = @"Edit";
		rightBarButton.title = @"Done";
		if (self.itemIsEditable == EditOnly)
			[self doneOrSave];
	} else {				// start Editing
		nameLabel.editable = YES;
		descriptionLabel.editable = YES;
		leftBarButton.title = @"Cancel";
		rightBarButton.title = @"Save";
	}
}

-(IBAction) doneOrSave
{
	if (nameLabel.editable)   // Save
	{
		nameLabel.editable = NO;
		descriptionLabel.editable = NO;
		[self copyViewToItem];
		rightBarButton.title = @"Done";
		if (self.itemIsEditable == EditOnly)
			[self doneOrSave];
		
	} else {                  // Done
		[callingViewController returnFromModalViewWithItem:self.item];
	}
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	[self copyItemToView];
	if (self.itemIsEditable == NotEditable)
		leftBarButton.enabled = NO;
		//	self.navigationItem.leftBarButtonItem = nil;
	
	if (self.itemIsEditable == EditOnly)
	{
		nameLabel.editable = YES;
		descriptionLabel.editable = YES;
		leftBarButton.title = @"Cancel";
		rightBarButton.title = @"Save";
	}

	[super viewDidLoad];
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
	
	[item release];
	[nameLabel release];
	[descriptionLabel release];
	[leftBarButton release];
	[rightBarButton release];
	[callingViewController release];
	
    [super dealloc];
}


@end
