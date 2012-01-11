//
//  TemperatureCell.m
//  iOS-5-Recipes
//
//  Created by 杨裕欣 on 12-1-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TemperatureCell.h"

@implementation TemperatureCell

@synthesize cLabel = _cLabel, fLabel = _fLabel, gLabel = _gLabel;

- (void)setTemperatureDataFromDictionary:(NSDictionary *)temperatureDictionary {
    // Update text in labels from the dictionary
    self.cLabel.text = [temperatureDictionary objectForKey:@"c"];
    self.fLabel.text = [temperatureDictionary objectForKey:@"f"];
    self.gLabel.text = [temperatureDictionary objectForKey:@"g"];
}

@end
