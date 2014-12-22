//
//  PlayingCard.m
//  Matchismo
//
//  Created by Praveen Gowda I V on 2/9/14.
//  Copyright (c) 2014 Praveen Gowda I V. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

@synthesize suit = _suit;

- (NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

+ (NSArray *)validSuits
{
    return @[@"♠️",@"♥️",@"♦️",@"♣️"];
}

+ (NSArray *)rankStrings
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+ (NSUInteger)maxRank
{
    return ([[PlayingCard rankStrings] count]-1);
}

- (int)match:(NSMutableArray *)otherCards
{
    int score = 0;
    [otherCards addObject:self];
    for (PlayingCard *otherCard in otherCards) {
        for (NSUInteger i = [otherCards indexOfObject:otherCard] + 1; i < [otherCards count]; i++) {
            PlayingCard *currentCard = [otherCards objectAtIndex:i];
            // NSLog(@"%lu%@ %lu%@", (unsigned long)otherCard.rank, otherCard.suit, (unsigned long)currentCard.rank, currentCard.suit);
            if (otherCard.rank == currentCard.rank) {
                score += 4;
            }
            if ([otherCard.suit isEqualToString:currentCard.suit]) {
                score += 1;
            }
        }
    }
    return score;
}



@end