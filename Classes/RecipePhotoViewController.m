//
//  RecipePhotoViewController.m
//  iOS-5-Recipes
//
//  Created by 杨裕欣 on 12-1-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RecipePhotoViewController.h"

@implementation RecipePhotoViewController

@synthesize recipe = _recipe;
@synthesize imageView = _imageView;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imageView.image = [self.recipe.image valueForKey:@"image"];
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
