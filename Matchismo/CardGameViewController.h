//
//  CardGameViewController.h
//  Matchismo
//
//  Created  1/24/14.
//  
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


@property (strong, nonatomic) NSString *gameType;

@end
