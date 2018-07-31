//
//  NSArray+LXDExtension.m
//  MyiOSFramework
//
//  Created by Yonggui Wang on 2018/7/30.
//  Copyright © 2018年 Weiwei Wang. All rights reserved.
//

#import "NSArray+LXDExtension.h"

@implementation NSArray (LXDExtension)

- (WWWArrayChange)arrayChange {
    WWWArrayChange arrayChange = (WWWArrayChange)^(WWWItemChange itemChange){
        NSMutableArray *mArray = [NSMutableArray array];
        for (id item in self) {
            [mArray addObject:itemChange(item)];
        }
        return mArray;
    };
    
    return arrayChange;
}

- (WWWArrayFilter)arrayFileter {
    WWWArrayFilter arrayFilter = (WWWArrayFilter)^(WWWItemFilter itemFilter) {
        NSMutableArray *mArray = [NSMutableArray array];
        for (id item in self) {
            BOOL isFileter = itemFilter(item);
            if (isFileter) {
                [mArray addObject:item];
            }
        }
        return mArray;
    };
    
    return arrayFilter;
}
@end
