//
//  InstructionsViewController.h
//  iOS-5-Recipes
//
//  Created by 杨裕欣 on 12-1-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"

@interface InstructionsViewController : UIViewController
@property (nonatomic, retain) Recipe *recipe;
@property (nonatomic, retain) IBOutlet UITextView *instructionsText;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@end
