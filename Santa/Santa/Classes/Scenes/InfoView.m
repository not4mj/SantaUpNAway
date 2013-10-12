//
//  InfoView.m
//  Kangaroo
//
//  Created by Роман Семенов on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InfoView.h"
#import "AppDelegate.h"

@implementation InfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.alpha = 0.5;
        self.userInteractionEnabled = YES;
        [self setExclusiveTouch:YES];
        
        
        CGRect webFrame = CGRectMake(0.0, 0.0, 480.0, 320.0);
        UIWebView *webView = [[UIWebView alloc] initWithFrame:webFrame];
        
        [webView setBackgroundColor:[UIColor greenColor]];
        NSString *urlAddress = @"https://dl.dropbox.com/s/ttpsgkwrseluj57/info.html?dl=1";
        //NSString *urlAddress = [[NSBundle mainBundle] pathForResource:@"info" ofType:@"html"];
        NSURL *url = [NSURL URLWithString:urlAddress];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [webView loadRequest:requestObj];
        [self addSubview:webView]; 
        [webView release];
        
//back button
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(394, 274, 82, 50)];
        [backButton addTarget:self action:@selector(backToMenu) forControlEvents:UIControlEventTouchUpInside];
        [backButton setBackgroundImage:[UIImage imageNamed:@"back_normal.png"] forState:UIControlStateNormal];
        [backButton setBackgroundImage:[UIImage imageNamed:@"back_selected.png"] forState:UIControlStateHighlighted];
        
        [webView addSubview:backButton];
        [backButton release];
    }
    return self;
}

- (void) backToMenu
{
    NSLog(@"backToMenu");
    //AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    //[delegate removeView:self];
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
