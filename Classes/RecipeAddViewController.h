//
//  RecipeAddViewController.h
//  iOS-5-Recipes
//
//  Created by 杨裕欣 on 12-1-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"

@class RecipeAddViewController;

@protocol RecipeAddDelegate <NSObject>
- (void)recipeAddViewController:(RecipeAddViewController *)recipeAddViewController didAddRecipe: (Recipe*) recipe;
@end

@interface RecipeAddViewController : UIViewController
@property (nonatomic, strong) Recipe* recipe;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (nonatomic, strong) id<RecipeAddDelegate> delegate;
@end


