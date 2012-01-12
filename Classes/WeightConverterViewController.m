//
//  WeightConverterViewController.m
//  iOS-5-Recipes
//
//  Created by 杨裕欣 on 12-1-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WeightConverterViewController.h"

@interface WeightConverterViewController()
@property (nonatomic) NSUInteger selectedUnit;
@end

@implementation WeightConverterViewController
@synthesize segmentedControl;
@synthesize pickerViewContainer;

@synthesize imperialPickerViewContainer, metricPickerViewContainer;
@synthesize imperialPickerController, metricPickerController;

@synthesize selectedUnit;

#define METRIC_INDEX 0
#define IMPERIAL_INDEX 1

- (void)viewDidLoad
{
    [self toggleUnit:self.segmentedControl];
}

- (void)viewDidUnload
{
    [self setImperialPickerController:nil];
    [self setMetricPickerController:nil];
    [self setSegmentedControl:nil];
    [self setPickerViewContainer:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)toggleUnit:(id)sender {
  
    self.selectedUnit = [segmentedControl selectedSegmentIndex];
    if (self.selectedUnit == IMPERIAL_INDEX) {
        [self.metricPickerViewContainer removeFromSuperview];
        [self.pickerViewContainer addSubview:self.imperialPickerViewContainer];
        [self.imperialPickerController updateLabel];
    } else {
        [self.imperialPickerViewContainer removeFromSuperview];
        [self.pickerViewContainer addSubview:self.metricPickerViewContainer];	
        [self.metricPickerController updateLabel];
    }
}
@end
