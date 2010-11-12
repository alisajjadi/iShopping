//Scroll
//  CartItemViewController.m
//  iShopping
//imageLabel
//  Created by Ali Sajjadi on 10/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CartItemViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation CartItemViewController

@synthesize item;
@synthesize callingViewController;
@synthesize itemIsEditable;
@synthesize editing;

#define _ANIMATION_TIME 0.3

- (void) copyItemToView
{
	nameLabel.text = item.itemName; 
	descriptionLabel.text = item.itemDescription;
	if (item.itemPicture)
		imageView.image = item.itemPicture;
	else
		imageView.image = noPhoto;
}

- (void) copyViewToItem
{
	item.itemName = nameLabel.text;
	item.itemDescription = descriptionLabel.text;
	if (imageView.image == noPhoto)
		item.itemPicture = nil;
	else
		item.itemPicture = imageView.image;
}

-(void) edit
{
	self.editing = YES;
}

-(void) done
{
	[callingViewController returnFromCartItemModalViewWithItem:self.item];
}

-(void) cancelEditing
{
	self.editing = NO;
	[self copyItemToView];
	if (self.itemIsEditable == EditOnly)
		[self done];	
}

-(void) save
{
	self.editing = NO;
	[self copyViewToItem];
	if (self.itemIsEditable == EditOnly)
		[self done];
}

-(void)setEditing:(BOOL)_editing
{
	editing = _editing;
	if (editing)
	{
		nameLabel.editable = YES;
		descriptionLabel.editable = YES;
		UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel 
																				target: self action:@selector(cancelEditing)];
		topBar.topItem.leftBarButtonItem = button;
		[button release];
		button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemSave 
																target: self action:@selector(save)];
		topBar.topItem.rightBarButtonItem= button;
		[button release];
		
		if (item.itemPicture)
			imageLabel.text = @"Edit Photo";
		else
			imageLabel.text = @"Add Photo";
	}
	else 
	{
		nameLabel.editable = NO;
		descriptionLabel.editable = NO;
		UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemEdit 
																				target: self action:@selector(edit)];
		topBar.topItem.leftBarButtonItem = button;
		[button release];
		button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone 
															   target: self action:@selector(done)];
		topBar.topItem.rightBarButtonItem= button;
		[button release];
		
		if (item.itemPicture)
			imageLabel.text = nil;
		else
			imageLabel.text = @"No Photo";
	}
}

- (float) scalingFactorForBestFitOfView:(UIView *)child inView:(UIView *)parent
{
	if ((child.bounds.size.width > parent.bounds.size.width) || (parent.bounds.size.height > parent.bounds.size.height))
	{
		float widthSF = parent.bounds.size.width / child.bounds.size.width;
		float heightSF = parent.bounds.size.height / child.bounds.size.height;
		return (widthSF < heightSF) ? widthSF : heightSF; 
	} else 
		return 1; 
}

-(void) imageTapped
{	
	if (self.isEditing)
	{
		[nameLabel resignFirstResponder];
		[descriptionLabel resignFirstResponder];
		tapRecognizer.enabled = NO;
		NSString * deleteButton = nil , *takeButton = nil , *chooseButton = nil;
		if (item.itemPicture)
			deleteButton = @"Delete Photo";
		
		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
			takeButton = @"Take Photo";
			 
		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) 
			chooseButton = @"Choose Photo";
		
		UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
														   delegate:self
												  cancelButtonTitle:@"Cancel" 
											 destructiveButtonTitle:deleteButton 
												  otherButtonTitles:takeButton, chooseButton, nil];
		
		[sheet showInView:self.view];
		[sheet release];
	}
	else if (item.itemPicture)
	{
		if (coverView.alpha == 0)
		{
			topBar.topItem.leftBarButtonItem.enabled = NO;
			[UIView animateWithDuration: _ANIMATION_TIME
							 animations: ^{ 
								 imageScrollView.frame = pageScrollView.bounds; 
								 imageView.center = CGPointMake(pageScrollView.bounds.size.width / 2 , pageScrollView.bounds.size.height / 2);
								 
								 float scale = [self scalingFactorForBestFitOfView:imageView inView:pageScrollView];
								 [imageScrollView setZoomScale:scale animated: YES];
								 imageScrollView.minimumZoomScale = scale;
								 
								 coverView.alpha = 0.6;
							 } 
							 completion: ^(BOOL finished){
								 imageScrollView.scrollEnabled = YES;
							 }];
		}
		else 
		{
			[UIView animateWithDuration: _ANIMATION_TIME
							 animations: ^{ 
								 imageScrollView.frame = imageScrollViewOriginalFrame;
								 
								 float scale = [self scalingFactorForBestFitOfView:imageView inView:imageScrollView];
								 imageScrollView.minimumZoomScale = scale;
								 [imageScrollView setZoomScale:scale animated: YES];
								 
								 imageView.center = CGPointMake(imageScrollViewOriginalFrame.size.width / 2, 
																imageScrollViewOriginalFrame.size.height / 2);
								 
								 coverView.alpha = 0;
							 } 
							 completion: ^(BOOL finished){
								 imageScrollView.contentSize = imageScrollViewOriginalFrame.size;
								 imageScrollView.scrollEnabled = NO;
								 topBar.topItem.leftBarButtonItem.enabled = YES;

							 }];
			
		}
	}
}


