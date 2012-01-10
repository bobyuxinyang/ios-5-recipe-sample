//
//  MetricPickerController.h
//  iOS-5-Recipes
//
//  Created by 杨裕欣 on 12-1-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MetricPickerController : NSObject<UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView* pickerView;
@property (weak, nonatomic) IBOutlet UILabel* label;

- (void) updateLabel;
@end
