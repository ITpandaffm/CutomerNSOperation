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
{
    int picCount;
}

@property (nonatomic, strong) DownPic *myDownPic;
@property (nonatomic, strong) NSOperationQueue *queue;
//@property (nonatomic, strong) UITableView *myTableView;

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
        @synchronized (self) {
            NSLog(@"delegate提醒您：下载图片成功！");
            NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(picCount*100, 0, 50, 50)];
                imageView.image = image;
                [self.view addSubview:imageView];
            }];
            [self.queue addOperation:blockOperation];
            picCount++;
        }
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

- (NSOperationQueue *)queue
{
    if (!_queue)
    {
        _queue = [[NSOperationQueue alloc] init];
    }
    return _queue;
}

//- (UITableView *)myTableView
//{
//    if (!_myTableView)
//    {
//        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-100) style:UITableViewStyleGrouped];
//        _myTableView.delegate = self;
//        _myTableView.dataSource = self;
//        [self.view addSubview:_myTableView];
//    }
//    return _myTableView;
//}
@end
