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

@interface WWWTestViewController () {
    dispatch_queue_t queue;
}

@property (nonatomic,strong) NSData *myData;

@end

@implementation WWWTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"TestViewController";
    
    NSMutableArray *a=[@[@19,@3,@60,@79,@1,@15,@33,@24,@45,@32,@7,@85] mutableCopy];
//    NSMutableArray *a=[@[@19,@3,@60,@19,@19,@15,@33,@24,@45,@32,@85,@19] mutableCopy];
    
    [self shellAscendingOrderSort1:a];
    NSLog(@"a= %@",a);
    
    UIButton *testButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [testButton setTitle:@"Test" forState:UIControlStateNormal];
    [testButton setBackgroundColor:[UIColor orangeColor]];
    [testButton addTarget:self action:@selector(testButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testButton];
    [testButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(80);
        make.left.mas_equalTo(self.view).offset(20);
        make.size.mas_equalTo(CGSizeMake(100, 60));
    }];


    //获取进行信息,但是会造成长时间卡顿
//    NSProcessInfo *processInfo = [NSProcessInfo processInfo];
//    NSString *hostname = processInfo.hostName;
//    NSLog(@"hostname = %@",processInfo.environment);
}



- (void)testButtonAction:(UIButton *)button {


    // 全局并发队列的获取方法
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);
    const char *queueName = dispatch_queue_get_label(queue);
    NSLog(@"queueName = %s",queueName);
    
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

/*
 插入法主要思想是,遍历取出数组中每个元素为当前元素,并将当前元素插入到该元素之前的数据中(当前元素之前的数据都是有序的)
 */
//直插法是将当前元素逐个和其之前的元素比较
#pragma mark - 插入排序(升序)--9
- (void)insertionAscendingOrderSort2:(NSMutableArray *)ascendingArr {
    for (int i = 1; i < ascendingArr.count; i++) {
        NSNumber *temp = ascendingArr[i];
        for (int j = 0; j < i; j++) {
            if (temp < ascendingArr[j]) {
                for (int k = i; k > j; k--) {
                    ascendingArr[k] = ascendingArr[k - 1];
                }
                ascendingArr[j] = temp;
                break;
            }
        }
    }
}

- (void)insertionAscendingOrderSort1:(NSMutableArray *)ascendingArr {
    for (int i = 0; i < ascendingArr.count; i++) {
        for (int j = i; j > 0; j--) {
            if (ascendingArr[j] < ascendingArr[j - 1]) {
                NSNumber *temp = ascendingArr[j];
                ascendingArr[j] = ascendingArr[j - 1];
                ascendingArr[j - 1] = temp;
            }
        }
    }
}

- (void)insertionAscendingOrderSort:(NSMutableArray *)ascendingArr {
    for (int i = 1; i < ascendingArr.count; i++) {
        for (int j = i; j >= 1; j--) {
            if (ascendingArr[j] < ascendingArr[j - 1]) {
                NSNumber *temp = ascendingArr[j];
                ascendingArr[j] = ascendingArr[j - 1];
                ascendingArr[j - 1] = temp;
            } else {
                break;
            }
        }
    }
}

#pragma mark - 二分插入排序(升序)--8
- (void)halfInsertAscendingOrderSort:(NSMutableArray *)ascendingArr {
    for (int i = 1; i < ascendingArr.count; i++) {
        //当前值和其实位置
        NSNumber *temp = ascendingArr[i];
        int begin = 0;
        int end = i - 1;
        
        //二分法寻找插入位置
        while (begin <= end) {
            int middle = (begin + end) / 2;
            if (temp > ascendingArr[middle]) {
                begin = middle + 1;
            } else {
                end = middle - 1;
            }
        }
        
        //找到位置后,平移元素
        for (int j = i; j > begin; j--) {
            ascendingArr[j] = ascendingArr[j - 1];
        }
        
        //将值插入
        ascendingArr[begin] = temp;
    }
}

