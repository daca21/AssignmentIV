//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Martin Mandl on 06.11.13.
//  Copyright (c) 2013 m2m server software gmbh. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()

@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards; // of Card


@property (nonatomic, strong) NSArray *lastChosenCards;
@property (nonatomic, readwrite) NSInteger lastScore;

@end

@implementation CardMatchingGame

- (NSMutableArray *)cards {
    if (!_cards) {
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
}

- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
            _matchBonus = MATCH_BONUS;
            _mismatchPenalty = MISMATCH_PENALTY;
            _flipCost = COST_TO_CHOOSE;
        }
    }
    
    return self;
}

//#define MISMATCH_PENALTY 2
static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

- (void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
      }
//            else {
//            // match against another card
//            for (Card *otherCard in self.cards) {
//                if (otherCard.isChosen && !otherCard.isMatched) {
//                    int matchScore = [card match:@[otherCard]];
//                    if (matchScore) {
//                        self.score += matchScore * MATCH_BONUS;
//                        card.matched = YES;
//                        otherCard.matched = YES;
//                    } else {
//                        self.score -= MISMATCH_PENALTY;
//                        otherCard.chosen = NO;
//                    }
//                    break;
//                }
//            }
//            self.score -= COST_TO_CHOOSE;
//            card.chosen = YES;
//        }
            else {
                //matched against another card ( 3cards)
                NSMutableArray *otherCards = [NSMutableArray array];
                self.lastScore = 0;
                self.lastChosenCards = [otherCards arrayByAddingObject:card ];

                for (Card *otherCard in self.cards) {
                    if (otherCard.isChosen && !otherCard.isMatched) {
                        [otherCards addObject:otherCard];
                    }
                }
                if ([otherCards count] + 1 == self.maxMatchingCards) {
                    int matchScore = [card match:otherCards];
                    if (matchScore) {
//                        self.score += matchScore * MATCH_BONUS;
                        self.lastScore += matchScore * self.matchBonus;
                        card.matched = YES;
                        for (Card *otherCard in otherCards) {
                            otherCard.matched = YES;
                        }
                    } else {
                        //self.score -= MISMATCH_PENALTY;
                        self.lastScore = - self.mismatchPenalty;
                        for (Card *otherCard in otherCards) {
                            otherCard.chosen = NO;
                        }
                    }
                }
            }
            self.score += self.lastScore - self.flipCost; //Assignment#3 extra#4
            card.chosen = YES;
    }
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}


- (NSUInteger)maxMatchingCards
{
    if (_maxMatchingCards < 2) {
        _maxMatchingCards = 2;
    }
    return _maxMatchingCards;
}

@end
