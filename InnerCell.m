//
//  InnerCell.m
//  ViewPagerDemo
//
//  Created by 张恒 on 2017/5/22.
//  Copyright © 2017年 none. All rights reserved.
//

#import "InnerCell.h"

@implementation InnerCell

+(instancetype) initViewLayout {

    InnerCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"InnerCell" owner:nil options:nil] firstObject];
    
    return cell;

}


-(void) awakeFromNib {

    [super awakeFromNib];
    
}

-(void) setIndex:(NSInteger) index {
    
    [_index_lbl setText:[NSString stringWithFormat:@"index : %d", (int) index]];
    
}

@end
