//
//  GDExpandableView.m
//  GoDish
//
//  Created by Andres on 11/12/13.
//  Copyright (c) 2014 Andres. All rights reserved.
//

#import "ACExpandableDescription.h"

@interface ACExpandableDescription ()
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *descriptionLabel;
@property (nonatomic,strong) UIImageView *arrowDown;
@property (nonatomic,strong) UIView *arrowDownContainer;
@property float width;
@property CGRect originalSize;
@property CGRect expandedSize;

@property CGRect arrowDownContainerOriginalFrame;
@property CGRect arrowDownContainerExpandedFrame;
@end

float kDefaultMargin = 10.0f;
float kMarginBetween = 10.0f;


@implementation ACExpandableDescription


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self)
    {   [self initialize];
    }
    
    return self;
}

- (id) init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void) initialize{
    _expanded = NO;
    _marginBetween = kMarginBetween;
    _marginSides = _marginTop = kDefaultMargin;
    _arrowDown = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_down"]];
    [_arrowDown setFrame:CGRectMake(0, 0, 14, 8)];
    _width = self.frame.size.width - 2 * _marginSides;
    
    _titleAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]};
    _descriptionAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]};
    
    _titleLabel = [[UILabel alloc] init];
    [_titleLabel setNumberOfLines:0];
    [_titleLabel setFont:_titleAttributes[NSFontAttributeName]];
    [self addSubview:_titleLabel];
    
    _descriptionLabel = [[UILabel alloc] init];
    [_descriptionLabel setNumberOfLines:0];
    [_descriptionLabel setFont:_descriptionAttributes[NSFontAttributeName]];
    [self addSubview:_descriptionLabel];
    
    _arrowDownContainer = [[UIView alloc] init];
    [_arrowDownContainer setBackgroundColor:[UIColor whiteColor]];
    [_arrowDownContainer addSubview:self.arrowDown];
    
    _animationTime = 0.5f;
    
    [self setClipsToBounds:YES];
}

- (CGRect) setTitleText:(NSString *)title setContentText:(NSString *) content{
    _title = title;
    _description = content;
    
    return [self resizeViews];
}

- (void) setTitle:(NSString *)title{
    _title = title;
    [self resizeViews];
}

- (void) setDescription:(NSString *)description{
    _description = description;
    [self resizeViews];
}

- (CGRect) resizeViews{
//    [self setBackgroundColor:[UIColor redColor]];
//    [_titleLabel setBackgroundColor:[UIColor cyanColor]];
//    [_descriptionLabel setBackgroundColor:[UIColor greenColor]];
    
    CGRect sizeToShow;
    
    CGSize titleSize = [self getSizeFrom:_title
                          withAttributes:_titleAttributes
                       andAvailableSpace:CGSizeMake(_width, 1000.0f)];
    
    CGSize contentSize = [self getSizeFrom:_description
                            withAttributes:_descriptionAttributes
                         andAvailableSpace:CGSizeMake(_width, 1000.0f)];
    
    [_titleLabel setFrame:CGRectMake(_marginSides, _marginTop, _width, titleSize.height)];
    [_titleLabel setText:_title];
    
    
    sizeToShow = CGRectMake(self.frame.origin.x,
                            self.frame.origin.y,
                            self.frame.size.width,
                            _titleLabel.frame.origin.y + _titleLabel.frame.size.height + _marginBetween);

    float originalYPositionForArrowContainer = _titleLabel.frame.origin.y +
                                               _titleLabel.frame.size.height;
    
    if (contentSize.height > 0 && _description.length > 0) {
        float yPositionForSubtitle = _titleLabel.frame.origin.y +
                                     _titleLabel.frame.size.height +
                                     _marginBetween;
        
        [_descriptionLabel setFrame:CGRectMake(_marginSides,
                                               yPositionForSubtitle,
                                               _width,
                                               contentSize.height)];
        
        [_descriptionLabel setText:_description];
        [_arrowDownContainer setFrame:CGRectMake(0,
                                                 originalYPositionForArrowContainer,
                                                 self.frame.size.width,
                                                 20)];
        
        [_arrowDown setCenter:CGPointMake(_arrowDownContainer.frame.size.width/2,
                                          _arrowDownContainer.frame.size.height/2)];
        
        [self addSubview:_arrowDownContainer];
        
        sizeToShow = CGRectMake(self.frame.origin.x,
                                self.frame.origin.y,
                                self.frame.size.width,
                                _titleLabel.frame.origin.y + _titleLabel.frame.size.height + _arrowDownContainer.frame.size.height);
    
    }else if (_title.length == 0 && _description.length == 0){
        sizeToShow = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 0);
    }
    
    [self setFrame:sizeToShow];

    
    float totalHeightToShow = _titleLabel.frame.origin.y +
                              _titleLabel.frame.size.height +
                              _marginBetween +
                              _descriptionLabel.frame.size.height +
                              _arrowDownContainer.frame.size.height;
    
    
    _originalSize = sizeToShow;
    _expandedSize = CGRectMake(self.frame.origin.x,
                               self.frame.origin.y,
                               self.frame.size.width,
                               totalHeightToShow);
    
    float expandedYPositionForArrowContainer = _titleLabel.frame.origin.y +
                                               _titleLabel.frame.size.height +
                                               _marginBetween +
                                               _descriptionLabel.frame.size.height;
    
    _arrowDownContainerOriginalFrame = CGRectMake(0,
                                                  originalYPositionForArrowContainer,
                                                  _arrowDownContainer.frame.size.width,
                                                  _arrowDownContainer.frame.size.height);
    
    _arrowDownContainerExpandedFrame = CGRectMake(0,
                                                  expandedYPositionForArrowContainer,
                                                  _arrowDownContainer.frame.size.width,
                                                  _arrowDownContainer.frame.size.height);
    return sizeToShow;
}

