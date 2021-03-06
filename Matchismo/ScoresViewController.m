//
//  ScoresViewController.m
//  Matchismo
//
//  Created 4/20/14.
// s
//

#import "ScoresViewController.h"
#import "GameResult.h"

@interface ScoresViewController ()

@property (weak, nonatomic) IBOutlet UITextView *scoresTextView;
@property (strong, nonatomic) NSArray *scores;
@end

@implementation ScoresViewController

- (NSString *)stringFromResult:(GameResult *)result
{
    return [NSString stringWithFormat:@"%@: %d, (%@, %gs)\n",
            result.gameType,
            result.score,
            [NSDateFormatter localizedStringFromDate:result.end
                                           dateStyle:NSDateFormatterShortStyle
                                           timeStyle:NSDateFormatterShortStyle],
            round(result.duration)];
}

- (void)changeScore:(GameResult *)result toColor:(UIColor *)color
{
    NSRange range = [self.scoresTextView.text rangeOfString:[self stringFromResult:result]];
    [self.scoresTextView.textStorage addAttribute:NSForegroundColorAttributeName
                                            value:color
                                            range:range];
}

- (void)updateUI
{
    NSString *text = @"";
    for (GameResult *result in self.scores) {
        text = [text stringByAppendingString:[self stringFromResult:result]];
    }
    self.scoresTextView.text = text;
    
    NSArray *sortedScores = [self.scores sortedArrayUsingSelector:@selector(compareScore:)];
    [self changeScore:[sortedScores firstObject] toColor:[UIColor redColor]];
    [self changeScore:[sortedScores lastObject] toColor:[UIColor greenColor]];
    sortedScores = [self.scores sortedArrayUsingSelector:@selector(compareDuration:)];
    [self changeScore:[sortedScores firstObject] toColor:[UIColor purpleColor]];
    [self changeScore:[sortedScores lastObject] toColor:[UIColor blueColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.scores = [GameResult allGameResults];
    [self updateUI];
}

- (IBAction)sortByDate {
    self.scores = [self.scores sortedArrayUsingSelector:@selector(compareDate:)];
    
}
- (IBAction)sortByScore {
    self.scores = [self.scores sortedArrayUsingSelector:@selector(compareScore:)];
    [self updateUI];
}
- (IBAction)sortByDuration {
    self.scores = [self.scores sortedArrayUsingSelector:@selector(compareDuration:)];
    [self updateUI]; // Ass3 extra Tache 3
}




@end
