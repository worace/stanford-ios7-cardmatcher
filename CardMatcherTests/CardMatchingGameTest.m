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

@end
