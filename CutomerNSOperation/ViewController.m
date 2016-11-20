//
//  ViewController.m
//  CutomerNSOperation
//
//  Created by ffm on 16/11/20.
//  Copyright © 2016年 ITPanda. All rights reserved.
//

#import "ViewController.h"
#import "DownPic.h"

#define strURL1 @"http://j.jikexueyuan.com/Current/home/offline/web/build/static/image/title.png"
#define strURL2 @"https://www.baidu.com/img/bd_logo1.png"
#define strURL3 @"http://img05.tooopen.com/images/20140604/sy_62331342149.jpg"

@interface ViewController () <downloadImageDelegate>

@property (nonatomic, strong) DownPic *myDownPic;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myDownPic.maxThreadConcurrentCount = 2;


//    downPic.completeBlock = ^(UIImage *image){
//        if (image)
//        {
//            NSLog(@"block提醒您：下载图片成功！");
//        }
//    };
}


- (IBAction)downloadPic:(id)sender {
    [self.myDownPic downloadPic:strURL2];
    
    [self.myDownPic downloadPics:@[strURL1, strURL2, strURL3,strURL1, strURL2, strURL3,strURL1, strURL2, strURL3,strURL1, strURL2, strURL3]];
}

- (void)downloadOperation:(NSOperation *)operation didFinishDownloadPic:(UIImage *)image
{
    if (image)
    {
        NSLog(@"delegate提醒您：下载图片成功！");
    }
}


- (DownPic *)myDownPic
{
    if (!_myDownPic)
    {
        _myDownPic = [[DownPic alloc] initWithDelegate:self];
    }
    return _myDownPic;
}
@end
