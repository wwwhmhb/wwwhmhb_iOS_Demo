//
//  WWWQRCodeCreate.m
//  MyiOSFramework
//
//  Created by Yonggui Wang on 2018/9/21.
//  Copyright © 2018年 Weiwei Wang. All rights reserved.
//

#import "WWWQRCodeCreate.h"
#import <CoreImage/CoreImage.h>

@interface WWWQRCodeCreate ()
@property (nonatomic,strong) UIImage *QRCodeImage;
@end

@implementation WWWQRCodeCreate

- (instancetype)initWithQRCodeContent:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [self createQRCodeWithContent:dict];
    }
    return self;
}

- (void)createQRCodeWithContent:(NSDictionary *)dict {
    
    //创建名为"CIQRCodeGenerator"的CIFilter
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    //将filter所有属性设置为默认值
    [filter setDefaults];
    
    //将所需数据转化为data，并设置给filter
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    [filter setValue:jsonData forKey:@"inputMessage"];
    
    //设置二维码的纠错水平，越高纠错水平越高，可以污损的范围越大
    /*
     * L: 7%
     * M: 15%
     * Q: 25%
     * H: 30%
     */
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    //拿到二维码图片，此时的图片不是很清晰,大小不合适，需要二次加工
    CIImage *outPutImage = [filter outputImage];
    
    //二维码二次加工
//    self.QRCodeImage = [self getHDImgWithCIImage:outPutImage size:CGSizeMake(200, 200) pointColor:[UIColor greenColor] backgroundColor:[UIColor redColor]];
    
//    self.QRCodeImage = [self getHDImgWithCIImage:outPutImage size:CGSizeMake(200, 200)];
    
    UIImage *image0 = [self getHDImgWithCIImage:outPutImage size:CGSizeMake(200, 200)];
    UIImage *image1 = [self changeColorWithQRCodeImg:image0 red:255 green:225 blue:60];
    self.QRCodeImage = [self spliceImg1:image0 img2:image1 img2Location:CGPointZero];
//    [self combineWithLeftImg:image0 rightImg:image1 withMargin:10];
//    image1;
    
}

/**
 调整二维码清晰度
 
 @param img 模糊的二维码图片
 @param size 二维码的宽高
 @return 清晰的二维码图片
 */
- (UIImage *)getHDImgWithCIImage:(CIImage *)img size:(CGSize)size {
    
    CGRect extent = CGRectIntegral(img.extent);
    CGFloat scale = MIN(size.width/CGRectGetWidth(extent), size.height/CGRectGetHeight(extent));
    
    //函数：CGBitmapContextCreate(void * _Nullable data, size_t width, size_t height, size_t bitsPerComponent, size_t bytesPerRow, CGColorSpaceRef  _Nullable space, uint32_t bitmapInfo)
    //width：图片宽度像素
    //height：图片高度像素
    //bitsPerComponent：每个颜色的比特值，例如在rgba-32模式下为8
    //space：颜色空间
    //bitmapInfo：指定的位图应该包含一个alpha通道。
    //设定图片宽高
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    //创建一个DeviceGray颜色空间
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    //创建 bitmap 上下文
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    
    //创建CoreGraphics image
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:img fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    //保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    //释放资源
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    //清晰的二维码图片
    UIImage *outputImage = [UIImage imageWithCGImage:scaledImage];
    
    return outputImage;
}

/**
 调整二维码清晰度,并可改变背景和二维码的颜色
 
 @param img 模糊的二维码图片
 @param size 二维码的宽高
 @param pointColor 二维码颜色
 @param backgroundColor 二维码的背景颜色
 @return 清晰的二维码图片
 */
- (UIImage *)getHDImgWithCIImage:(CIImage *)img size:(CGSize)size pointColor:(UIColor *)pointColor backgroundColor:(UIColor *)backgroundColor {
    
    //创建名为"CIFalseColor"的CIFilter,并设置响应参数
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"
                                       keysAndValues:
                             @"inputImage", img,
                             @"inputColor0", [CIColor colorWithCGColor:pointColor.CGColor],
                             @"inputColor1", [CIColor colorWithCGColor:backgroundColor.CGColor],
                             nil];
    
    //绘制二维码图片
    CIImage *qrImage = colorFilter.outputImage;
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    //结束上下文
    UIGraphicsEndImageContext();
    //释放资源
    CGImageRelease(cgImage);
    
    return codeImage;
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
    
    uint32_t * pCurPtr = rgbImageBuf;
    
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

/**
 拼接图片
 
 @param img1 图片1
 @param img2 图片2
 @param location 图片2相对于图片1的左上角位置，如果为CGPointZero，则图片2居中图片1的中间
 @return 拼接后的图片
 */
- (UIImage *)spliceImg1:(UIImage *)img1 img2:(UIImage *)img2 img2Location:(CGPoint)location {
    
    CGSize size1 = img1.size;
    CGSize size2 = img2.size;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(400,400), NO, [[UIScreen mainScreen] scale]);
    [img1 drawInRect:CGRectMake(0, 0, 200, 200)];
    
    if (CGPointEqualToPoint(location, CGPointZero)) {

        [img2 drawInRect:CGRectMake(0, 200, 200, 200)];
    } else {

        [img2 drawInRect:CGRectMake((size1.width-size2.width)/2.0, (size1.height-size2.height)/2.0, size2.width, size2.height)];
    }
    
    //绘制图片2的位置
//    [img2 drawInRect:CGRectMake(size1.width/4.0, size1.height/2.5, size1.width/2, size1.width/2)];
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newPic;
}

//leftImage:左侧图片 rightImage:右侧图片 margin:两者间隔
- (UIImage *)combineWithLeftImg:(UIImage*)leftImage rightImg:(UIImage*)rightImage withMargin:(NSInteger)margin{
    if (rightImage == nil) {
        return leftImage;
    }
    CGFloat width = leftImage.size.width + rightImage.size.width + margin;
    CGFloat height = leftImage.size.height;
    CGSize offScreenSize = CGSizeMake(width, height);
    
    // UIGraphicsBeginImageContext(offScreenSize);用这个重绘图片会模糊
    UIGraphicsBeginImageContextWithOptions(offScreenSize, NO, [UIScreen mainScreen].scale);
    
    CGRect rectL = CGRectMake(0, 0, leftImage.size.width, height);
    [leftImage drawInRect:rectL];
    
    CGRect rectR = CGRectMake(rectL.origin.x + leftImage.size.width + margin, 0, rightImage.size.width, height);
    [rightImage drawInRect:rectR];
    
    UIImage* imagez = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return imagez;
}

@end
