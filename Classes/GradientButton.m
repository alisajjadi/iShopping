//
//  GradientButton.m
//  iShopping
//
//  Created by Ali Sajjadi on 11/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GradientButton.h"


@implementation GradientButton


- (void) awakeFromNib;
{
    // Initialize the gradient layer
    gradientLayer = [[CAGradientLayer alloc] init];
    // Set its bounds to be the same of its parent
    [gradientLayer setBounds:[self bounds]];
    // Center the layer inside the parent layer
    [gradientLayer setPosition:
	 CGPointMake([self bounds].size.width/2,
				 [self bounds].size.height/2)];
	
    // Insert the layer at position zero to make sure the 
    // text of the button is not obscured
    [[self layer] insertSublayer:gradientLayer atIndex:0];
	
    // Set the layer's corner radius
    [[self layer] setCornerRadius:8.0f];
    // Turn on masking
    [[self layer] setMasksToBounds:YES];
    // Display a border around the button 
    // with a 1.0 pixel width
    [[self layer] setBorderWidth:1.0f];
	[[self layer] setBorderColor:[[UIColor grayColor] CGColor]];
}


- (void)drawRect:(CGRect)rect;
{	
	if (self.isHighlighted)
	{
		[gradientLayer setColors:
		 [NSArray arrayWithObjects:
		  (id)[[UIColor colorWithRed:0.033 green:0.251 blue:0.673 alpha:1.0] CGColor], 
		(id)[[UIColor colorWithRed:0.66 green:0.701 blue:0.88 alpha:1.0] CGColor], nil]];
		 
	}
    else
	{
		[gradientLayer setColors:
		 [NSArray arrayWithObjects:
		  (id)[[UIColor whiteColor] CGColor], 
		  (id)[[UIColor grayColor] CGColor], nil]];
		
	}
	[super drawRect:rect];
}


- (void) setHighlighted:(BOOL) highLighted
{
	[super setHighlighted:highLighted];
	[self setNeedsDisplay];
}


- (void)dealloc {
    // Release our gradient layer
    [gradientLayer release];
    [super dealloc];
}



@end
