//
//  TypeSelectorViewController.m
//  iOS-5-Recipes
//
//  Created by 杨裕欣 on 12-1-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TypeSelectorViewController.h"
#import "Recipe.h"

@interface TypeSelectorViewController()

@property (nonatomic, strong) NSManagedObject *currentType;

@end

@implementation TypeSelectorViewController

@synthesize recipe = _recipe;
@synthesize recipeTypes = _recipeTypes;
@synthesize currentType = _currentType;

- (void) setCurrentType:(NSManagedObject *)currentType
{
    if (currentType != _currentType) {
        
        NSInteger oldRow = [self.recipeTypes indexOfObject:_currentType];
        [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:oldRow inSection:0]].accessoryType = UITableViewCellAccessoryNone;
        
        _currentType = currentType;
    }
    
    NSInteger row = [self.recipeTypes indexOfObject: _currentType];
    UITableViewCell *newCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    newCell.accessoryType = UITableViewCellAccessoryCheckmark;    
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSManagedObjectContext *context = self.recipe.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"RecipeType"];
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors: [[NSArray alloc] initWithObjects:descriptor, nil]];
    
    NSError *error = nil;
    NSArray *types = [context executeFetchRequest:fetchRequest error:&error];
    
    self.recipeTypes = types;
    [self setCurrentType: self.recipe.type];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.recipeTypes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RecipeTypeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSManagedObject* recipeTypeObject = [self.recipeTypes objectAtIndex: indexPath.row];
    cell.textLabel.text = [recipeTypeObject valueForKey:@"name"];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *recipeTypeObject = [self.recipeTypes objectAtIndex: indexPath.row];
    self.recipe.type = recipeTypeObject;    
    
    [self setCurrentType:recipeTypeObject];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
