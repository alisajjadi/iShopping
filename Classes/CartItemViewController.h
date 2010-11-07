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

@interface CartItemViewController : UIViewController {
	
	ShoppingItem *item;
	UIViewController *callingViewController;
	EditableStyle itemIsEditable;
	
	IBOutlet UITextView *nameLabel;
	IBOutlet UITextView *descriptionLabel;
	
	IBOutlet UIBarButtonItem *leftBarButton;
	IBOutlet UIBarButtonItem *rightBarButton;

}

@property (nonatomic , retain) ShoppingItem *item;
@property (nonatomic , retain) UIViewController *callingViewController;
@property (nonatomic , assign) EditableStyle itemIsEditable;

-(IBAction) doneOrSave;
-(IBAction) editOrCancelEditing;

@end
