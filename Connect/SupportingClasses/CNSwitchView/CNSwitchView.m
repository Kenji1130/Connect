//
//  CNSwitchView.m
//  Connect
//
//  Created by Daniel on 31/01/2017.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNSwitchView.h"

static const CGFloat kAnimateDuration = 0.3f;
static const CGFloat kThumbShadowOpacity = 0.3f;
static const CGFloat kThumbShadowRadius = 0.5f;
//static const CGFloat kSwitchBorderWidth = 1.75f;

@interface CNSwitchView()

@property (nonatomic, strong) UIButton *onButton;
@property (nonatomic, strong) UIButton *offButton;
@property (nonatomic, strong) UIView *thumbView;

@property (nonatomic, strong) NSLayoutConstraint *constOfThumbLeft;

@property (nonatomic, strong) UIColor *offTextColor;
@property (nonatomic, strong) UIColor *offTintColor;
@property (nonatomic, strong) UIFont *onTextFont;
@property (nonatomic, strong) UIFont *offTextFont;

@end

@implementation CNSwitchView
@synthesize onButton = _onButton;
@synthesize offButton = _offButton;
@synthesize thumbView = _thumbView;
@synthesize on = _on;
@synthesize thumbTintColor = _thumbTintColor;
@synthesize shadow = _shadow;

#pragma mark - View

- (id)init {
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupUI];
    }
    return self;
}

- (id)initWithType:(CNSwitchType)switchType {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        // Initialization code
        self.switchType = switchType;
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupUI];
}

- (void)setupUI {
    
    self.layer.borderWidth = 0.0;
    self.layer.borderColor = UIColorFromRGB(0xe1e1e1).CGColor;
    self.layer.masksToBounds = NO;
    self.layer.cornerRadius = 20;
    
    [self setBackgroundColor:[UIColor whiteColor]];
    
    // Button for ON
    self.onButton = [UIButton new];
    self.onButton.userInteractionEnabled = NO;
    [self.onButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.onButton setTintColor:[UIColor whiteColor]];
    
    /// Button for OFF
    self.offButton = [UIButton new];
    self.offButton.userInteractionEnabled = NO;
    
    if (self.switchType == CNSwitchTypeConnections) {
        // Connections Switch
        [self.onButton setTitle:@"Connections" forState:UIControlStateNormal];
        [self.offButton setTitle:@"All Users" forState:UIControlStateNormal];
        
        self.onTextFont = [UIFont fontWithName:@"ProximaNovaA-Semibold" size:15];
        self.offTextFont = [UIFont fontWithName:@"ProximaNova-Regular" size:15];
        self.offTextColor = UIColorFromRGB(0x2d3941);
        self.offTintColor = UIColorFromRGB(0x2d3941);
        
    } else if (self.switchType == CNSwitchTypeProfile) {
        // Profile Switch
        [self.onButton setTitle:@"  Personal" forState:UIControlStateNormal];
        [self.onButton setImage:[UIImage imageNamed:@"UIButtonSwitchPersonal"] forState:UIControlStateNormal];
        
        [self.offButton setTitle:@"  Business" forState:UIControlStateNormal];
        [self.offButton setImage:[UIImage imageNamed:@"UIButtonSwitchBusiness"] forState:UIControlStateNormal];
        
        self.onTextFont = [UIFont fontWithName:@"ProximaNovaA-Bold" size:12];
        self.offTextFont = [UIFont fontWithName:@"ProximaNova-Regular" size:12];
        self.offTextColor = UIColorFromRGB(0x697781);
        self.offTintColor = UIColorFromRGB(0x929eaf);
    }
    
    self.onButton.titleLabel.font = [UIFont fontWithName:@"ProximaNovaA-Semibold" size:15];
    self.offButton.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:15];
    
    [self.offButton setTitleColor:self.offTextColor forState:UIControlStateNormal];
    [self.offButton setTintColor:self.offTintColor];
    
    // Round switch view
    self.thumbView = [UIView new];
    [self.thumbView setBackgroundColor:kAppTintColor];
    [self.thumbView setUserInteractionEnabled:YES];
    [self.thumbView.layer setCornerRadius:20];
    [self.thumbView.layer setShouldRasterize:YES];
    [self.thumbView.layer setRasterizationScale:[UIScreen mainScreen].scale];
    
//    self.shadow = YES;
    _on = YES;
    
    for (UIView *view in @[self.thumbView, self.onButton, self.offButton]) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:view];
    }
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_onButton, _offButton, _thumbView);
    NSDictionary *metrics = @{ @"width" : @(SCREEN_WIDTH / 2 - 10)};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_onButton][_offButton(==_onButton)]|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_onButton]|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_offButton]|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_thumbView]|" options:0 metrics:metrics views:views]];
    
    // Default to OFF position
    self.constOfThumbLeft = [self.thumbView.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:0];
    [self addConstraints:@[self.constOfThumbLeft, [self.thumbView.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:0.5]]];
    
    // Handle Thumb Tap Gesture
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwitchTap:)];
    [tapGestureRecognizer setDelegate:self];
    [self.thumbView addGestureRecognizer:tapGestureRecognizer];
    
    // Handle Background Tap Gesture
    UITapGestureRecognizer *tapBgGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleBgTap:)];
    [tapBgGestureRecognizer setDelegate:self];
    [self addGestureRecognizer:tapBgGestureRecognizer];
    
    // Handle Thumb Pan Gesture
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [panGestureRecognizer setDelegate:self];
    [self.thumbView addGestureRecognizer:panGestureRecognizer];
    
}

