//
//  Deck.h
//  Matchismo
//
//  Created by Praveen Gowda I V on 2/9/14.
//  Copyright (c) 2014 Praveen Gowda I V. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;
- (void)addCard:(Card *)card;

- (Card *)drawRandomCard;

@end
