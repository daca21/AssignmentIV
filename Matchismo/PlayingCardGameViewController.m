//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created 7/3/14.
//
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

- (Deck *)createDeck
{
    self.gameType = @"Playing Cards";
    return [[PlayingCardDeck alloc] init];
}

@end
