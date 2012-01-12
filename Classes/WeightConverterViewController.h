//
//  WeightConverterViewController.h
//  iOS-5-Recipes
//
//  Created by 杨裕欣 on 12-1-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
@class ImperialPickerController, MetricPickerController;

#import <UIKit/UIKit.h>
#import "ImperialPickerController.h"
#import "MetricPickerController.h"

@interface WeightConverterViewController : UIViewController

@property (strong, nonatomic) IBOutlet MetricPickerController *metricPickerController;
@property (strong, nonatomic) IBOutlet UIView *metricPickerViewContainer;
@property (strong, nonatomic) IBOutlet ImperialPickerController *imperialPickerController;
@property (strong, nonatomic) IBOutlet UIView *imperialPickerViewContainer;


@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIView *pickerViewContainer;


- (IBAction)toggleUnit:(id)sender;

@end
