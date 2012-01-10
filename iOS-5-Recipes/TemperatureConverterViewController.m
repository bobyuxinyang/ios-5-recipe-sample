//
//  TemperatureConverterViewController.m
//  iOS-5-Recipes
//
//  Created by 杨裕欣 on 12-1-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TemperatureConverterViewController.h"
#import "TemperatureCell.h"

@implementation TemperatureConverterViewController

@synthesize tableView;
@synthesize temperatureData = _temperatureData;

#pragma mark - Properties

- (NSArray *)temperatureData {
    if (_temperatureData == nil) {
        NSString *temperatureDataPath = [[NSBundle mainBundle] pathForResource:@"TemperatureData" ofType:@"plist"];
        NSArray *array = [[NSArray alloc] initWithContentsOfFile:temperatureDataPath];
        _temperatureData = array;
    }
    return _temperatureData;
}

#pragma mark - Self

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark - TableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.temperatureData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TemperatureCellIdentifier = @"TemperatureCell";
    
    TemperatureCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TemperatureCellIdentifier];
    if (cell == nil) {
        cell = [[TemperatureCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TemperatureCellIdentifier];
    }
    
    [cell setTemperatureDataFromDictionary: [self.temperatureData objectAtIndex:indexPath.row]];
    
    return cell;
}



@end
