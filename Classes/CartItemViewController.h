//
//  CartItemViewController.h
//  iShopping
//
//  Created by Ali Sajjadi on 10/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingItem.h"

typedef enum {
	NotEditable = 0,
	Editable,
    EditOnly
} EditableStyle;

@protocol CartItemViewControllerDelegate

@required

- (void)returnFromCartItemModalViewWithItem:(ShoppingItem *) item;

@end

@interface CartItemViewController : UIViewController <UIScrollViewDelegate , UIActionSheetDelegate , UIImagePickerControllerDelegate , UINavigationControllerDelegate, UITextViewDelegate> {
	
	ShoppingItem *item;
	EditableStyle itemIsEditable;
														
	IBOutlet UINavigationBar *topBar;

	IBOutlet UITextView *nameLabel;
	IBOutlet UITextView *descriptionLabel;
	IBOutlet UIScrollView *imageScrollView;
	UIImageView *imageView;
	UILabel *imageLabel;
	UIView *coverView;
	UIImage *noPhoto;
	
	UIGestureRecognizer *tapRecognizer;
	
	BOOL editing;
	CGRect imageScrollViewOriginalFrame;
	
	IBOutlet UIScrollView *pageScrollView;

}

@property (nonatomic , retain) ShoppingItem *item;
@property (nonatomic , retain) id<CartItemViewControllerDelegate> callingViewController;
@property (nonatomic , assign) EditableStyle itemIsEditable;
@property (nonatomic , assign , getter = isEditing) BOOL editing;

@end
