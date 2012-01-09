//
//  Recipe.h
//  iOS-5-Recipes
//
//  Created by 杨裕欣 on 12-1-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ImageToDataTransformer.h"

@class Ingredient;

@interface Recipe : NSManagedObject

@property (nonatomic, retain) NSString * instructions;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * overview;
@property (nonatomic, retain) NSString * prepTime;
@property (nonatomic, retain) NSSet *ingredients;
@property (nonatomic, retain) UIImage* thumbnailImage;

@property (nonatomic, retain) NSManagedObject *image;
@property (nonatomic, retain) NSManagedObject *type;
@end

@interface Recipe (CoreDataGeneratedAccessors)

- (void)addIngredientsObject:(Ingredient *)value;
- (void)removeIngredientsObject:(Ingredient *)value;
- (void)addIngredients:(NSSet *)values;
- (void)removeIngredients:(NSSet *)values;

@end
