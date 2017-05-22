//
//  ZHViewPagerBlock.h
//  zhiwang_Pro
//
//  Created by 张恒 on 2017/2/20.
//  Copyright © 2017年 zhiwang123. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHViewPagerBlock : UIView

+(instancetype) initViewLayout;

-(void) attachCell:(UIView *) c;

-(UIView *) deattachCell;

@end
