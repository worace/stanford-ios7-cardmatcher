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

- (CardMatchingGame *) createGame {
    return [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                             usingDeck:self.createDeck];}

- (IBAction)touchCardButton:(UIButton *)sender {
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.currentGame chooseCardAtIndex:chosenButtonIndex];
    [self updateUi];
}

- (IBAction)touchNewGameButton:(UIButton *)sender {
    [self resetCurrentGame];
    [self updateUi];
}

- (IBAction)changeGameMode:(UISegmentedControl *)sender {
    NSLog(@"updated game mode to %@", [sender titleForSegmentAtIndex:sender.selectedSegmentIndex]);
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

- (NSString *) titleForCard:(Card *)card {
    return card.isChosen ? card.contents : @"";
}

- (UIImage *) backgroundImageForCard:(Card *)card {
    return [UIImage imageNamed:(card.isChosen ? @"cardfront" : @"cardback")];
}


@end

