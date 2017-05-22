//
//  ZHViewPagerBlock.m
//  zhiwang_Pro
//
//  Created by 张恒 on 2017/2/20.
//  Copyright © 2017年 zhiwang123. All rights reserved.
//

#import "ZHViewPagerBlock.h"
#import "Masonry.h"

@implementation ZHViewPagerBlock
{

    __weak UIView *cell;

}

+(instancetype) initViewLayout {
    
    ZHViewPagerBlock *block = [[[NSBundle mainBundle] loadNibNamed:@"view_pager_block" owner:nil options:nil] lastObject];
    
    return block;
    
}

-(void) attachCell:(UIView *) c {
    
    cell = c;
    
    [self addSubview:cell];
    
//    [cell mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.width.mas_equalTo(self.mas_width);
//        make.height.mas_equalTo(self.mas_height);
//        make.centerX.mas_equalTo(self.mas_centerX);
//        make.centerY.mas_equalTo(self.mas_centerY);
//        
//    }];
    
    cell.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);

}

-(UIView *) deattachCell {

    if(cell) {
        [cell removeFromSuperview];
    }
    
    return cell;

}

@end
