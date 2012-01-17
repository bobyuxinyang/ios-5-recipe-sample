//
//  RecipeDetailViewController.m
//  iOS-5-Recipes
//
//  Created by 杨裕欣 on 12-1-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RecipeDetailViewController.h"
#import "InstructionsViewController.h"
#import "TypeSelectorViewController.h"
#import "IngredientDetailViewController.h"
#import "RecipePhotoViewController.h"

#define TYPE_SECTION 0
#define INGREDIENTS_SECTION 1
#define INSTRUCTIONS_SECTION 2

@interface RecipeDetailViewController()
@property (nonatomic, strong) Ingredient* currentIngredient;

@end

@implementation RecipeDetailViewController

@synthesize recipe = _recipe;
@synthesize ingredients = _ingredients;
@synthesize currentIngredient = _currentIngredient;

@synthesize tableHeaderView, photoButton, nameTextField, overviewTextField, prepTimeTextField;

- (void) photoTapped{
    if (self.isEditing){
		UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
		imagePicker.delegate = self;
		[self presentModalViewController:imagePicker animated:YES];
    }else {
        [self performSegueWithIdentifier:@"Show Recipe Photo" sender:self];
    }
}

- (void)updatePhotoButton {
	/*
	 How to present the photo button depends on the editing state and whether the recipe has a thumbnail image.
	 * If the recipe has a thumbnail, set the button's highlighted state to the same as the editing state (it's highlighted if editing).
	 * If the recipe doesn't have a thumbnail, then: if editing, enable the button and show an image that says "Choose Photo" or similar; if not editing then disable the button and show nothing.  
	 */
	BOOL editing = self.editing;
	
	if (self.recipe.thumbnailImage != nil) {
		photoButton.highlighted = editing;
	} else {
		photoButton.enabled = editing;
		
		if (editing) {
			[photoButton setImage:[UIImage imageNamed:@"choosePhoto.png"] forState:UIControlStateNormal];
		} else {
			[photoButton setImage:nil forState:UIControlStateNormal];
		}
	}
}

- (void) udpateRecipe
{
    [photoButton setImage:_recipe.thumbnailImage forState:UIControlStateNormal];
    self.navigationItem.title = _recipe.name;
    nameTextField.text = _recipe.name;    
    overviewTextField.text = _recipe.overview;    
    prepTimeTextField.text = _recipe.prepTime;    
    [self updatePhotoButton];   
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Recipe Instractions"])
    {
        InstructionsViewController *instructionsViewController = (InstructionsViewController*)segue.destinationViewController;
        instructionsViewController.recipe = self.recipe;
    } else if ([segue.identifier isEqualToString:@"Show Recipe Types Selector"]) {
        TypeSelectorViewController *typeSelectorViewController = (TypeSelectorViewController*)segue.destinationViewController;
        typeSelectorViewController.recipe = self.recipe;
    } else if ([segue.identifier isEqualToString:@"Show Ingrdient Detail"]) {
        IngredientDetailViewController *ingredientDetailViewControoler = (IngredientDetailViewController*)segue.destinationViewController;
        ingredientDetailViewControoler.recipe = self.recipe;
        ingredientDetailViewControoler.ingredient = self.currentIngredient;
    } else if ([segue.identifier isEqualToString:@"Show Recipe Photo"]) {
        RecipePhotoViewController* recipePhotoViewController = (RecipePhotoViewController*)segue.destinationViewController;
        recipePhotoViewController.recipe = self.recipe;
    }
}




#pragma mark -- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)selectedImage editingInfo:(NSDictionary *)editingInfo {
	
	// Delete any existing image.
	NSManagedObject *oldImage = self.recipe.image;
	if (oldImage != nil) {
		[self.recipe.managedObjectContext deleteObject:oldImage];
	}
	
    // Create an image object for the new image.
	NSManagedObject *image = [NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:self.recipe.managedObjectContext];
	self.recipe.image = image;
    
	// Set the image for the image managed object.
	[image setValue:selectedImage forKey:@"image"];
	
	// Create a thumbnail version of the image for the recipe object.
	CGSize size = selectedImage.size;
	CGFloat ratio = 0;
	if (size.width > size.height) {
		ratio = 44.0 / size.width;
	} else {
		ratio = 44.0 / size.height;
	}
	CGRect rect = CGRectMake(0.0, 0.0, ratio * size.width, ratio * size.height);
	
	UIGraphicsBeginImageContext(rect.size);
	[selectedImage drawInRect:rect];
	self.recipe.thumbnailImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark -- view lifecycle

