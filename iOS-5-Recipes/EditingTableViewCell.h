//
//  EditTableCell.h
//  iOS-5-Recipes
//
//  Created by 杨裕欣 on 12-1-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditingTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *label;
@property (nonatomic, strong) IBOutlet UITextField *textField;

@end