#pragma mark - 希尔排序(升序)--7
- (void)shellAscendingOrderSort1:(NSMutableArray *)ascendingArr {
    for (NSInteger gap = ascendingArr.count / 2; gap > 0; gap /= 2) {
        for (NSInteger loc = 0; loc < gap; loc++) {
            for (NSInteger i = loc + gap; i < ascendingArr.count; i += gap) {
                for (NSInteger j = i; j >= gap; j -= gap) {
                    if (ascendingArr[j] < ascendingArr[j - gap]) {
                        NSNumber *temp = ascendingArr[j];
                        ascendingArr[j] = ascendingArr[j - gap];
                        ascendingArr[j - gap] = temp;
                    } else {
                        break;
                    }
                }
            }
        }
    }
}
- (void)shellAscendingOrderSort:(NSMutableArray *)ascendingArr {
    //确定步调宽度
    for (NSInteger gap = ascendingArr.count / 2; gap > 0; gap /= 2) {
        //从步调位置开始,遍历后面数组
        for (NSInteger i = gap; i < ascendingArr.count; i++) {
            //该步调下的每组数据进行插入排序
            for (NSInteger j = i; j >= gap; j -= gap) {
                if (ascendingArr[j] < ascendingArr[j - gap]) {
                    NSNumber *temp = ascendingArr[j];
                    ascendingArr[j] = ascendingArr[j - gap];
                    ascendingArr[j - gap] = temp;
                }
            }
            //            NSInteger j = i;
            //            while (j - gap >= 0 && ascendingArr[j] < ascendingArr[j - gap]) {
            //                NSNumber *temp = ascendingArr[j];
            //                ascendingArr[j] = ascendingArr[j - gap];
            //                ascendingArr[j - gap] = temp;
            //
            //                j -= gap;
            //            }
        }
    }
}



#pragma mark - 选择排序(升序)--6
- (void)selectionAscendingOrderSortWithArray:(NSMutableArray *)ascendingArr {
    for (int i = 0; i < ascendingArr.count; i ++) {//确定数组中第 i 位的数据
        for (int j = i + 1; j < ascendingArr.count; j ++) {//将数组中第 i 位之后的数据挨个与第 i 位数据比较
            if ([ascendingArr[i] integerValue] > [ascendingArr[j] integerValue]) {//第 i 位数据大于第 j 位数据
                //交换第 i 位数据和第 j 位数据
                int temp = [ascendingArr[i] intValue];
                ascendingArr[i] = ascendingArr[j];
                ascendingArr[j] = [NSNumber numberWithInt:temp];
            }
        }
    }
    NSLog(@"选择升序排序后结果：%@", ascendingArr);
}



#pragma mark -- 冒泡排序(升序)--5
- (void)bubbleAscendingOrderSortWithArray:(NSMutableArray *)ascendingArr {
    
    for (int i = 0; i < ascendingArr.count; i++) {//确定数组中倒数第 i+1 位的数据
        //初始化 bool 变量,判断在此过程中数组中的数据是否发生位置变化
        BOOL isChange = NO;
        
        for (int j = 0; j < ascendingArr.count - (i + 1); j++) {//将数组中倒数第 i+1 位之前的相邻位数据之间比较,包括倒数第 i+1 位数据,数据像冒泡似的从低向上翻滚到指定相应位置
            if ([ascendingArr[j+1] intValue] < [ascendingArr[j] intValue]) {//数组中第 j 位数据大于第 j+1 位数据
                //数组中的数据需要发生位置变化
                isChange = YES;
                //交换数组中第 j 位数据和第 j+1 位数据
                int temp = [ascendingArr[j] intValue];
                ascendingArr[j] = ascendingArr[j + 1];
                ascendingArr[j + 1] = [NSNumber numberWithInt:temp];
            }
        }
        //数组中没有数据发生变化,结束
        if (!isChange) {
            break;
        }
    }
    NSLog(@"冒泡升序排序后结果：%@", ascendingArr);
}



#pragma mark - 快速排序(升序,并且能够指定排序范围)--4
- (void)quickAscendingOrderSort:(NSMutableArray *)arr leftIndex:(NSInteger)left rightIndex:(NSInteger)right {
    if (left < right) {
        //从数组指定范围内,选出基准数,并进行整理,小于等于基准数的数据在其左边,大于等于基准数的数据在其右边
        NSInteger temp = [self getMiddleIndex:arr leftIndex:left rightIndex:right];
        //递归调用,期结束条件为 left = right
        //快速排序数组中基准数左侧范围的数据
        [self quickAscendingOrderSort:arr leftIndex:left rightIndex:temp - 1];
        //快速排序数组中基准数右侧范围的数据
        [self quickAscendingOrderSort:arr leftIndex:temp + 1 rightIndex:right];
    }
}

