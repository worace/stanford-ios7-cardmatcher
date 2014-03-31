//
//  CardMatchingGame.m
//  CardMatcher
//
//  Created by Horace Williams on 3/19/14.
//  Copyright (c) 2014 WoracesWorkshop. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards;
@end

@implementation CardMatchingGame

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;

+ (NSString *)matchMode2Card {
    return @"match_mode_2_card";
}

+ (NSString *)matchMode3Card {
    return @"match_mode_3_card";
}

+ (NSArray *)validMatchModes {
    return @[[self matchMode2Card], [self matchMode3Card]];
}

- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck
{
    return [self initWithMatchMode:[CardMatchingGame matchMode2Card]
                         usingDeck:deck
                     withCardCount:count];
}

- (instancetype)initWithMatchMode:(NSString *)matchMode
                        usingDeck:(Deck *)deck
                    withCardCount:(NSInteger)count
{
    self = [super init];
    if ([[CardMatchingGame validMatchModes] containsObject:matchMode]) {
        self.matchMode = matchMode;
    } else {
        self.matchMode = [CardMatchingGame matchMode2Card];
    }
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
        }
    }
    return self;
}

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return  (index < [self.cards count] + 1) ? [self.cards objectAtIndex:index] : nil;
}

- (BOOL) chosenCardCountMeetsMatchingThreshold {
    return [self chosenCardCount] >= [self cardMatchingThreshold];
}

- (NSInteger) chosenCardCount {
    return [[self chosenCards] count];
}

- (NSArray *) chosenCards {
    NSMutableArray *chosenCards = [[NSMutableArray alloc] init];
    for (Card *card in self.cards) {
        if(card.isChosen) {
            [chosenCards addObject:card];
        }
    }
//    return [[self.cards copy] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat: @"isChosen == NO"]];
    return [chosenCards copy];
}

- (NSArray *) chosenAvailableCards {
    NSMutableArray *available = [[NSMutableArray alloc] init];
    for (Card *card in [self chosenCards]) {
        if(card.isMatched) {
            [available addObject:card];
        }
    }
    return [available copy];
//    return [[[self chosenCards] copy] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat: @"isMatched == YES"]];

}

- (NSInteger) cardMatchingThreshold {
    int value = [[@{[CardMatchingGame matchMode3Card]: @3, [CardMatchingGame matchMode2Card ]: @2} objectForKey:self.matchMode] intValue];
    if (value) {
        return value;
    } else {
        return 2;
    }
}

- (void)chooseCardAtIndex:(NSUInteger)index
{
    Card *chosenCard = [self cardAtIndex:index];

    if (!chosenCard.isMatched) {
        if (chosenCard.isChosen) {
            chosenCard.chosen = NO;
        } else {
            chosenCard.chosen = YES;
//            if ([self chosenCardCountMeetsMatchingThreshold]) {
                for (Card *otherCard in self.cards) {
                    if (otherCard.isChosen && !otherCard.isMatched && [self chosenCardCountMeetsMatchingThreshold]) {
                        int matchScore = [chosenCard match:@[otherCard]];
                        if (matchScore) {
                            self.score += matchScore * MATCH_BONUS;
                            otherCard.matched = YES;
                            chosenCard.matched = YES;
                        } else {
                            self.score -= MISMATCH_PENALTY;
                            otherCard.chosen = NO;
                        }
                        break;
                    }
                }
//            }
        }
    }

}

@end
