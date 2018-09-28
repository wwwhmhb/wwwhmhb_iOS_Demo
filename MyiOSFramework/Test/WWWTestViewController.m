//
//  WWWTestViewController.m
//  MyiOSFramework
//
//  Created by Yonggui Wang on 2018/7/12.
//  Copyright © 2018年 Weiwei Wang. All rights reserved.
//

#import "WWWTestViewController.h"

#import "NSArray+LXDExtension.h"
#import "BlazeiceDooleView.h"
#import "WWWNetworkingManager.h"
#import "WWWGCDReadWriteFile.h"

//#import "WWWTestObject.h"
//#import "WWWTestObject+TestAddProperty.h"
#import "WWWTestObject.h"
#import "WWWQRCodeCreate.h"
#import "WWWTestView.h"
#import "WWWImageViewAnimationView.h"

@interface WWWTestViewController () <YORStoryImageViewAnimationViewDelegate> {
    dispatch_queue_t queue;
}

@property (nonatomic,strong) NSData *myData;

@end

@implementation WWWTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"TestViewController";
    
//    WWWTestObject *testObject1 = [[WWWTestObject alloc] init];
//    NSLog(@"testObject1.age = %@",testObject1.age);
//    testObject1.age = @"33";
//    NSLog(@"testObject1.age = %@",testObject1.age);
//    
//    WWWTestObject *testObject2 = [[WWWTestObject alloc] init];
//    NSLog(@"testObject2.age = %@",testObject2.age);
    
    
    
    NSString *testStr = @"mobile/80224c1717d39a0f341560f01bb36af8d923e372/addRobotFriend";
    NSString *png = [testStr pathExtension];
    NSString *name = [testStr stringByDeletingPathExtension];
    NSArray *array = testStr.pathComponents;
    NSLog(@"array = %@",array);
    NSLog(@"png = %@;name = %@;lastPathComponent = %@",png,name,testStr.lastPathComponent);
    
    //二维码
//    WWWQRCodeCreate *QRCodeImage = [[WWWQRCodeCreate alloc] initWithQRCodeContent:@{@"key" : @"value"}];
    
    //改变图片颜色
//    UIImage *image = [UIImage imageNamed:@"icon"];
//    image = [self changeColorWithQRCodeImg:image red:255 green:225 blue:60];
    
//    UIButton *testButton = [UIButton buttonWithType:UIButtonTypeCustom];
////    [testButton setTitle:@"Test" forState:UIControlStateNormal];
//    [testButton setImage:[UIImage imageNamed:@"normalLightImage"] forState:UIControlStateNormal];
////    [testButton setImage:image forState:UIControlStateNormal];
////    [testButton setBackgroundColor:[UIColor orangeColor]];
//    [testButton addTarget:self action:@selector(testButtonAction:) forControlEvents:UIControlEventTouchUpInside];
////    testButton.imageView.backgroundColor = [UIColor redColor];
////    testButton.titleLabel.backgroundColor = [UIColor greenColor];
//    [self.view addSubview:testButton];
//    [testButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.view).offset(80);
//        make.left.mas_equalTo(self.view).offset(20);
//        make.size.mas_equalTo(CGSizeMake(400, 400));
//    }];
    
    //button图片和文字的布局
//    [self.view layoutIfNeeded];
//    testButton.imageEdgeInsets = UIEdgeInsetsMake(0,testButton.titleLabel.frame.size.width, 0, -testButton.titleLabel.frame.size.width);
//    testButton.titleEdgeInsets = UIEdgeInsetsMake(0, -testButton.imageView.frame.size.width, 0, testButton.imageView.frame.size.width);
    
    
    
//    UIView *view = [[UIView alloc] init];
//    view.backgroundColor = [UIColor redColor];
//    [self.view addSubview:view];
//    [view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.view).offset(80);
//        make.left.mas_equalTo(self.view).offset(20);
//        make.size.mas_equalTo(CGSizeMake(100, 100));
//    }];
//
//    view.userInteractionEnabled = YES;
//    view.multipleTouchEnabled = YES;
//    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
//    [view addGestureRecognizer:pan];
    
    
    
