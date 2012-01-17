//
//  IngredientDetail.m
//  iOS-5-Recipes
//
//  Created by 杨裕欣 on 12-1-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IngredientDetailViewController.h"
#import "EditingTableViewCell.h"


@implementation IngredientDetailViewController

@synthesize recipe = _recipe;
@synthesize ingredient = _ingredient;


- (IBAction)cancelEdit:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)saveEdit:(id)sender {
	
	NSManagedObjectContext *context = [self.recipe managedObjectContext];
	
	/*
	 If there isn't an ingredient object, create and configure one.
	 */
    if (!self.ingredient) {
        self.ingredient = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
        [self.recipe addIngredientsObject:self.ingredient];
		self.ingredient.displayOrder = [NSNumber numberWithInteger:[self.recipe.ingredients count]];
    }
	
	/*
	 Update the ingredient from the values in the text fields.
	 */
    EditingTableViewCell *cell;
	
    cell = (EditingTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    self.ingredient.name = cell.textField.text;
	
    cell = (EditingTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    self.ingredient.amount = cell.textField.text;
	
	/*
	 Save the managed object context.
	 */
	NSError *error = nil;
	if (![context save:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
	
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"IngredientsCell";
    
    EditingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[EditingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row == 0) {
        NSLog(@"%@", self.ingredient.name);
        cell.label.text = @"Ingredient:";
        cell.textField.text = self.ingredient.name;
        cell.textField.placeholder = @"name";
    } else if (indexPath.row == 1) {
        cell.label.text = @"Amount:";
        cell.textField.text = self.ingredient.amount;
        cell.textField.placeholder = @"amout";
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // disable table cell selection
    return nil;
}

@end
