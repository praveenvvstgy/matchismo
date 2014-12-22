//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Praveen Gowda I V on 2/9/14.
//  Copyright (c) 2014 Praveen Gowda I V. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()

@property (nonatomic, strong) CardMatchingGame *game;
@property (nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *redealButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *matchModelControl;
@property (weak, nonatomic) IBOutlet UILabel *moveDescription;
@property (nonatomic) NSMutableString *descriptionLabel;
@property (nonatomic) NSMutableArray *matchHistory;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;

@end

@implementation CardGameViewController

bool HISTORY_MODE = NO;

- (NSMutableString *)descriptionLabel
{
    if (!_descriptionLabel) {
        _descriptionLabel = [[NSMutableString alloc] init];
    }
    return _descriptionLabel;
}


- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                  usingDeck:[self createDeck]
                                                    andMode:(long)[self.matchModelControl selectedSegmentIndex] + 2];
    }
    return _game;
}

- (NSMutableArray *)matchHistory
{
    if (!_matchHistory) {
        _matchHistory = [[NSMutableArray alloc] init];
        [self.matchHistory addObject:@"Touch the cards to start game"];
    }
    return _matchHistory;
}

/**
 *  Create a playing card Deck
 *
 *  @return a deck of playing cards
 */
- (Deck *)createDeck
{
    return [PlayingDeck new];
}


- (IBAction)browseHistoryOnSliding:(UISlider *)sender
{
    HISTORY_MODE = YES;
    if (sender.value < [self.matchHistory count]) {
        self.moveDescription.text = [self.matchHistory objectAtIndex:sender.value];
    }
    else
    {
        HISTORY_MODE = NO;
    }
    [self setDescriptionColor];
}

- (void)setDescriptionColor
{
    if (HISTORY_MODE) {
        [self.moveDescription setAlpha:0.5];
    }
    else
    {
        [self.moveDescription setAlpha:1];
    }
}

/**
 *  The method is called when a card button is touched
 *  The game mode segment controller is disabled
 *  game logic for the card that was clicked is applied and the UI is updated
 *
 *  @param sender the card button that was touched
 */
- (IBAction)touchCardButton:(UIButton*)sender {
    self.matchModelControl.enabled = NO;
    NSUInteger chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    HISTORY_MODE = NO;
    [self updateUI];
}
/**
 *  When the game mode is changed, the game is released
 *
 *  @param sender game mode choser segment control
 */
- (IBAction)modeChanged:(UISegmentedControl *)sender {
    self.game = nil;
}

/**
 *  When the redeal button is clicked
 *  Exisitng game is released
 *  The game mode segment control is enabled
 
 *
 *  @param sender redeal button
 */
- (IBAction)touchRedealButton:(UIButton *)sender {
    self.game = nil;
    self.matchModelControl.enabled = YES;
    self.matchHistory = nil;
    HISTORY_MODE = NO;
    [self updateUI];
}

/**
 *  Update the UI
 */
- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        NSUInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[self titleForCard:card]
                    forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card]
                              forState:UIControlStateNormal];
        cardButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        cardButton.enabled = !card.isMatched;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
    
    self.descriptionLabel = nil;
    [self generateDescription];
    [self updateSlider];
    [self setDescriptionColor];
}

/**
 *  Generate description of the result of the last card touch
 */
- (void)generateDescription
{
    if (self.game.latestScore < 0) {
        for (Card *card in self.game.latestChosenCards) {
            [self.descriptionLabel appendString:card.contents];
        }
        [self.descriptionLabel appendFormat:@"don't match! %ld penalty!", (long)self.game.latestScore];
        self.moveDescription.text = self.descriptionLabel;
    }
    else if (self.game.latestScore > 0) {
        [self.descriptionLabel appendString:@"Matched "];
        for (Card *card in self.game.latestChosenCards) {
            [self.descriptionLabel appendString:card.contents];
        }
        [self.descriptionLabel appendFormat:@"for %ld points!", (long)self.game.latestScore];
        self.moveDescription.text = self.descriptionLabel;
    }
    /**
     *  add description to history only if the last move resulted in a score change
     */
    if (self.game.latestScore != 0)
    {
        [self.matchHistory addObject:self.descriptionLabel];
        [self updateSlider];
    }
}


- (void)updateSlider
{
    if ([self.matchHistory count] == 1) {
        self.historySlider.enabled = NO;
        self.moveDescription.text = @"Touch the cards to start game";
    }
    else
    {
        self.historySlider.enabled = YES;
    }
    self.historySlider.value =  self.historySlider.maximumValue = [self.matchHistory count];
}

/**
 *  Determine title of the card button.
 *  The title is the card contents is it is chosen, otherwise an empty string
 *
 *  @param card card whose title needs to be determined
 *
 *  @return string which is the title of the card
 */
- (NSString *)titleForCard:(Card *)card
{
    return (card.isChosen) ? card.contents : @"";
}


/**
 *  Determine the background image for the card UIButton, depending on whether the card is chosen or not
 *
 *  @param card card whose background image is to be determined
 *
 *  @return image to be set as background image of the card
 */
- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:(card.isChosen) ? @"cardfront" : @"cardback"];
}




@end
