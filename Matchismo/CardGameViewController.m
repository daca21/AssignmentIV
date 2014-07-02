//
//  CardGameViewController.m
//  Matchismo
//
//  Created on 1/24/14.
// 
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"
#import "GameResult.h"
#import "GameSettings.h"

@interface CardGameViewController ()

@property (nonatomic, strong) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (strong, nonatomic) GameResult *gameResult;
@property (strong, nonatomic) GameSettings *gameSettings;

@end

@implementation CardGameViewController

- (GameResult *)gameResult
{
    if (!_gameResult) _gameResult = [[GameResult alloc] init];
    _gameResult.gameType = self.gameType;
    return _gameResult;
}

- (GameSettings *)gameSettings
{
    if (!_gameSettings) _gameSettings = [[GameSettings alloc] init];
    return _gameSettings;
}

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                  usingDeck:[self createDeck]];
        _game.matchBonus = self.gameSettings.matchBonus;
        _game.mismatchPenalty = self.gameSettings.mismatchPenalty;
        _game.flipCost = self.gameSettings.flipCost;
    }
    return _game;
}

- (Deck *)createDeck // abstract
{
    return nil;
}

- (IBAction)touchDealButton:(UIButton *)sender {
    self.game = nil;
    self.gameResult = nil;
    [self updateUI];
}

- (IBAction)touchCardButton:(UIButton *)sender
{
    NSUInteger cardIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:cardIndex];
    [self updateUI];
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        NSUInteger cardIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardIndex];
        [cardButton setAttributedTitle:[self titleForCard:card]
                              forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card]
                              forState:UIControlStateNormal];
        cardButton.enabled = !card.matched;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
    self.gameResult.score = (int) self.game.score;  // remove warning  http://stackoverflow.com/questions/16918826/objective-c-implicit-conversion-loses-integer-precision-nsuinteger-aka-unsig
}

- (NSAttributedString *)titleForCard:(Card *)card
{
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:card.chosen ? card.contents : @""];
    return title;
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.chosen ? @"cardfront" : @"cardback"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.game.matchBonus = self.gameSettings.matchBonus;
    self.game.mismatchPenalty = self.gameSettings.mismatchPenalty;
    self.game.flipCost = self.gameSettings.flipCost;
}

@end