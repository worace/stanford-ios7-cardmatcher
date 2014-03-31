//
//  CardMatchingGame.h
//  CardMatcher
//
//  Created by Horace Williams on 3/19/14.
//  Copyright (c) 2014 WoracesWorkshop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "Deck.h"

@interface CardMatchingGame : NSObject

//designated initializer
- (instancetype) initWithCardCount:(NSUInteger)count
                         usingDeck:(Deck *)deck;

- (instancetype) initWithMatchMode:(NSString *)matchMode
                         usingDeck:(Deck *)deck
                         withCardCount:(NSInteger)count;

- (void) chooseCardAtIndex:(NSUInteger)index;
- (Card *) cardAtIndex:(NSUInteger)index;
- (NSInteger) chosenCardCount;
- (NSInteger) cardMatchingThreshold;
+ (NSString *)matchMode2Card;
+ (NSString *)matchMode3Card;

@property(nonatomic, readonly) NSInteger score;
@property(strong, nonatomic) NSString *matchMode;

@end
