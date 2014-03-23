//
//  ACMainViewController.m
//  ExpandableDescriptionExample
//
//  Created by Andres on 3/15/14.
//  Copyright (c) 2014 Andres. All rights reserved.
//

#import "ACMainViewController.h"
#import "ACExpandableDescription.h"

@interface ACMainViewController ()


@property (weak, nonatomic) IBOutlet ACExpandableDescription *expandableDescription;
@property (weak, nonatomic) IBOutlet UIView *otherContent;

@end

@implementation ACMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_expandableDescription setTitle:@"What do you call a male adult elephant? And an adult female? What about a baby?"];
        [_expandableDescription setDescription:@"Elephants have little in common with cattle, but they share with them the names for adult male (bull), adult female (cow) and juvenile (calf). Even their collective noun is the same: a herd of elephants."];
        
        CGRect frame = [_expandableDescription getOriginalSize];
        [_otherContent setFrame:CGRectMake(_otherContent.frame.origin.x, frame.origin.y + frame.size.height + 5, _otherContent.frame.size.width, _otherContent.frame.size.height)];
    });
}
- (IBAction)expandStarted:(id)sender {
    [UIView animateWithDuration:_expandableDescription.animationTime animations:^{
        [_otherContent setFrame:CGRectMake(_otherContent.frame.origin.x, _otherContent.frame.origin.y + [_expandableDescription heightDifference], _otherContent.frame.size.width, _otherContent.frame.size.height)];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