#pragma mark - Accessor

- (BOOL)isOn {
    return _on;
}

- (void)setOn:(BOOL)on {
    if (_on != on)
        _on = on;
    
    [self updateColors:on];
    
    if (_on) {
        self.constOfThumbLeft.constant = 0;
    } else {
        self.constOfThumbLeft.constant = SCREEN_WIDTH / 2 - 10;
    }
}

- (void)setThumbTintColor:(UIColor *)color {
    if (_thumbTintColor != color)
        _thumbTintColor = color;
    
    [self.thumbView setBackgroundColor:color];
}

- (void)setShadow:(BOOL)showShadow {
    if (_shadow != showShadow)
        _shadow = showShadow;
    
    if (showShadow) {
        [self.thumbView.layer setShadowOffset:CGSizeMake(0, 1)];
        [self.thumbView.layer setShadowRadius:kThumbShadowRadius];
        [self.thumbView.layer setShadowOpacity:kThumbShadowOpacity];
    } else {
        [self.thumbView.layer setShadowRadius:0.0];
        [self.thumbView.layer setShadowOpacity:0.0];
    }
}

#pragma mark - Animation

- (void)animateToDestination:(CGFloat)constant withDuration:(CGFloat)duration switch:(BOOL)on {
    
    self.constOfThumbLeft.constant = constant;
    
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [self layoutIfNeeded];
                         [self updateColors:on];
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [self updateSwitch:on];
                         }
                         
                     }];
}

#pragma mark - Gesture Recognizers

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:self.thumbView];
    
    // Check the new center to see if within the boud
    CGPoint newCenter = CGPointMake(recognizer.view.center.x + translation.x,
                                    recognizer.view.center.y);
    if (newCenter.x < recognizer.view.frame.size.width / 2 || newCenter.x > self.frame.size.width - recognizer.view.frame.size.width / 2) {
        
        // New center is Out of bound. Animate to left or right position
        if(recognizer.state == UIGestureRecognizerStateBegan ||
           recognizer.state == UIGestureRecognizerStateChanged)
        {
            CGPoint velocity = [recognizer velocityInView:self.thumbView];
            
            if (velocity.x >= 0) {
                // Animate move to right
                [self animateToDestination:self.offButton.frame.origin.x withDuration:kAnimateDuration switch:NO];
            } else {
                // Animate move to left
                [self animateToDestination:self.onButton.frame.origin.x withDuration:kAnimateDuration switch:YES];
            }
            
        }
        
        return;
    }
    
    // Only allow vertical pan
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.thumbView];
    
    CGPoint velocity = [recognizer velocityInView:self.thumbView];
    
    if(recognizer.state == UIGestureRecognizerStateEnded) {
        if (velocity.x >= 0) {
            if (recognizer.view.center.x < self.frame.size.width - self.thumbView.frame.size.width / 2) {
                // Animate move to right
                [self animateToDestination:self.offButton.frame.origin.x withDuration:kAnimateDuration switch:NO];
            }
        } else {
            // Animate move to left
            [self animateToDestination:self.onButton.frame.origin.x withDuration:kAnimateDuration switch:YES];
        }
    }
}

- (void)handleSwitchTap:(UIPanGestureRecognizer *)recognizer {
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (self.isOn) {
            // Animate move to left
            [self animateToDestination:self.offButton.frame.origin.x withDuration:kAnimateDuration switch:NO];
        } else {
            // Animate move to right
            [self animateToDestination:self.onButton.frame.origin.x withDuration:kAnimateDuration switch:YES];
        }
    }
}

- (void)handleBgTap:(UIPanGestureRecognizer *)recognizer {
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (self.isOn) {
            // Animate move to left
            [self animateToDestination:self.offButton.frame.origin.x withDuration:kAnimateDuration switch:NO];
        } else {
            // Animate move to right
            [self animateToDestination:self.onButton.frame.origin.x withDuration:kAnimateDuration switch:YES];
        }
    }
}

#pragma mark -

- (void)updateSwitch:(BOOL)on {
    if (_on != on)
        _on = on;
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)updateColors:(BOOL)on {
    if (on) {
        [self.onButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.onButton setTintColor:[UIColor whiteColor]];
        [self.offButton setTitleColor:self.offTextColor forState:UIControlStateNormal];
        [self.offButton setTintColor:self.offTintColor];
        
        self.onButton.titleLabel.font = self.onTextFont;
        self.offButton.titleLabel.font = self.offTextFont;
    } else {
        [self.onButton setTitleColor:self.offTextColor forState:UIControlStateNormal];
        [self.onButton setTintColor:self.offTintColor];
        [self.offButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.offButton setTintColor:[UIColor whiteColor]];
        
        self.onButton.titleLabel.font = self.offTextFont;
        self.offButton.titleLabel.font = self.onTextFont;
    }
}

@end