- (void) viewDidLoad
{
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
	/*
	 Create a mutable array that contains the recipe's ingredients ordered by displayOrder.
	 The table view uses this array to display the ingredients.
	 Core Data relationships are represented by sets, so have no inherent order. Order is "imposed" using the displayOrder attribute, but it would be inefficient to create and sort a new array each time the ingredients section had to be laid out or updated.
	 */
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"displayOrder" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
	
	NSMutableArray *sortedIngredients = [[NSMutableArray alloc] initWithArray:[self.recipe.ingredients allObjects]];
	[sortedIngredients sortUsingDescriptors:sortDescriptors];
	self.ingredients = sortedIngredients;
	
    [self udpateRecipe];
	// Update recipe type and ingredients on return.
    [self.tableView reloadData];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark -
#pragma mark UITableView Delegate/Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = nil;
    // Return a title or nil as appropriate for the section.
    switch (section) {
        case TYPE_SECTION:
            title = @"Category";
            break;
        case INGREDIENTS_SECTION:
            title = @"Ingredients";
            break;
        default:
            break;
    }
    return title;;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    
    /*
     The number of rows depends on the section.
     In the case of ingredients, if editing, add a row in editing mode to present an "Add Ingredient" cell.
	 */
    switch (section) {
        case TYPE_SECTION:
        case INSTRUCTIONS_SECTION:
            rows = 1;
            break;
        case INGREDIENTS_SECTION:
            rows = [self.recipe.ingredients count];
            if (self.editing) {
                rows++;
            }
            break;
		default:
            break;
    }
    return rows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    // For the Ingredients section, if necessary create a new cell and configure it with an additional label for the amount.  Give the cell a different identifier from that used for cells in other sections so that it can be dequeued separately.
    if (indexPath.section == INGREDIENTS_SECTION) {
		NSUInteger ingredientCount = [self.recipe.ingredients count];
        NSInteger row = indexPath.row;
		
        if (indexPath.row < ingredientCount) {
            // If the row is within the range of the number of ingredients for the current recipe, then configure the cell to show the ingredient name and amount.
			static NSString *IngredientsCellIdentifier = @"IngredientsCell";
			
			cell = [tableView dequeueReusableCellWithIdentifier:IngredientsCellIdentifier];
			
			if (cell == nil) {
                // Create a cell to display an ingredient.
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:IngredientsCellIdentifier];
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
			
            Ingredient *ingredient = (Ingredient*)[self.ingredients objectAtIndex:row];
            cell.textLabel.text = ingredient.name;
			cell.detailTextLabel.text = ingredient.amount;
        } else {
            // If the row is outside the range, it's the row that was added to allow insertion (see tableView:numberOfRowsInSection:) so give it an appropriate label.
			static NSString *AddIngredientCellIdentifier = @"AddIngredientCell";
			
			cell = [tableView dequeueReusableCellWithIdentifier:AddIngredientCellIdentifier];
			if (cell == nil) {
                // Create a cell to display "Add Ingredient".
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddIngredientCellIdentifier];
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
            cell.textLabel.text = @"Add Ingredient";
        }
    } else {
        // If necessary create a new cell and configure it appropriately for the section.  Give the cell a different identifier from that used for cells in the Ingredients section so that it can be dequeued separately.
        static NSString *MyIdentifier = @"GenericCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        NSString *text = nil;
        
        switch (indexPath.section) {
            case TYPE_SECTION: // type -- should be selectable -> checkbox
                text = [self.recipe.type valueForKey:@"name"];
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case INSTRUCTIONS_SECTION: // instructions
                text = @"Instructions";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.editingAccessoryType = UITableViewCellAccessoryNone;
                break;
            default:
                break;
        }
        
        cell.textLabel.text = text;
    }
    return cell;
}



#pragma mark -
#pragma mark Editing rows


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCellEditingStyle style = UITableViewCellEditingStyleNone;
    // Only allow editing in the ingredients section.
    // In the ingredients section, the last row (row number equal to the count of ingredients) is added automatically (see tableView:cellForRowAtIndexPath:) to provide an insertion cell, so configure that cell for insertion; the other cells are configured for deletion.
    if (indexPath.section == INGREDIENTS_SECTION) {
        // If this is the last item, it's the insertion row.
        if (indexPath.row == [self.recipe.ingredients count]) {
            style = UITableViewCellEditingStyleInsert;
        }
        else {
            style = UITableViewCellEditingStyleDelete;
        }
    }
    
    return style;
}


