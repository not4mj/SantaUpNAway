//
//  InfoViewController.h
//  Kangaroo
//
//  Created by Roman Semenov on 11/29/12.
//
//

#import <UIKit/UIKit.h>
#import "ImageLoader.h"

@interface InfoViewController : UIViewController <ImageLoaderDelegate>
{
    UIImageView *imageView;
    UIScrollView *scroll;
}

@end
