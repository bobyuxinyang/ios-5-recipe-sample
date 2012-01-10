//
//  TemperatureConverterViewController.h
//  iOS-5-Recipes
//
//  Created by 杨裕欣 on 12-1-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TemperatureConverterViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray* temperatureData;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end
