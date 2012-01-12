//
//  RecipePhotoViewController.h
//  iOS-5-Recipes
//
//  Created by 杨裕欣 on 12-1-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"

@interface RecipePhotoViewController : UIViewController

@property (nonatomic, strong) Recipe *recipe;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
