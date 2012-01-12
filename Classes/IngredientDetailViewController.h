//
//  IngredientDetail.h
//  iOS-5-Recipes
//
//  Created by 杨裕欣 on 12-1-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"
#import "Ingredient.h"

@interface IngredientDetailViewController : UITableViewController

@property (nonatomic, strong) Recipe* recipe;
@property (nonatomic, strong) Ingredient *ingredient;
- (IBAction)cancelEdit:(id)sender;
- (IBAction)saveEdit:(id)sender;

@end
