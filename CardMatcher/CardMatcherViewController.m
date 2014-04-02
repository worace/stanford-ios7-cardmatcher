//
//  CardMatcherViewController.m
//  CardMatcher
//
//  Created by Horace Williams on 3/19/14.
//  Copyright (c) 2014 WoracesWorkshop. All rights reserved.
//

#import "CardMatcherViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "CardMatchingGame.h"

@interface CardMatcherViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *currentGame;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UISegmentedControl *changeModeButton;
@property (strong, nonatomic) NSString *gameMode;
@end

@implementation CardMatcherViewController


- (CardMatchingGame *)currentGame
{
    if(!_currentGame) _currentGame = self.createGame;
    return _currentGame;
}

- (Deck *) createDeck {
    return [[PlayingCardDeck alloc] init];
}

- (void) resetCurrentGame {
    _currentGame = self.createGame;
}

- (NSString *)gameMode {
    if(!_gameMode) _gameMode = [CardMatchingGame matchMode2Card];
    return _gameMode;
}

- (CardMatchingGame *) createGame {
    return [[CardMatchingGame alloc] initWithMatchMode:[self gameMode]
                                             usingDeck:[self createDeck]
                                         withCardCount:[self.cardButtons count]];
}

- (IBAction)touchCardButton:(UIButton *)sender {
    
    //disable mode switching
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.currentGame chooseCardAtIndex:chosenButtonIndex];
    [self disableChangeModeButton];
    [self updateUi];
}

- (IBAction)touchNewGameButton:(UIButton *)sender {
    [self enableChangeModeButton];
    [self resetCurrentGame];
    [self updateUi];
}

- (IBAction)changeGameMode:(UISegmentedControl *)sender {
    NSString *selectedMode = [sender titleForSegmentAtIndex:sender.selectedSegmentIndex];
    if ([selectedMode isEqual: @"3-card matching"]) {
        self.currentGame.matchMode = [CardMatchingGame matchMode3Card];
    } else if ([selectedMode isEqual: @"2-card matching"]) {
        self.currentGame.matchMode = [CardMatchingGame matchMode2Card];
    } else {
        //do nothing
    }
}

- (void) updateUi {
    for (UIButton *cardButton in self.cardButtons) {
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card* card = [self.currentGame cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.currentGame.score];
    }
}

- (void) disableChangeModeButton {
    for (int i = 0; i < [self.changeModeButton numberOfSegments]; i++) {
        [self.changeModeButton setEnabled:NO forSegmentAtIndex:i];
    }
}

- (void) enableChangeModeButton {
    for (int i = 0; i < [self.changeModeButton numberOfSegments]; i++) {
        [self.changeModeButton setEnabled:YES forSegmentAtIndex:i];
    }
}

- (NSString *) titleForCard:(Card *)card {
    return card.isChosen ? card.contents : @"";
}

- (UIImage *) backgroundImageForCard:(Card *)card {
    return [UIImage imageNamed:(card.isChosen ? @"cardfront" : @"cardback")];
}


@end

