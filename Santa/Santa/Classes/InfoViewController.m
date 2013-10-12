//
//  InfoViewController.m
//  Kangaroo
//
//  Created by Roman Semenov on 11/29/12.
//
//

#import "InfoViewController.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
      
        
        CGFloat navigationBarHeight = 44;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                0,
                                                                [UIScreen mainScreen].bounds.size.height,
                                                                [UIScreen mainScreen].bounds.size.width-navigationBarHeight)];
        [view setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:view];
        [view release];
        
        scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                0,
                                                                [UIScreen mainScreen].bounds.size.height,
                                                                [UIScreen mainScreen].bounds.size.width-navigationBarHeight)];
        
        scroll.canCancelContentTouches = NO;
        scroll.showsVerticalScrollIndicator = YES;
        [scroll setDelaysContentTouches:NO];
        scroll.scrollEnabled = YES;
        scroll.scrollsToTop = YES;
        
        [view addSubview:scroll];
        [scroll release];
        
        imageView = [[UIImageView alloc] init];
        [scroll insertSubview:imageView atIndex:0];
        [imageView release];
        
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
}

-(void) viewDidDisappear:(BOOL)animated
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    ImageLoader *loader = [[ImageLoader alloc] init];
    [loader setDelegate:self];
    [loader loadImage:
     //@"https://dl.dropbox.com/s/s7xp777nara3b6g/Info%20Screen-ipad.jpg?dl=1"];
     @"http://s3.4mnow.com/dmapps/assets/newsscreendata/santas-reindeer-hunt-info/en-resource.jpg"];
    [loader release];
}
#pragma mark -
#pragma mark Image Load Delegate
- (void)appImageDidLoad:(UIImage* )image index:(int)index { // Метод делегата ImageLoader
    [imageView setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, image.size.height * ([UIScreen mainScreen].bounds.size.height / image.size.width))];
    [scroll setContentSize:imageView.frame.size];
    [imageView setImage:image];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