//    for (int i = 0; i < 6; i++) {
//        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)];
//
//        tapGesture.numberOfTapsRequired = i;
//        tapGesture.numberOfTouchesRequired = 2;
//        [view addGestureRecognizer:tapGesture];
//    }

    
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"map"]];
//    [self.view addSubview:imageView];
//    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.view);
//        make.left.mas_equalTo(self.view);
//    }];
    
//    WWWTestView *testView = [[WWWTestView alloc] init];
////    testView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:testView];
//    [testView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(self.view);
////        make.top.mas_equalTo(self.view).offset(80);
////        make.left.mas_equalTo(self.view).offset(20);
////        make.size.mas_equalTo(CGSizeMake(100, 100));
//    }];
    
//    WWWImageViewAnimationView *animationView = [[WWWImageViewAnimationView alloc] initWithImageFileName:@"storySmallPassImage" andImageCount:50 andIsCricle:YES];
//    animationView.backgroundColor = [UIColor redColor];
////    animationView.imageFileName = @"storySmallPassImage";
//    animationView.delegate = self;
//    [self.view addSubview:animationView];
//    [animationView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.mas_equalTo(self.view);
//        make.size.mas_equalTo(CGSizeMake(100, 100));
//    }];
//    [animationView startAnimation];
    UIImage *imageL = [UIImage imageNamed:@"mapLableLeftImage"];
    UIImage *imageM = [UIImage imageNamed:@"mapLableMiddleImage"];
    UIImage *imageR = [UIImage imageNamed:@"mapLableRightImage"];
    UIImage *image = [self combineWithLeftImg:imageL middleImg:imageM rightImg:imageR withMargin:100];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(image.size.width, image.size.height));
    }];
    
}

//leftImage:左侧图片 rightImage:右侧图片 margin:两者间隔
- (UIImage *)combineWithLeftImg:(UIImage*)leftImage middleImg:(UIImage *)middleImage rightImg:(UIImage*)rightImage withMargin:(NSInteger)margin {
    if (rightImage == nil) {
        return leftImage;
    }
    CGFloat width = leftImage.size.width + rightImage.size.width + margin - 2;
    CGFloat height = leftImage.size.height;
    CGSize offScreenSize = CGSizeMake(width, height);
    
    // UIGraphicsBeginImageContext(offScreenSize);用这个重绘图片会模糊
    UIGraphicsBeginImageContextWithOptions(offScreenSize, NO, [UIScreen mainScreen].scale);
    
    CGRect rectL = CGRectMake(0, 0, leftImage.size.width, height);
    
    
    CGRect rectM = CGRectMake(rectL.origin.x + leftImage.size.width - 1, 0, margin, height);
    
    CGRect rectR = CGRectMake(rectM.origin.x + margin - 1, 0, rightImage.size.width, height);
    
    [leftImage drawInRect:rectL];
    [rightImage drawInRect:rectR];
    [middleImage drawInRect:rectM];
    
    UIImage* imagez = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return imagez;
}

#pragma mark -- 代理方法
- (void)storyImageViewAnimationStop {
    NSLog(@"donghuajieshu");
}

