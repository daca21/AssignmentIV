//
//  SettingsGameViewController.m
//  Matchismo
//
//  Created by dac duy nguyen on 4/21/14.
//  Copyright (c) 2014 dac duy nguyen. All rights reserved.
//

#import "SettingsGameViewController.h"
#import "Gamesetting.h"

@interface SettingsGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *matchBonusLabel;
@property (weak, nonatomic) IBOutlet UILabel *mismatchPenalityLabel;
@property (weak, nonatomic) IBOutlet UILabel *flipcostLabel;
@property (weak, nonatomic) IBOutlet UISlider *matchBonusSlider;
@property (weak, nonatomic) IBOutlet UISlider *mismatchPenalitySlider;
@property (weak, nonatomic) IBOutlet UISlider *flipcostSlider;

@property(strong,nonatomic) Gamesetting *gameSettings;

@end

@implementation SettingsGameViewController


-(Gamesetting *)gameSettings
{
    if(!_gameSettings) _gameSettings = [[Gamesetting alloc] init];
     return _gameSettings ;
}


-(void)setLabel:(UILabel *)label forSlider:(UISlider *)slider
{
    int sliderValue;
    sliderValue = lround(slider.value);
    [slider setValue:sliderValue animated:NO];
    label.text = [NSString stringWithFormat:@"%d",sliderValue];
}

- (IBAction)matchBonusSliderChanged:(UISlider *)sender {
    [self setLabel:self.matchBonusLabel forSlider:sender ];
    self.gameSettings.matchBonus = floor(sender.value);
}


- (IBAction)mismatchPenalitySliderChanged:(UISlider *)sender {
    [self setLabel:self.mismatchPenalityLabel forSlider:sender];
    self.gameSettings.mismatchPenalty = floor(sender.value);
}

- (IBAction)flipcostSliderChanged:(UISlider *)sender {
    [self setLabel:self.flipcostLabel forSlider:sender];
    self.gameSettings.flipCost = floor(sender.value);
}


-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.matchBonusSlider.value = self.gameSettings.matchBonus;
    self.mismatchPenalitySlider.value = self.gameSettings.mismatchPenalty;
    self.flipcostSlider.value = self.gameSettings.flipCost;
    [self setLabel:self.matchBonusLabel forSlider:self.matchBonusSlider];
    [self setLabel:self.mismatchPenalityLabel forSlider:self.mismatchPenalitySlider];
    [self setLabel:self.flipcostLabel forSlider:self.flipcostSlider];
}

@end
