//
//  PlayingCard.h
//  Matchismo
//
//  Created by Praveen Gowda I V on 2/9/14.
//  Copyright (c) 2014 Praveen Gowda I V. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (nonatomic,strong) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

@end
