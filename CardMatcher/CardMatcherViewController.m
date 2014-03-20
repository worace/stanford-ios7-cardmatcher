//
//  CardMatcherViewController.m
//  CardMatcher
//
//  Created by Horace Williams on 3/19/14.
//  Copyright (c) 2014 WoracesWorkshop. All rights reserved.
//

#import "CardMatcherViewController.h"

@interface CardMatcherViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@end

@implementation CardMatcherViewController

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
    NSLog(@"flipCount changed to %d", self.flipCount);
}

- (IBAction)touchCardButton:(UIButton *)sender {
    if ([sender.currentTitle length]){
        [sender setBackgroundImage:[UIImage imageNamed:@"cardback"]
                          forState:UIControlStateNormal];
        [sender setTitle:@"" forState:UIControlStateNormal];
    } else {
        [sender setTitle:@"A♣" forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"cardfront"]
                          forState:UIControlStateNormal];

    }
    self.flipCount ++;
}

@end
