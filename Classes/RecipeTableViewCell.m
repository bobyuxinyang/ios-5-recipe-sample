//
//  RecipeTableViewCell.m
//  iOS-5-Recipes
//
//  Created by 杨裕欣 on 12-1-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RecipeTableViewCell.h"

@implementation RecipeTableViewCell
@synthesize imageView = __imageView, nameLabel = _nameLabel, overviewLabel = _overviewLabel, prepTimeLabel = _prepTimeLabel;
@synthesize recipe = _recipe;

#pragma mark -
#pragma mark Laying out subviews

#define IMAGE_SIZE          42.0
#define EDITING_INSET       10.0
#define TEXT_LEFT_MARGIN    8.0
#define TEXT_RIGHT_MARGIN   5.0
#define PREP_TIME_WIDTH     80.0

/*
 Return the frame of the various subviews -- these are dependent on the editing state of the cell.
 */
- (CGRect)_imageViewFrame {
    if (self.editing) {
        return CGRectMake(EDITING_INSET, 0.0, IMAGE_SIZE, IMAGE_SIZE);
    }
	else {
        return CGRectMake(0.0, 0.0, IMAGE_SIZE, IMAGE_SIZE);
    }
}

- (CGRect)_nameLabelFrame {
    if (self.editing) {
        return CGRectMake(IMAGE_SIZE + EDITING_INSET + TEXT_LEFT_MARGIN, 4.0, self.contentView.bounds.size.width - IMAGE_SIZE - EDITING_INSET - TEXT_LEFT_MARGIN, 16.0);
    }
	else {
        return CGRectMake(IMAGE_SIZE + TEXT_LEFT_MARGIN, 4.0, self.contentView.bounds.size.width - IMAGE_SIZE - TEXT_RIGHT_MARGIN * 2 - PREP_TIME_WIDTH, 16.0);
    }
}

- (CGRect)_descriptionLabelFrame {
    if (self.editing) {
        return CGRectMake(IMAGE_SIZE + EDITING_INSET + TEXT_LEFT_MARGIN, 22.0, self.contentView.bounds.size.width - IMAGE_SIZE - EDITING_INSET - TEXT_LEFT_MARGIN, 16.0);
    }
	else {
        return CGRectMake(IMAGE_SIZE + TEXT_LEFT_MARGIN, 22.0, self.contentView.bounds.size.width - IMAGE_SIZE - TEXT_LEFT_MARGIN, 16.0);
    }
}

- (CGRect)_prepTimeLabelFrame {
    CGRect contentViewBounds = self.contentView.bounds;
    return CGRectMake(contentViewBounds.size.width - PREP_TIME_WIDTH - TEXT_RIGHT_MARGIN, 4.0, PREP_TIME_WIDTH, 16.0);
}


/*
 To save space, the prep time label disappears during editing.
 */
- (void)layoutSubviews {
    [super layoutSubviews];
	
    [self.imageView setFrame:[self _imageViewFrame]];
    [self.nameLabel setFrame:[self _nameLabelFrame]];
    [self.overviewLabel setFrame:[self _descriptionLabelFrame]];
    [self.prepTimeLabel setFrame:[self _prepTimeLabelFrame]];
    if (self.editing) {
        self.prepTimeLabel.alpha = 0.0;
    } else {
        self.prepTimeLabel.alpha = 1.0;
    }
}



- (void)setRecipe:(Recipe *)newRecipe {
    if (newRecipe != _recipe) {
        _recipe = newRecipe;
	}
	self.imageView.image = _recipe.thumbnailImage;
	self.nameLabel.text = _recipe.name;
	self.overviewLabel.text = _recipe.overview;
	self.prepTimeLabel.text = _recipe.prepTime;
}

@end
