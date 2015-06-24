//
//  HYMALine.h
//  jimustock
//
//  Created by jimubox on 15/5/28.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HYMAType){
    HYMA5Type = 0,
    HYMA10Type,
    HYMA20Type,
    HYMA30Type
};

/************************画均线的画笔************************/
@interface HYMALine : NSObject

@property(nonatomic,strong) NSArray *MAPositions;

@property(nonatomic,assign) HYMAType MAType;

/**
 *  根据context初始化均线画笔
 */
-(instancetype)initWitContext:(CGContextRef)context;

-(void)draw;

@end
