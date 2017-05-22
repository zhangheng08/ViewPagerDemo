//
//  ZHViewPager.h
//  zhiwang_Pro
//
//  Created by 张恒 on 2017/2/20.
//  Copyright © 2017年 zhiwang123. All rights reserved.
//

#import "ZWBaseView.h"
#define CELL_WHEEL @"cell_reuse_key"

@class ZHViewPager;
@protocol ZHViewPagerDelegate <NSObject>

-(NSInteger) numberOfPage;
-(UIView *) viewPagerAttachCell:(ZHViewPager *) pager indexOf:(NSInteger) index;

@end

@protocol PageChangeCallback <NSObject>

-(void) onPageChange:(NSInteger) currentIndex;

@end

@interface ZHViewPager : ZWBaseView <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *content_view;
@property (weak, nonatomic) IBOutlet UIPanGestureRecognizer *pan_ges;
//@property (weak, nonatomic) IBOutlet UISwipeGestureRecognizer *swip_right_ges;
//@property (weak, nonatomic) IBOutlet UISwipeGestureRecognizer *swip_left_ges;

@property (weak, nonatomic) id<ZHViewPagerDelegate> delegate;
@property (weak, nonatomic) id<PageChangeCallback> pageChangeCallback;

+(instancetype) createInstance;

-(void) reloadData;

-(UIView *) reuseCell:(NSString *) key;

-(void) selectPageAtIndex:(int)index anim:(BOOL)showAnim;

-(NSInteger) getCurrentPageIndex;

-(IBAction) panToDrag:(UIPanGestureRecognizer *)ges;

//-(IBAction) swipAction:(UISwipeGestureRecognizer *)ges;

@end

