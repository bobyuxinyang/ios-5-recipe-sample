//
//  InstructionsViewController.m
//  iOS-5-Recipes
//
//  Created by 杨裕欣 on 12-1-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InstructionsViewController.h"

@implementation InstructionsViewController

@synthesize recipe = _recipe;
@synthesize nameLabel = _nameLabel, instructionsText = _instructionsText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void) viewDidLoad
{
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) viewWillAppear:(BOOL)animated
{
    self.nameLabel.text = self.recipe.name;
    self.instructionsText.text = self.recipe.instructions;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void) setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    self.instructionsText.editable = editing;
    [self.navigationItem setHidesBackButton:editing animated:YES];
    if (editing) {
        [self.instructionsText becomeFirstResponder];
    } else {
        // save to database
        self.recipe.instructions = self.instructionsText.text;
        NSManagedObjectContext *context = self.recipe.managedObjectContext;
        NSError *error;
        if (![context save:&error ]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();            
        }
    }
}

@end
