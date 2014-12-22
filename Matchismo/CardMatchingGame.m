//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Praveen Gowda I V on 2/23/14.
//  Copyright (c) 2014 Praveen Gowda I V. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()

@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic) NSMutableArray *cards; // of Cards
@property (nonatomic) NSInteger mode;

@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) {
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
}

- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck
                          andMode:(NSInteger)mode
{
    self = [super init];
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            }
            else
            {
                self = nil;
                break;
            }
            
        }
        self.mode = mode;
    }
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? [self.cards objectAtIndex:index] : nil;
}

- (NSMutableArray *)latestChosenCards
{
    if (!_latestChosenCards) {
        _latestChosenCards = [[NSMutableArray alloc] initWithCapacity:self.mode];
    }
    return _latestChosenCards;
}

static const int MISMATCH_PENALTY = -2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = -1;

- (NSMutableArray *)otherCandidateCards
{
    NSMutableArray *otherCards;
    for (Card *card in self.cards) {
        if (card.isChosen && !card.isMatched) {
            if (!otherCards) {
                otherCards = [[NSMutableArray alloc] initWithArray:@[card]];
            }
            else
            {
                [otherCards addObject:card];
            }
        }
    }
    return otherCards;
}

- (void)chooseCardAtIndex:(NSUInteger)index
{
    [self.latestChosenCards removeAllObjects];
    self.latestScore = 0;
    Card *card = [self cardAtIndex:index];
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
        }
        else
        {
            // match against other chosen cards
            NSInteger matchscore;
            NSMutableArray *otherCards = [self otherCandidateCards];
            if (([otherCards count] == 2 && self.mode == 3) || ([otherCards count] == 1 && self.mode == 2)) {
                matchscore = [card match:otherCards];
                if (matchscore) {
                    self.latestScore = matchscore * MATCH_BONUS;
                    for (Card *otherCard in otherCards) {
                        otherCard.matched = YES;
                    }
                    card.matched = YES;
                }
                else
                {
                    self.latestScore = MISMATCH_PENALTY;
                    for (Card *otherCard in otherCards) {
                        otherCard.chosen = NO;
                    }
                }
                [self.latestChosenCards addObjectsFromArray:otherCards];
            }
            self.score += self.latestScore;
            self.score += COST_TO_CHOOSE;
            card.chosen = YES;
        }
    }
}

@end