#pragma mark - 手势执行的方法
-(void)handlePan:(UIPanGestureRecognizer *)rec{
//    CGFloat KWidth = [UIScreen mainScreen].bounds.size.width;
//    CGFloat KHeight = [UIScreen mainScreen].bounds.size.height;
    
    //返回在横坐标上、纵坐标上拖动了多少像素
    CGPoint point=[rec translationInView:self.view];
    
//    CGFloat centerX = rec.view.center.x+point.x;
//    CGFloat centerY = rec.view.center.y+point.y;
//
//    CGFloat viewHalfH = rec.view.frame.size.height/2;
//    CGFloat viewhalfW = rec.view.frame.size.width/2;
//
//    //确定特殊的centerY
//    if (centerY - viewHalfH < 0 ) {
//        centerY = viewHalfH;
//    }
//    if (centerY + viewHalfH > KHeight ) {
//        centerY = KHeight - viewHalfH;
//    }
//
//    //确定特殊的centerX
//    if (centerX - viewhalfW < 0){
//        centerX = viewhalfW;
//
//    }
//    if (centerX + viewhalfW > KWidth){
//        centerX = KWidth - viewhalfW;
//    }
    
    rec.view.center = CGPointMake(rec.view.center.x+point.x, rec.view.center.y+point.y);
    //拖动完之后，每次都要用setTranslation:方法制0这样才不至于不受控制般滑动出视图
    [rec setTranslation:CGPointMake(0, 0) inView:self.view];
}

- (void)gestureAction:(UITapGestureRecognizer *)gesture {
    NSLog(@"Gesture.numberOfTouches = %lu",(unsigned long)gesture.numberOfTouches);//手指个数qidao
    NSLog(@"Gesture.numberOfTapsRequired = %lu",(unsigned long)gesture.numberOfTapsRequired);//单击手势才具有的属性，点击次数
}

- (void)testButtonAction:(UIButton *)button {
    // 全局并发队列的获取方法
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);
    const char *queueName = dispatch_queue_get_label(queue);
    NSLog(@"queueName = %s",queueName);
}

/**
 修改二维码颜色
 
 @param image 二维码图片
 @param red red
 @param green green
 @param blue blue
 @return 修改颜色后的二维码图片
 */
- (UIImage *)changeColorWithQRCodeImg:(UIImage *)image red:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue {
    
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t bytesPerRow = imageWidth * 4;
    uint32_t * rgbImageBuf = (uint32_t *)malloc(bytesPerRow * imageHeight);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    
    CGContextDrawImage(context, (CGRect){(CGPointZero), (image.size)}, image.CGImage);
    //遍历像素
    int pixelNumber = imageHeight * imageWidth;
    [self changeColorOnPixel:rgbImageBuf pixelNum:pixelNumber red:red green:green blue:blue];
    
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow, nil);
    
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace, kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider, NULL, true, kCGRenderingIntentDefault);
    UIImage * resultImage = [UIImage imageWithCGImage: imageRef];
    CGImageRelease(imageRef);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    return resultImage;
}
/**
 遍历像素点，修改颜色
 
 @param rgbImageBuf rgbImageBuf
 @param pixelNum pixelNum
 @param red red
 @param green green
 @param blue blue
 */
- (void)changeColorOnPixel: (uint32_t *)rgbImageBuf pixelNum: (int)pixelNum red: (NSUInteger)red green: (NSUInteger)green blue: (NSUInteger)blue {
    
    uint32_t *pCurPtr = rgbImageBuf;
    
    for (int i = 0; i < pixelNum; i++, pCurPtr++) {
        
        //通过颜色区分是不是要改变的区域
        if ((*pCurPtr & 0xffffff00) < 0xd0d0d000) {
            
            uint8_t * ptr = (uint8_t *)pCurPtr;
            ptr[3] = red;
            ptr[2] = green;
            ptr[1] = blue;
        } else {
            //将白色变成透明色
            uint8_t * ptr = (uint8_t *)pCurPtr;
            ptr[0] = 0;
        }
    }
}


//3D Touch 预览该视图控制器时,生成快捷功能菜单
- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    
    UIPreviewAction *previewAction0 = [UIPreviewAction actionWithTitle:@"取消" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
        NSLog(@"取消");
    }];
    
    UIPreviewAction *previewAction1 = [UIPreviewAction actionWithTitle:@"替换该元素" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"替换该元素");
    }];
    UIPreviewAction *previewAction2 = [UIPreviewAction actionWithTitle:@"随意" style:UIPreviewActionStyleSelected handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
        NSLog(@"随意");
    }];
  
  return @[previewAction0 ,previewAction1,previewAction2];
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