- (void) setMarginBetween:(float)marginBetween{
    _marginBetween = marginBetween;
    [self resizeViews];
}

- (void) setMarginSides:(float)marginSides{
    _marginSides = marginSides;
    _width = self.frame.size.width - 2 * _marginSides;
    [self resizeViews];
}

- (void) setMarginTop:(float)marginTop{
    _marginTop = marginTop;
    [self resizeViews];
}

- (void) setTitleAttributes:(NSDictionary *)titleAttributes{
    _titleAttributes = titleAttributes;
    [_titleLabel setFont:_titleAttributes[NSFontAttributeName]];
    [self resizeViews];
}

- (void) setDescriptionAttributes:(NSDictionary *)contentAttributes{
    _descriptionAttributes = contentAttributes;
    [_descriptionLabel setFont:_descriptionAttributes[NSFontAttributeName]];
    [self resizeViews];
}

- (CGRect) getOriginalSize{
    return _originalSize;
}

- (CGRect) getExpandedSize{
    return _expandedSize;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_expandedSize.size.height < _originalSize.size.height) {
        return;
    }

    _heightDifference = [self heightDifferenceBetweenExpandedAndNot];
    if (_expanded) {
        _heightDifference = - _heightDifference;
    }
    
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    [UIView animateWithDuration:_animationTime animations:^{
        _arrowDown.transform = CGAffineTransformRotate(_arrowDown.transform, - M_PI);

        if (_expanded) {
            [self setFrame:_originalSize];
            [_arrowDownContainer setFrame:_arrowDownContainerOriginalFrame];
        }else{
            [self setFrame:_expandedSize];
            [_arrowDownContainer setFrame:_arrowDownContainerExpandedFrame];
        }
    
    } completion:^(BOOL finished) {
        if (_expandedSize.size.height != self.frame.size.height) {
            [_arrowDownContainer setHidden:NO];
        }
        _expanded = !_expanded;
    }];
}

- (float) heightDifferenceBetweenExpandedAndNot{
    if (_expandedSize.size.height < _originalSize.size.height) {
        return 0;
    }
    
    return _expandedSize.size.height - _originalSize.size.height;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (CGSize) getSizeFrom:(NSString *) string withAttributes:(NSDictionary*) attributes andAvailableSpace:(CGSize)space{
    
    CGSize textSize;
    if ([string respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        textSize = [string boundingRectWithSize:space options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    }else{
        textSize = [string sizeWithFont: [attributes objectForKey:NSFontAttributeName]
                      constrainedToSize:CGSizeMake(space.width, space.height)
                          lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    return textSize;
}
#pragma clang diagnostic pop

@end