#pragma mark -
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	tapRecognizer.enabled = YES;
	if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString: @"Take Photo"])
	{
		UIImagePickerController *pickerController = [[UIImagePickerController alloc] init]; 
		pickerController.delegate = self;
		pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
		pickerController.allowsEditing = YES; 
		[self presentModalViewController:pickerController animated:YES]; 
		
	}

	if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString: @"Choose Photo"])
	{
		UIImagePickerController *pickerController = [[UIImagePickerController alloc] init]; 
		pickerController.delegate = self;
		pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		pickerController.allowsEditing = YES; 
		[self presentModalViewController:pickerController animated:YES];
	}
	
	if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString: @"Delete Photo"])
	{
		imageLabel.text = @"Add Photo";
		imageView.frame = imageScrollView.bounds;
		imageView.image = noPhoto;
	}
}
#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[self dismissModalViewControllerAnimated:YES];
	imageView.frame = imageScrollView.bounds;
	imageView.image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
	imageLabel.text = @"Edit Photo";
	[picker release];
}
#pragma mark -

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {

	[self copyItemToView];
	
	pageScrollView.contentSize = pageScrollView.bounds.size;
	imageScrollViewOriginalFrame = imageScrollView.frame;
		
	noPhoto = [UIImage imageNamed:@"grayBackground.png"];
	if (item.itemPicture)
		imageView = [[UIImageView alloc] initWithImage:item.itemPicture];
	else
		imageView = [[UIImageView alloc] initWithImage:noPhoto];
	
	[imageScrollView addSubview:imageView];

	imageView.center = CGPointMake(imageScrollView.bounds.size.width / 2, imageScrollView.bounds.size.height / 2);
	[imageView release];

	float scale = [self scalingFactorForBestFitOfView:imageView inView:imageScrollView];
	imageScrollView.zoomScale = scale;
	imageScrollView.minimumZoomScale = scale;
	
	imageLabel = [[UILabel alloc] initWithFrame:imageView.frame];
	[imageScrollView addSubview:imageLabel];
	imageLabel.textAlignment = UITextAlignmentCenter;
	imageLabel.backgroundColor = [UIColor clearColor];
	[imageLabel release];
	
	coverView = [[UIView alloc] initWithFrame:pageScrollView.bounds];
	coverView.backgroundColor = [UIColor blackColor];
	coverView.alpha = 0;
	[pageScrollView insertSubview:coverView belowSubview:imageScrollView];
	[coverView release];

	tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped)];
	[imageScrollView addGestureRecognizer:tapRecognizer];
	
	///// Create round corners (uses QuartsCore.j)
	nameLabel.layer.masksToBounds = YES;
	nameLabel.layer.cornerRadius = 10;
	descriptionLabel.layer.masksToBounds = YES;
	descriptionLabel.layer.cornerRadius = 10;
	imageView.layer.masksToBounds = YES;
	imageView.layer.cornerRadius = 10/scale;
	/////
	
	if (self.itemIsEditable == NotEditable)
		topBar.topItem.leftBarButtonItem.enabled = NO;   // Edit Button disabled
	
	if (self.itemIsEditable == EditOnly)
		self.editing = YES;
	else 
		self.editing = NO;
	
	[super viewDidLoad];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView 
{
	CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)? 
	(scrollView.bounds.size.width - scrollView.contentSize.width) / 2 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)? 
	(scrollView.bounds.size.height - scrollView.contentSize.height) / 2 : 0.0;
	imageView.center = CGPointMake(scrollView.contentSize.width / 2 + offsetX, 
                                   scrollView.contentSize.height / 2 + offsetY);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return imageView;
}

#pragma mark -
#pragma mark UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
	if (textView == descriptionLabel)
		[UIView animateWithDuration: _ANIMATION_TIME
						 animations: ^{ 
							 CGRect viewFrame = pageScrollView.frame;
							 viewFrame.size.height -= 200;
							 pageScrollView.frame = viewFrame;
							 [pageScrollView scrollRectToVisible:CGRectOffset(descriptionLabel.frame , 0, -50) animated:YES]; 
						 } 
						 completion: ^(BOOL finished){ 
						 }];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
	if (textView == descriptionLabel)
		[UIView animateWithDuration: _ANIMATION_TIME
						 animations: ^{ 
							 CGRect viewFrame = pageScrollView.frame;
							 viewFrame.size.height += 200;
							 pageScrollView.frame = viewFrame;
						 } 
						 completion: ^(BOOL finished){ 
						 }];
}

#pragma mark -


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
	[imageScrollView release];
	[tapRecognizer release];
	[topBar release];
	
    [super dealloc];
}


@end