//取出一个基准数,并将其放到属于自己的位置.即小于等于基准数的数据在其左边,大于等于基准数的数据在其右边
/*注意事项:在左右两侧与基准数据比较时,不能把小于基准数的留在左边,大于基准数的留在右边,如果这样,那么等于基准数的数据会不断的从左边移到右边,又从右边移到左边,造成死循环*/
- (NSInteger)getMiddleIndex:(NSMutableArray *)arr leftIndex:(NSInteger)left rightIndex:(NSInteger)right {
    //取数组左侧第一个数为基准数
    NSInteger tempValue = [arr[left] integerValue];
    //从数组两端向中部进行整理,大于基准数的留在右边,小于基准数的留在左边,结束时 left = right,此时此处也是基准数的位置.(如果从左侧取基准数,则先从右端开始整理,否则从左侧开始整理,总之先开始整理的方位与取基准数的方位相反)
    while (left < right) {
        //从数组右侧开始寻找小于基准数的位置
        while (left < right && tempValue <= [arr[right] integerValue]) {//右侧位置大于左侧位置,并且右位置数据大于基准数据
            //右侧位置向左移动一下,指向下一个数据
            right --;
        }
        //如果从右侧寻找到小于基准数的位置,则将右侧小于基准数的数据放到此时左侧的位置,否则结束
        if (left < right) {//右侧的位置大于左侧的位置
            //右侧小于基准数的数据放到此时左侧的位置
            arr[left] = arr[right];
        }
        
        //从数组左侧开始寻找大于基准数的位置
        while (left < right && [arr[left] integerValue] <= tempValue) {//右侧位置大于左侧位置,并且左侧位置数据小于基准数据
            //左侧位置向右移动一下,指向下一个数据
            left ++;
        }
        //如果从左侧寻找到大于基准数的位置,则将左侧大于基准数的数据放到此时右侧的位置,否则结束
        if (left < right) {//右侧的位置大于左侧的位置
            //左侧小于基准数的数据放到此时右侧的位置
            arr[right] = arr[left];
        }
    }
    //此时 left = right 也正是基准数的位置,将其归位
    arr[left] = [NSNumber numberWithInteger:tempValue];
    //返回基准数的位置
    return left;
}



#pragma mark - 归并排序(升序)--3
- (void)megerSortAscendingOrderSort:(NSMutableArray *)ascendingArr {
    //    [self megerSortAscendingOrderSort1:ascendingArr];
    //    或
    NSArray *array = [self megerSortAscendingOrderSort:ascendingArr leftIndex:0 rightIndex:ascendingArr.count - 1];
    for (int i = 0; i < array.count; i++) {
        ascendingArr[i] = array[i];
    }
}

//二分归并排序
- (NSArray *)megerSortAscendingOrderSort:(NSArray *)ascendingArr leftIndex:(NSInteger)left rightIndex:(NSInteger)right {
    //右侧大于左侧
    if (left < right) {
        //左右侧的中间项
        NSInteger middle = (left + right) / 2;
        //左侧二分归并排序
        NSArray *array1 = [self megerSortAscendingOrderSort:ascendingArr leftIndex:left rightIndex:middle];
        //右侧二分归并排序
        NSArray *array2 = [self megerSortAscendingOrderSort:ascendingArr leftIndex:middle + 1 rightIndex:right];
        //将左右两侧归并排序结果合并
        NSArray *array = [self mergeArrayFirstList:array1 secondList:array2];
        NSLog(@"归并升序排序结果：%@", array);
        return array;
    } else {//右侧小于等于左侧,返回左侧
        return @[ascendingArr[left]];
    }
}
//将数组拆分为最小单元数组,然后再将最小单元数组合并,此法没有二分归并方法好
- (void)megerSortAscendingOrderSort1:(NSMutableArray *)ascendingArr {
    //拆分为最小单元数组
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSNumber *num in ascendingArr) {
        NSMutableArray *subArray = [NSMutableArray array];
        [subArray addObject:num];
        [tempArray addObject:subArray];
    }
    //合并最小单元数组
    while (tempArray.count > 1) {
        tempArray[0] = [self mergeArrayFirstList:tempArray[0] secondList:tempArray[1]];
        [tempArray removeObjectAtIndex:1];
    }
    //合并后的数组放到原数组中
    NSMutableArray *mmm = tempArray[0];
    for (int i = 0; i < mmm.count; i++) {
        ascendingArr[i] = mmm[i];
    }
    NSLog(@"归并升序排序结果：%@", ascendingArr);
}

