//
//  CardGameViewController.h
//  Matchismo
//
//  Created by dac duy nguyen on 1/24/14.
//  Copyright (c) 2014 dac duy nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"

@interface CardGameViewController : UIViewController


// protected
// for subclasses
- (Deck *)createDeck; // abstract

- (NSAttributedString *)titleForCard:(Card *)card;
- (UIImage *)backgroundImageForCard:(Card *)card;
- (void)updateUI;

@property (weak, nonatomic) IBOutlet UILabel *flipDescription;
@property (strong, nonatomic) NSMutableArray *flipHistory; // of NSStrings
@property (strong, nonatomic) NSString *gameType;

@end
