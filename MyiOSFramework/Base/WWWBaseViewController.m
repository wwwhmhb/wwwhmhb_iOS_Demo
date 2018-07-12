//
//  WWWBaseViewController.m
//  MyiOSFramework
//
//  Created by Yonggui Wang on 2018/7/12.
//  Copyright © 2018年 Weiwei Wang. All rights reserved.
//

#import "WWWBaseViewController.h"

#define NNBaseViewSize self.baseView.bounds.size
#define NNBaseViewSizeHeight self.baseView.bounds.size.height
#define NNBaseViewSizeWidth self.baseView.bounds.size.width




@interface WWWBaseViewController ()

@end

@implementation WWWBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}


- (void)setupViews {
    // 设置应用的背景色
    self.view.backgroundColor = [UIColor lightGrayColor];
    // 不允许 viewController 自动调整，我们自己布局；如果设置为YES，视图会自动下移 64 像素
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.baseView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64)];
    // 是否反弹
    self.baseView.bounces = NO;
    // 是否显示滚动指示器
    self.baseView.showsVerticalScrollIndicator = NO;
    self.baseView.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview:self.baseView];
    self.baseView.contentSize = NNBaseViewSize;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CGFloat baseViewHeight = 0;
    CGFloat baseViewWidth = 0;
    NSArray *subViews = self.baseView.subviews;
    
    // 遍历视图中的所有控件，求出最大的Y值和最大的X值
    for (UIView *view in subViews) {
        if (CGRectGetMaxY(view.frame) > baseViewHeight) {
            baseViewHeight = CGRectGetMaxY(view.frame);
        }
        if (CGRectGetMaxX(view.frame) > baseViewWidth) {
            baseViewWidth = CGRectGetMaxX(view.frame);
        }
    }
    
    // 三目运算方法求出最大的宽和最大的高
    CGFloat NNHeight = baseViewHeight > NNBaseViewSizeHeight ? baseViewHeight:NNBaseViewSizeHeight;
    CGFloat NNWidth = baseViewWidth > NNBaseViewSizeWidth ? baseViewWidth:NNBaseViewSizeWidth;
    
    self.baseView.contentSize = CGSizeMake(NNWidth, NNHeight);
}

#pragma mark - 自定义返回按钮
- (void)setupLeftBarButton {
    // 自定义 leftBarButtonItem ，UIImageRenderingModeAlwaysOriginal 防止图片被渲染
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithImage:[[UIImage imageNamed:@"Back-蓝"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                             style:UIBarButtonItemStylePlain
                                             target:self
                                             action:@selector(leftBarButtonClick)];
    // 防止返回手势失效
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
}

#pragma mark - 返回按钮的点击事件
- (void)leftBarButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