- (NSArray *)mergeArrayFirstList:(NSArray *)array1 secondList:(NSArray *)array2 {
    //初始化可变数组
    NSMutableArray *resultArray = [NSMutableArray array];
    //初始化第一第二数组的起始位置
    NSInteger firstIndex = 0, secondIndex = 0;
    //将第一第二数组合并到可变数组中
    while (firstIndex < array1.count && secondIndex < array2.count) {//直到两个数组中任意一个数组的位置超出该数组
        //哪个数组位置的数据小就将其放入可变数组,并且该数组位置前移
        if ([array1[firstIndex] floatValue] < [array2[secondIndex] floatValue]) {//数组1的数据小
            [resultArray addObject:array1[firstIndex]];
            firstIndex++;
        } else {//数组2的数据小
            [resultArray addObject:array2[secondIndex]];
            secondIndex++;
        }
    }
    //将剩下数组的元素合并到可变数组中
    while (firstIndex < array1.count) {//数组1剩下
        [resultArray addObject:array1[firstIndex]];
        firstIndex++;
    }
    while (secondIndex < array2.count) {//数组2剩下
        [resultArray addObject:array2[secondIndex]];
        secondIndex++;
    }
    return resultArray.copy;
}



#pragma mark -- 堆排序(升序)--2
//创建二叉树，并将二叉树进行由小到大的排序
-(void)sortingForHeapWithArray:(NSMutableArray *)array{
    //从二叉树的最后一个非叶子节点开始整理二叉树，并从下向上整理,从而整颗二叉树变得稳定
    for (int i = (int)(array.count / 2 - 1); i>=0; --i) {//最后一个非叶子节点的节点数为(array.count / 2 - 1),由最后一个非叶子节点开始向下形成的二叉树,可以看作相对稳定的二叉树
        
        [self heapSortingWithArray:array startIndex:i arrayifCount:(int)array.count];//从指定节点开始整理
    }
    
    //将稳定的二叉树的最后一个节点和根节点交换，此时二叉树最后一个节点为整课数的最大值.固定最后一个节点,其余部分则又形成一个新的相对稳定的二叉树，此时,需要重新整理,使其更加稳定.如此反复操作,最后形成一个由小到大的有序的二叉树
    for (int i = (int)array.count-1; i>0; --i) {
        //将最后一个节点和根节点交换
        id temp = array[i];
        array[i] = array[0];
        array[0] = temp;
        
        //新的二叉树发生变化，重新整理
        [self heapSortingWithArray:array startIndex:0 arrayifCount:i];
    }
}

//自上而下整理,从指定的节点开始向下形成的相对稳定的二叉树,从而使此棵二叉树更加稳定
-(void)heapSortingWithArray:(NSMutableArray *)array startIndex:(int)startIndex arrayifCount:(int)count{
    //取出开始节点值
    id temp = array[startIndex];
    //开始节点的左侧子节点
    int child = 2*startIndex +1;
    
    //从指定节点遍历到叶子节点,结束条件是 child >= count 或者节点比其两侧子节点都大
    while (child<count) {
        //左右两侧子节点比较大小,选出最大的节点为子节点
        if (child+1<count &&array[child]<array[child+1]) {//右侧子节点数小于总的节点数&右侧子节点大于左侧子节点
            ++child;//更新右侧子节点为子节点
        }
        //比较节点是否比其两侧最大子节点大,是则退出,否则交换节点和最大子节点,以发生变化的子节点为节点继续向下整理
        if (array[startIndex]<array[child]) {//节点小于最大子节点
            //交换节点值和最大子节点值
            array[startIndex] = array[child];
            array[child] = temp;
            //节点指向最大子节点,子节点指向新的子节点
            startIndex = child;
            child = 2*startIndex+1;
        }else{
            //子节点与节点值未发生交换，退出二叉树的整理
            break;
        }
    }
}


