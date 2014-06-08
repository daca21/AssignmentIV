//
//  GameResult.h
//  Matchismo
//
//  Created by dac duy nguyen on 4/20/14.
//  Copyright (c) 2014 dac duy nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameResult : NSObject

+ (NSArray *)allGameResults; // of GameResults

@property (readonly, nonatomic) NSDate *start;
@property (readonly, nonatomic) NSDate *end;
@property (readonly, nonatomic) NSTimeInterval duration;
@property (nonatomic) int score;
@property (strong, nonatomic) NSString *gameType;

- (NSComparisonResult)compareScore:(GameResult *)result;
- (NSComparisonResult)compareDuration:(GameResult *)result;
- (NSComparisonResult)compareDate:(GameResult *)result;

@end
