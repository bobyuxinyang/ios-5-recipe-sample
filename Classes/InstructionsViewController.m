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

@end