#pragma mark - 基数排序(分配排序)(升序)----1
- (void)radixAscendingOrderSort:(NSMutableArray *)ascendingArr {
    //创建桶
    NSMutableArray *buckt = [self createBucket];
    //寻找数组中最大值
    NSNumber *maxnumber = [self listMaxItem:ascendingArr];
    //最大值的位数
    NSInteger maxLength = numberLength(maxnumber);
    
    //对数组进行 maxLength 次排序
    for (int digit = 1; digit <= maxLength; digit++) {//依据数组元素的第 digit 位数进行排放(元素最右边为第 1 位)
        //放入元素
        // 依据数组元素的第 digit 位数,并放到其相应的数组中
        for (NSNumber *item in ascendingArr) {
            //取出 item 中右边第 digit 位数字
            NSInteger baseNumber = [self fetchBaseNumber:item digit:digit];
            //取出 buckt 数组中第 baseNumber 数组
            NSMutableArray *mutArray = buckt[baseNumber];
            //把 Item 放入对应的数组中
            [mutArray addObject:item];
        }
        
        //取元素
        //初始化index,代表取出的第几个元素
        NSInteger index = 0;
        //依次从 buckt 中取出元素放入 ascendingArr 数组中
        for (int i = 0; i < buckt.count; i++) {
            //取出 buckt 中第 i 个数组
            NSMutableArray *array = buckt[i];
            //数组中是存在元素
            while (array.count != 0) {
                //依次取出元素放到 ascendingArr 数组中,并清掉原来数组中对应的元素
                NSNumber *number = [array objectAtIndex:0];
                ascendingArr[index] = number;
                [array removeObjectAtIndex:0];
                index++;
            }
        }
    }
    NSLog(@"希尔升序排序结果：%@", ascendingArr);
}
//创建一个可变数组中包含十个可变的数组
- (NSMutableArray *)createBucket {
    NSMutableArray *bucket = [NSMutableArray array];
    for (int index = 0; index < 10; index++) {
        NSMutableArray *array = [NSMutableArray array];
        [bucket addObject:array];
    }
    return bucket;
}
//选出数组中最大的元素
- (NSNumber *)listMaxItem:(NSArray *)list {
    NSNumber *maxNumber = list[0];
    for (NSNumber *number in list) {
        if ([maxNumber integerValue] < [number integerValue]) {
            maxNumber = number;
        }
    }
    return maxNumber;
}
//获取数据的位数
NSInteger numberLength(NSNumber *number) {
    NSString *string = [NSString stringWithFormat:@"%ld", (long)[number integerValue]];
    return string.length;
}

//取出 number 中右边第 digit 位数字
- (NSInteger)fetchBaseNumber:(NSNumber *)number digit:(NSInteger)digit {
    if (digit > 0 && digit <= numberLength(number)) {
        //初始化可变数组
        NSMutableArray *numbersArray = [NSMutableArray array];
        //将数据转化为字符串
        NSString *string = [NSString stringWithFormat:@"%ld", [number integerValue]];
        //将字符串转化数组
        for (int index = 0; index < numberLength(number); index++) {
            //将数据的每位数,一次放到可变数组中
            [numbersArray addObject:[string substringWithRange:NSMakeRange(index, 1)]];
        }
        //从可变数组中取出字符串倒数第 digit 位字符
        NSString *str = numbersArray[numbersArray.count - digit];
        //字符转化为数字返回
        return [str integerValue];
    }
    return 0;
}


#pragma mark - 基数排序(分配排序)
- (void)radixAsngOrderSort:(NSMutableArray *)arr {
    //增量gap，并逐步缩小增量
    for (int gap = (int)arr.count/2; gap > 0; gap /= 2) {
        for (int i = gap; i < arr.count; i++) {
            int j = i;
            while (j - gap >= 0 && arr[j] < arr[j-gap]) {
                int temp = [arr[j] intValue];
                arr[j] = arr[j - gap];
                arr[j - gap] =  [NSNumber numberWithInt:temp];
                j-=gap;;
            }
        }
    }
//    for(int gap = (int)arr.count/2; gap>0; gap/=2){
//        //从第gap个元素，逐个对其所在组进行直接插入排序操作
//        for(int i=gap;i<arr.count;i++){
//            int j = i;
//            while(j-gap>=0 && arr[j]<arr[j-gap]){
//                //插入排序采用交换法
//
//                arr[j] = (int)arr[j] + (int)arr[j-gap];
//                arr[j-gap] = (int)arr[j] - (int)arr[j-gap];
//                arr[j] = (int)arr[j] - (int)arr[j-gap];
//
//                j-=gap;
//            }
//        }
//    }
    NSLog(@"基数升序排序结果：%@", arr);
}

void swap(int arr[] ,int a,int b){
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
