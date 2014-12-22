//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Praveen Gowda I V on 2/23/14.
//  Copyright (c) 2014 Praveen Gowda I V. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"

@interface CardMatchingGame : NSObject

// designated initializer
- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck andMode:(NSInteger)mode;
- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic) NSMutableArray *latestChosenCards;
@property (nonatomic) NSInteger latestScore;

@end
