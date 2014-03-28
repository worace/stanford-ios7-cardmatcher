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
@property (strong, nonatomic) CardMatchingGame *cardGame;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@end

@implementation CardMatcherViewController


- (CardMatchingGame *)cardGame
{
    if(!_cardGame) _cardGame = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                                 usingDeck:self.createDeck];
    return _cardGame;
}

- (Deck *) createDeck {
    return [[PlayingCardDeck alloc] init];
}

- (IBAction)touchCardButton:(UIButton *)sender {
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.cardGame chooseCardAtIndex:chosenButtonIndex];
    [self updateUi];
}

- (void) updateUi {
    for (UIButton *cardButton in self.cardButtons) {
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card* card = [self.cardGame cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.cardGame.score];
    }
}

- (NSString *) titleForCard:(Card *)card {
    return card.isChosen ? card.contents : @"";
}

- (UIImage *) backgroundImageForCard:(Card *)card {
    return [UIImage imageNamed:(card.isChosen ? @"cardfront" : @"cardback")];
}


@end

