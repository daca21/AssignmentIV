//
//  CardGameViewController.m
//  Matchismo
//
//  Created by dac duy nguyen on 1/24/14.
//  Copyright (c) 2014 dac duy nguyen. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"
#import "Deck.h"
#import "HistoryViewController.h"
#import "GameResult.h"
#import "Gamesetting.h"

@interface CardGameViewController ()
@property(nonatomic, strong) CardMatchingGame *game;
@property(nonatomic, strong) Deck *deck;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
//@property (weak, nonatomic) IBOutlet UIButton *buttonDeal;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSelector;

//@property (strong,nonatomic) NSMutableArray *flipHistory;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;

@property (strong, nonatomic) GameResult *gameResult; //Assignment3 #extra2
@property (strong, nonatomic) Gamesetting *gameSettings; //Assignment3 extra #4
@end

@implementation CardGameViewController


// initialized lazily:
- ( Gamesetting *)gameSettings
{
    if(!_gameSettings ) _gameSettings = [[Gamesetting alloc] init];
    return _gameSettings;
}


//Lazy instantiated gameresult

- (GameResult *)gameResult
{
    if (!_gameResult) _gameResult = [[GameResult alloc] init];
    _gameResult.gameType  = self.gameType;
    return _gameResult;
}

- (NSMutableArray *)flipHistory
{
    if (!_flipHistory) {
        _flipHistory = [NSMutableArray array];
    }
    return _flipHistory;
}

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                  usingDeck:[self createDeck]];
        _game.matchBonus = self.gameSettings.matchBonus;
        _game.mismatchPenalty = self.gameSettings.mismatchPenalty;
        _game.flipCost = self.gameSettings.flipCost;
        [self changeModeSelector:self.modeSelector];
    }
    return _game;
}

- (Deck *)createDeck
{
    self.gameType = @"Playing Cards";
    return [[PlayingCardDeck alloc] init];
}
- (IBAction)changeSlider:(UISlider *)sender {
    int sliderValue;
    sliderValue = lroundf(self.historySlider.value);
    [self.historySlider setValue:sliderValue animated:NO];
    if ([self.flipHistory count]) {
        self.flipDescription.alpha =
        (sliderValue +1  < [self.flipHistory count]) ? 0.6 : 1.0;
        self.flipDescription.text = [self.flipHistory objectAtIndex:sliderValue];
    }
}


- (IBAction)touchCardButton:(UIButton *)sender
{

    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    self.modeSelector.enabled = NO;   //Assig2#4
    [self updateUI];

}

- (IBAction)dealButtonPressed:(id)sender {
    self.flipHistory = nil; //Ass2#extra#1
    self.game = nil;
    self.gameResult = nil;

    self.modeSelector.enabled = YES; //Ass2#4
    [self updateUI];
}
- (IBAction)changeModeSelector:(UISegmentedControl *)sender {
    self.game.maxMatchingCards = [[sender titleForSegmentAtIndex:sender.selectedSegmentIndex] integerValue];
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        int cardIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardIndex];
//        [cardButton setTitle:[self titleForCard:card]
//                    forState:UIControlStateNormal];
        [cardButton setAttributedTitle:[self titleForCard:card]
                              forState:UIControlStateNormal];
        
        [cardButton setBackgroundImage:[self backgroundImageForCard:card]
                              forState:UIControlStateNormal];
        cardButton.enabled = !card.matched;
    }
    //self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    if(self.game){
        NSString *description = @"";
        if([self.game.lastChosenCards count]){
            NSMutableArray *cardContents = [NSMutableArray array];
            for( Card *card in self.game.lastChosenCards){
                
                [cardContents addObject:card.contents];
            }
            description = [cardContents componentsJoinedByString:@""];
        }
        if (self.game.lastScore > 0) {
            description =[ NSString stringWithFormat:@"Matched %@ for %d points.",description, self.game.lastScore ];
        }else if (self.game.lastScore < 0){
            description = [NSString stringWithFormat:@"%@ don’t match! %d point penalty!", description, -self.game.lastScore];
        }
        self.flipDescription.text=description;
        
        self.flipDescription.alpha = 1;
        
        if (![description isEqualToString:@""]
            && ![[self.flipHistory lastObject] isEqualToString:description]) {
            [self.flipHistory addObject:description];
            [self setSliderRange];
        }
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score ];
    self.gameResult.score = self.game.score;
}

-(void) setSliderRange
{
    int maxValue = [ self.flipHistory count] - 1;
    self.historySlider.maximumValue = maxValue;
    [self.historySlider setValue:maxValue animated:YES ];
}

- (NSAttributedString *)titleForCard:(Card *)card
{
//    return card.chosen ? card.contents : @"";
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:card.chosen ? card.contents : @""];
    return title;

}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.chosen ? @"cardfront" : @"cardback"];
//    return [UIImage imageNamed:card.chosen ? @"setCardSelected" : @"setCard"]; //Ass3#6
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show History"]) {
        if ([segue.destinationViewController isKindOfClass:[HistoryViewController class]]) {
            [segue.destinationViewController setHistory:self.flipHistory];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.game.matchBonus = self.gameSettings.matchBonus;
    self.game.mismatchPenalty = self.gameSettings.mismatchPenalty;
    self.game.flipCost = self.gameSettings.flipCost;
}


@end
