//
//  InnerCell.h
//  ViewPagerDemo
//
//  Created by 张恒 on 2017/5/22.
//  Copyright © 2017年 none. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InnerCell : UIView

@property (weak, nonatomic) IBOutlet UILabel *index_lbl;

-(void) setIndex:(NSInteger) index;

+(instancetype) initViewLayout;

@end
