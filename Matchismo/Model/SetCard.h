//
//  SetCard.h
//  Matchismo
//
//  Created by dac duy nguyen on 4/19/14.
//  Copyright (c) 2014 dac duy nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface SetCard : Card

@property (strong, nonatomic) NSString *color;
@property (strong, nonatomic) NSString *symbol;
@property (strong, nonatomic) NSString *shading;
@property (nonatomic) NSUInteger number;

+ (NSArray *)validColors;
+ (NSArray *)validSymbols;
+ (NSArray *)validShadings;
+ (NSUInteger)maxNumber;
+ (NSArray *)cardsFromText:(NSString *)text;

@end
