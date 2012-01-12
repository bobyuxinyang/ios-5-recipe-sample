//
//  RecipeListTableViewController.m
//  iOS-5-Recipes
//
//  Created by 杨裕欣 on 12-1-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RecipeListTableViewController.h"
#import "RecipeTableViewCell.h"
#import "RecipeDetailViewController.h"
#import "RecipeAddViewController.h"
#import "AppDelegate.h"

@interface RecipeListTableViewController()
@property (nonatomic, strong) Recipe* selectedRecipe;
@end

@implementation RecipeListTableViewController

#pragma mark - Properties
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;

@synthesize selectedRecipe = _selectedRecipe;
@synthesize recipeDatabase = _recipeDatabase;

- (void) setupFecthedResult {
    self.managedObjectContext = self.recipeDatabase.managedObjectContext;
  
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Recipe" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];

    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];


    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    aFetchedResultsController.delegate = self;
    _fetchedResultsController = aFetchedResultsController;    
    
    
    NSError *error = nil;
   	if (![[self fetchedResultsController] performFetch:&error]) {
   		/*
   		 Replace this implementation with code to handle the error appropriately.
   		 
   		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
   		 */
   		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
   		abort();
   	}    
    
    [self.tableView reloadData];
}


- (void) useDocument
{    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.recipeDatabase.fileURL path]]) {
        
        NSFileManager *fileManager = [NSFileManager defaultManager];  
        NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"Recipes" ofType:@"sqlite"];
        
        if ([fileManager fileExistsAtPath:defaultStorePath]) {
            
            // copy the default database to the store directoryt
            NSURL *storeURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
            storeURL = [storeURL URLByAppendingPathComponent:@"Recipes/StoreContent"];
            NSError *error = nil;
            if (![fileManager createDirectoryAtURL:storeURL withIntermediateDirectories:YES attributes:nil error:&error]) {
                NSLog(@"unresolved error: %@, %@", error, error.userInfo);
            }            
            NSURL *finalurl = [storeURL URLByAppendingPathComponent:@"persistentStore"];            
            if (![fileManager moveItemAtPath:defaultStorePath toPath:[finalurl path] error:&error]) {
                NSLog(@"unresolved error: %@, %@", error, error.userInfo);                
            }
            
            
            [self.recipeDatabase openWithCompletionHandler:^(BOOL success) {
                [self setupFecthedResult];
            } ];
        } else {
            [self.recipeDatabase saveToURL:self.recipeDatabase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:         
             ^(BOOL success) {
                 [self setupFecthedResult];
             }];            
        }
        
    } else if (self.recipeDatabase.documentState == UIDocumentStateClosed) {
        [self.recipeDatabase openWithCompletionHandler:^(BOOL success) {
            [self setupFecthedResult];
        } ];
    } else if (self.recipeDatabase.documentState == UIDocumentStateNormal) {
        [self setupFecthedResult];
    }
}

- (void) setRecipeDatabase:(UIManagedDocument *)recipeDatabase
{
    if (_recipeDatabase != recipeDatabase) {
        _recipeDatabase = recipeDatabase;
        [self useDocument];
    }
}

- (void) setupRecipeDatabase
{
    if (!self.recipeDatabase) {
        NSURL* url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"Recipes"];
        self.recipeDatabase = [[UIManagedDocument alloc] initWithFileURL:url];
    }
}

- (void) viewDidLoad
{
    self.navigationItem.leftBarButtonItem = self.editButtonItem;    
    
    [self setupRecipeDatabase];

}

- (IBAction)add:(id)sender {    
    [self performSegueWithIdentifier:@"Add Recipe" sender:self];    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString: @"Show Recipe Detail"]) {
        RecipeDetailViewController *recipeDetailViewController = (RecipeDetailViewController*) segue.destinationViewController;
        recipeDetailViewController.recipe = self.selectedRecipe;
    } if ([segue.identifier isEqualToString:@"Add Recipe"]) {
        RecipeAddViewController *recipeAddViewController = (RecipeAddViewController*) ((UINavigationController*) segue.destinationViewController).topViewController;

        // add a recipe object to context
        Recipe *newRecipe = [NSEntityDescription insertNewObjectForEntityForName:@"Recipe" inManagedObjectContext:self.managedObjectContext];
        
        recipeAddViewController.recipe = newRecipe;
        recipeAddViewController.delegate = self;        
    }
}

- (void) recipeAddViewController:(RecipeAddViewController *)recipeAddViewController didAddRecipe:(Recipe *)recipe
{
    [self dismissModalViewControllerAnimated:YES];
    if (recipe) {
        self.selectedRecipe = recipe;
        [self performSegueWithIdentifier:@"Show Recipe Detail" sender:self];
    }

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = [[self.fetchedResultsController sections] count];
	if (count == 0) {
		count = 1;
	}
	
    return count;
}


- (void)configureCell:(RecipeTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell
	Recipe *recipe = (Recipe *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.recipe = recipe;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
	
    if ([[self.fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        numberOfRows = [sectionInfo numberOfObjects];
    }
    
    return numberOfRows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Dequeue or if necessary create a RecipeTableViewCell, then set its recipe to the recipe for the current row.
    static NSString *RecipeCellIdentifier = @"RecipeCellIdentifier";
    
    RecipeTableViewCell *recipeCell = (RecipeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:RecipeCellIdentifier];
    if (recipeCell == nil) {
        recipeCell = [[RecipeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RecipeCellIdentifier];
		recipeCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
	[self configureCell:recipeCell atIndexPath:indexPath];
    
    return recipeCell;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the managed object for the given index path
		NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
		[context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
		
		// Save the context.
		NSError *error;
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



/**
 Delegate methods of NSFetchedResultsController to respond to additions, removals and so on.
 */

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller is about to start sending change notifications, so prepare the table view for updates.
	[self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	UITableView *tableView = self.tableView;
	
	switch(type) {
		case NSFetchedResultsChangeInsert:
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeUpdate:
			[self configureCell:(RecipeTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
			break;
			
		case NSFetchedResultsChangeMove:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
	}
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	switch(type) {
		case NSFetchedResultsChangeInsert:
			[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller has sent all current change notifications, so tell the table view to process all updates.
	[self.tableView endUpdates];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Recipe *recipe = (Recipe *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    self.selectedRecipe = recipe;
    [self performSegueWithIdentifier:@"Show Recipe Detail" sender:self];
}

@end
