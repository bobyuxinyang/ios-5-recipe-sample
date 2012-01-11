//
//  RecipeDetailViewController.h
//  iOS-5-Recipes
//
//  Created by 杨裕欣 on 12-1-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"


@interface RecipeDetailViewController : UITableViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) Recipe *recipe;
@property (nonatomic, strong) NSMutableArray *ingredients;

@property (nonatomic, strong) IBOutlet UIView *tableHeaderView;
@property (nonatomic, strong) IBOutlet UIButton *photoButton;
@property (nonatomic, strong) IBOutlet UITextField *nameTextField;
@property (nonatomic, strong) IBOutlet UITextField *overviewTextField;
@property (nonatomic, strong) IBOutlet UITextField *prepTimeTextField;

- (IBAction)photoTapped;

@end
