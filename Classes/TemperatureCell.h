//
//  TemperatureCell.h
//  iOS-5-Recipes
//
//  Created by 杨裕欣 on 12-1-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TemperatureCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *cLabel;
@property (strong, nonatomic) IBOutlet UILabel *fLabel;
@property (strong, nonatomic) IBOutlet UILabel *gLabel;

- (void)setTemperatureDataFromDictionary:(NSDictionary *)temperatureDictionary;

@end
