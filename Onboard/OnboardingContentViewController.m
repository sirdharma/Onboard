//
//  OnboardingContentViewController.m
//  Onboard
//
//  Created by Mike on 8/17/14.
//  Copyright (c) 2014 Mike Amaral. All rights reserved.
//

#import "OnboardingContentViewController.h"

static NSString * const kDefaultOnboardingFont = @"Helvetica-Light";

#define DEFAULT_TEXT_COLOR [UIColor whiteColor];

static CGFloat const kContentWidthMultiplier = 0.9;
static CGFloat const kDefaultImageViewSize = 100;
static CGFloat const kDefaultTopPadding = 60;
static CGFloat const kDefaultUnderIconPadding = 30;
static CGFloat const kDefaultUnderTitlePadding = 30;
static CGFloat const kDefaultBottomPadding = 0;
static CGFloat const kDefaultTitleFontSize = 38;
static CGFloat const kDefaultBodyFontSize = 28;

static CGFloat const kActionButtonHeight = 50;
static CGFloat const kMainPageControlHeight = 35;

@interface OnboardingContentViewController ()

@end

@implementation OnboardingContentViewController

- (id)initWithTitle:(NSString *)title body:(NSString *)body image:(UIImage *)image buttonText:(NSString *)buttonText action:(dispatch_block_t)action {
    self = [super init];

    // hold onto the passed in parameters, and set the action block to an empty block
    // in case we were passed nil, so we don't have to nil-check the block later before
    // calling
    _titleText = title;
    _body = body;
    _image = image;
    _buttonText = buttonText;
    _actionHandler = action ?: ^{};
    
    // setup the initial default properties
    self.iconSize = kDefaultImageViewSize;
    self.fontName = kDefaultOnboardingFont;
    self.titleFontSize = kDefaultTitleFontSize;
    self.bodyFontSize = kDefaultBodyFontSize;
    self.topPadding = kDefaultTopPadding;
    self.underIconPadding = kDefaultUnderIconPadding;
    self.underTitlePadding = kDefaultUnderTitlePadding;
    self.bottomPadding = kDefaultBottomPadding;
    self.titleTextColor = DEFAULT_TEXT_COLOR;
    self.bodyTextColor = DEFAULT_TEXT_COLOR;
    self.buttonTextColor = DEFAULT_TEXT_COLOR;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // now that the view has loaded we can generate the content
    [self generateView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self setFrames];
}

- (void)generateView {
    // we want our background to be clear so we can see through it to the image provided
    self.view.backgroundColor = [UIColor clearColor];
    
    // create the image view with the appropriate image, size, and center in on screen
    _imageView = [[UIImageView alloc] initWithImage:_image];
    [self.view addSubview:_imageView];
    
    // create and configure the main text label sitting underneath the icon with the provided padding
    _mainTextLabel = [UILabel new];
    _mainTextLabel.text = _titleText;
    _mainTextLabel.textColor = self.titleTextColor;
    _mainTextLabel.font = [UIFont fontWithName:self.fontName size:self.titleFontSize];
    _mainTextLabel.numberOfLines = 0;
    _mainTextLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_mainTextLabel];
    
    // create and configure the sub text label
    _subTextLabel = [UILabel new];
    _subTextLabel.text = _body;
    _subTextLabel.textColor = self.bodyTextColor;
    _subTextLabel.font = [UIFont fontWithName:self.fontName size:self.bodyFontSize];
    _subTextLabel.numberOfLines = 0;
    _subTextLabel.textAlignment = NSTextAlignmentCenter;
    _subTextLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_subTextLabel];
    
    // create the action button if we were given button text
    if (_buttonText) {
        _actionButton = [UIButton new];
        _actionButton.titleLabel.font = [UIFont systemFontOfSize:24];
        [_actionButton setTitle:_buttonText forState:UIControlStateNormal];
        [_actionButton setTitleColor:self.buttonTextColor forState:UIControlStateNormal];
        [_actionButton addTarget:self action:@selector(handleButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_actionButton];
    }
    
    [self setFrames];
}

- (void)setFrames {
    // do some calculation for some common values we'll need, namely the width of the view,
    // the center of the width, and the content width we want to fill up, which is some
    // fraction of the view width we set in the multipler constant
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    CGFloat horizontalCenter = viewWidth / 2;
    CGFloat contentWidth = viewWidth * kContentWidthMultiplier;
    
    _imageView.frame = CGRectMake(horizontalCenter - (self.iconSize / 2), self.topPadding, self.iconSize, self.iconSize);
    
    _mainTextLabel.frame = CGRectMake(0, CGRectGetMaxY(_imageView.frame) + self.underIconPadding, contentWidth, 0);
    [_mainTextLabel sizeToFit];
    _mainTextLabel.center = CGPointMake(horizontalCenter, _mainTextLabel.center.y);
    
    _subTextLabel.frame = CGRectMake(0, CGRectGetMaxY(_mainTextLabel.frame) + self.underTitlePadding, contentWidth, 0);
    [_subTextLabel sizeToFit];
    _subTextLabel.center = CGPointMake(horizontalCenter, _subTextLabel.center.y);
    
    if (_actionButton) {
        _actionButton.frame = CGRectMake((CGRectGetMaxX(self.view.frame) / 2) - (contentWidth / 2), CGRectGetMaxY(self.view.frame) - kMainPageControlHeight - kActionButtonHeight - self.bottomPadding, contentWidth, kActionButtonHeight);
    }
}

#pragma mark - action button callback

- (void)handleButtonPressed {
    // simply call the provided action handler
    _actionHandler();
}

@end
