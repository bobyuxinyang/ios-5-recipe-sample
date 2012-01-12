//
//  RecipeTableViewCell.h
//  iOS-5-Recipes
//
//  Created by 杨裕欣 on 12-1-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Recipe.h"

@interface RecipeTableViewCell : UITableViewCell

@property (nonatomic, strong) Recipe *recipe;

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *overviewLabel;
@property (nonatomic, strong) IBOutlet UILabel *prepTimeLabel;

@end
