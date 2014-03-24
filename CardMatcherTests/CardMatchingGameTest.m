//
//  CardMatchingGameTest.m
//  CardMatcher
//
//  Created by Horace Williams on 3/19/14.
//  Copyright (c) 2014 WoracesWorkshop. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Card.h"
#import "Deck.h"
#import "CardMatchingGame.h"

@interface CardMatchingGameTest : XCTestCase
@property (nonatomic, strong) Card *testCard;
@property (nonatomic, strong) Deck *testDeck;
//@property(nonatomic, strong) CardMatchingGame *testGame;
@end

@implementation CardMatchingGameTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.testCard = [[Card alloc] init];
    self.testCard.contents = @"testCard";
    self.testCard.matched = NO;
    self.testDeck = [[Deck alloc] init];
    [self.testDeck addCard:self.testCard];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
}

- (void)testWillNotInitForEmptyDeck
{
    Deck *emptyDeck = [[Deck alloc] init];
    CardMatchingGame *testGame = [[CardMatchingGame alloc] initWithCardCount:1
                                                                   usingDeck:emptyDeck];
    XCTAssertNil(testGame);
    
}

- (void)testInitWithCardCountAllowsChoosingCardFromProvidedDeck
{
    CardMatchingGame *testGame = [[CardMatchingGame alloc] initWithCardCount:1
                                                                   usingDeck:self.testDeck];
    XCTAssertEqualObjects(self.testCard, [testGame cardAtIndex:0]);
}

- (void)testCardAtIndexGivesNilForIndexLargerThanDeck
{
    CardMatchingGame *testGame = [[CardMatchingGame alloc] initWithCardCount:1
                                                                   usingDeck:self.testDeck];
    XCTAssertNil([testGame cardAtIndex:4]);
}

- (void)testChooseCardAtIndexUnchoosesAChosenCard {
    CardMatchingGame *testGame = [[CardMatchingGame alloc] initWithCardCount:1
                                                                   usingDeck:self.testDeck];
    [testGame cardAtIndex:0].chosen = YES;
    [testGame chooseCardAtIndex:0];
    XCTAssertEqual([testGame cardAtIndex:0].isChosen, NO);
}

- (void)testChooseCardAtIndexChoosesTheCard {
    CardMatchingGame *testGame = [[CardMatchingGame alloc] initWithCardCount:1
                                                                   usingDeck:self.testDeck];
    [testGame cardAtIndex:0].chosen = NO;
    [testGame chooseCardAtIndex:0];
    XCTAssertEqual([testGame cardAtIndex:0].isChosen, YES);
}

- (void)testChooseCardAtIndexPassesOvermatchedCard {
    CardMatchingGame *testGame = [[CardMatchingGame alloc] initWithCardCount:1
                                                                   usingDeck:self.testDeck];
    [testGame cardAtIndex:0].chosen = YES;
    [testGame cardAtIndex:0].matched = YES;
    [testGame chooseCardAtIndex:0];
    XCTAssertEqual([testGame cardAtIndex:0].isChosen, YES);
}

- (void)testChooseCardAtIndexIgnoresMatchingUnchosenCards {
    Card *secondCard = [[Card alloc] init];
    secondCard.contents = self.testCard.contents;
    secondCard.chosen = NO;
    [self.testDeck addCard:secondCard];
    CardMatchingGame *testGame = [[CardMatchingGame alloc] initWithCardCount:2
                                                                   usingDeck:self.testDeck];
    
    [testGame chooseCardAtIndex:0];
    XCTAssertEqual(testGame.score, 0);
}

- (void)testChooseCardAtIndexGivesScoreBonusForMatchingChosenCards {
    Card *firstCard = [[Card alloc] init];
    Card *secondCard = [[Card alloc] init];
    firstCard.contents = @"a card";
    secondCard.contents = @"a card";
    
    Deck *deck = [[Deck alloc] init];
    [deck addCard:firstCard];
    [deck addCard:secondCard];
    CardMatchingGame *testGame = [[CardMatchingGame alloc] initWithCardCount:2
                                                                   usingDeck:deck];
    [testGame chooseCardAtIndex:0]; //choose one card so our subsequent choice can match it
    [testGame chooseCardAtIndex:1];

    XCTAssertTrue(testGame.score > 0);
}

- (void)testChooseCardAtIndexUpdatesMatchStatusForChosenMatchingCards {
    Card *firstCard = [[Card alloc] init];
    Card *secondCard = [[Card alloc] init];
    firstCard.contents = @"same contents";
    secondCard.contents = @"same contents";

    Deck *deck = [[Deck alloc] init];
    [deck addCard:firstCard];
    [deck addCard:secondCard];
    
    CardMatchingGame *testGame = [[CardMatchingGame alloc] initWithCardCount:2
                                                                   usingDeck:deck];
    
    [testGame chooseCardAtIndex:0]; //choose one card so our subsequent choice can match it
    [testGame chooseCardAtIndex:1];
    
    XCTAssertTrue(testGame.score > 0);

    XCTAssertEqual(firstCard.isMatched, YES);
    XCTAssertEqual(secondCard.isMatched, YES);
}

- (void)testChooseCardAtDecreasesScoreForMisMatch {
    Card *firstCard = [[Card alloc] init];
    Card *secondCard = [[Card alloc] init];
    firstCard.contents = @"a card";
    secondCard.contents = @"a different card";
    
    Deck *deck = [[Deck alloc] init];
    [deck addCard:firstCard];
    [deck addCard:secondCard];
    
    CardMatchingGame *testGame = [[CardMatchingGame alloc] initWithCardCount:2
                                                                   usingDeck:deck];
    
    [testGame chooseCardAtIndex:0]; //choose one card so our subsequent choice can match it
    [testGame chooseCardAtIndex:1];
    XCTAssertTrue(testGame.score < 0);
}

- (void)testChooseCardAtUnChoosesMisMatchedCard {
    Card *firstCard = [[Card alloc] init];
    Card *secondCard = [[Card alloc] init];
    firstCard.contents = @"a card";
    secondCard.contents = @"a different card";
    
    Deck *deck = [[Deck alloc] init];
    [deck addCard:firstCard];
    [deck addCard:secondCard];
    
    CardMatchingGame *testGame = [[CardMatchingGame alloc] initWithCardCount:2
                                                                   usingDeck:deck];
    
    [testGame chooseCardAtIndex:0]; //choose one card so our subsequent choice can match it
    [testGame chooseCardAtIndex:1];
    // first card gets flips back, second one stays up
    XCTAssertFalse([testGame cardAtIndex:0].isChosen);
    XCTAssertTrue([testGame cardAtIndex:1].isChosen);
}

@end
