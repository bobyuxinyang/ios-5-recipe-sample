//
//  RecipeListTableViewController.h
//  iOS-5-Recipes
//
//  Created by 杨裕欣 on 12-1-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipeAddViewController.h"
#import "AppDelegate.h"

@class Recipe;
@class RecipeTableViewCell;

@interface RecipeListTableViewController : UITableViewController<NSFetchedResultsControllerDelegate, RecipeAddDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;


@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) UIManagedDocument *recipeDatabase;



@end