- (void) setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    [self updatePhotoButton];
    self.nameTextField.enabled = editing;
    self.overviewTextField.enabled = editing;
    self.prepTimeTextField.enabled = editing;
    [self.navigationItem setHidesBackButton:editing animated:YES];
    
	[self.tableView beginUpdates];
	
    NSUInteger ingredientsCount = [self.recipe.ingredients count];
    
    NSArray *ingredientsInsertIndexPath = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:ingredientsCount inSection:INGREDIENTS_SECTION]];
    
    if (editing) {
        [self.tableView insertRowsAtIndexPaths:ingredientsInsertIndexPath withRowAnimation:UITableViewRowAnimationTop];
		overviewTextField.placeholder = @"Overview";
	} else {
        [self.tableView deleteRowsAtIndexPaths:ingredientsInsertIndexPath withRowAnimation:UITableViewRowAnimationTop];
		overviewTextField.placeholder = @"";
    }
    
    [self.tableView endUpdates];
    
    if (!editing) {
		NSManagedObjectContext *context = self.recipe.managedObjectContext;
		NSError *error = nil;
		if (![context save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
        }
    }
    
}



- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSIndexPath *rowToSelect = indexPath;
    NSInteger section = indexPath.section;
    BOOL isEditing = self.editing;
    
    // If editing, don't allow instructions to be selected
    // Not editing: Only allow instructions to be selected
    if ((isEditing && section == INSTRUCTIONS_SECTION) || (!isEditing && section != INSTRUCTIONS_SECTION)) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        rowToSelect = nil;    
    }
	return rowToSelect;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;

    switch (section) {
        case TYPE_SECTION:
            [self performSegueWithIdentifier:@"Show Recipe Types Selector" sender:self];
            break;			
        case INSTRUCTIONS_SECTION:
            [self performSegueWithIdentifier:@"Show Recipe Instractions" sender:self];
            break;
        case INGREDIENTS_SECTION:            
            if (indexPath.row < [self.recipe.ingredients count]) {
                self.currentIngredient = [self.ingredients objectAtIndex:indexPath.row];                
            }else{
                self.currentIngredient = nil;
            }
            [self performSegueWithIdentifier:@"Show Ingrdient Detail" sender:self];
    }
}



#pragma mark -
#pragma mark Moving rows

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL canMove = NO;
    // Moves are only allowed within the ingredients section.  Within the ingredients section, the last row (Add Ingredient) cannot be moved.
    if (indexPath.section == INGREDIENTS_SECTION) {
        canMove = indexPath.row != [self.recipe.ingredients count];
    }
    return canMove;
}


- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    NSIndexPath *target = proposedDestinationIndexPath;
    
    /*
     Moves are only allowed within the ingredients section, so make sure the destination is in the ingredients section.
     If the destination is in the ingredients section, make sure that it's not the Add Ingredient row -- if it is, retarget for the penultimate row.
     */
	NSUInteger proposedSection = proposedDestinationIndexPath.section;
	
    if (proposedSection < INGREDIENTS_SECTION) {
        target = [NSIndexPath indexPathForRow:0 inSection:INGREDIENTS_SECTION];
    } else if (proposedSection > INGREDIENTS_SECTION) {
        target = [NSIndexPath indexPathForRow:([self.recipe.ingredients count] - 1) inSection:INGREDIENTS_SECTION];
    } else {
        NSUInteger ingredientsCount_1 = [self.recipe.ingredients count] - 1;
        
        if (proposedDestinationIndexPath.row > ingredientsCount_1) {
            target = [NSIndexPath indexPathForRow:ingredientsCount_1 inSection:INGREDIENTS_SECTION];
        }
    }
	
    return target;
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	
	/*
	 Update the ingredients array in response to the move.
	 Update the display order indexes within the range of the move.
	 */
    Ingredient *ingredient = [self.ingredients objectAtIndex:fromIndexPath.row];
    [self.ingredients removeObjectAtIndex:fromIndexPath.row];
    [self.ingredients insertObject:ingredient atIndex:toIndexPath.row];
	
	NSInteger start = fromIndexPath.row;
	if (toIndexPath.row < start) {
		start = toIndexPath.row;
	}
	NSInteger end = toIndexPath.row;
	if (fromIndexPath.row > end) {
		end = fromIndexPath.row;
	}
	for (NSInteger i = start; i <= end; i++) {
		ingredient = [self.ingredients objectAtIndex:i];
		ingredient.displayOrder = [NSNumber numberWithInteger:i];
	}
}

#pragma mark --TextFieldDelegate

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
	
	if (textField == nameTextField) {
		self.recipe.name = nameTextField.text;
		self.navigationItem.title = self.recipe.name;
	}
	else if (textField == overviewTextField) {
		self.recipe.overview = overviewTextField.text;
	}
	else if (textField == prepTimeTextField) {
		self.recipe.prepTime = prepTimeTextField.text;
	}
	return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}


@end
