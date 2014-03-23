//
//  GDExpandableView.h
//  GoDish
//
//  Created by Andres on 11/12/13.
//  Copyright (c) 2014 Andres. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACExpandableDescription : UIControl

@property(readonly) BOOL expanded;
@property(readonly) float heightDifference;
@property(nonatomic) float marginTop;
@property(nonatomic) float marginBetween;
@property(nonatomic) float marginSides;
@property(nonatomic) float animationTime;
@property(nonatomic,strong) NSDictionary * titleAttributes;
@property(nonatomic,strong) NSDictionary * descriptionAttributes;
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *description;
@property(nonatomic,strong) id delegate;

- (CGRect) getOriginalSize;
- (CGRect) getExpandedSize;
- (CGRect) setTitleText:(NSString *)title setContentText:(NSString *) content;
@end
