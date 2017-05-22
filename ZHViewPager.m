//
//  ZHViewPager.m
//  zhiwang_Pro
//
//  Created by 张恒 on 2017/2/20.
//  Copyright © 2017年 zhiwang123. All rights reserved.
//

#import "ZHViewPager.h"
#import "ZHViewPagerBlock.h"
//#import "HOMEHeader.h"
#import "Masonry.h"

#define MAX_BLOCK 5
#define TRAILING_BLOCK_INDEX 4
#define CENTER_BLOCK_INDEX 2
#define MARGIN_DEFAULT 10

@implementation ZHViewPager
{

    NSMutableArray *reuseViewQueen;
    NSMutableArray *centerArray;
    NSMutableDictionary *reuseCellDic;
    
    NSInteger margin;
    NSInteger count;
    
    CGPoint tapPoint;
    CGFloat width;
    CGFloat height;
    
    NSInteger currentBlockIndex;
    NSInteger dataIndex;
    NSInteger pageCount;
    
    BOOL isBusy;

}

+(instancetype) createInstance {

    ZHViewPager *viewPager = [[[NSBundle mainBundle] loadNibNamed:@"view_pager" owner:nil options:nil] firstObject];
    
    return viewPager;

}

-(void) awakeFromNib {

    [super awakeFromNib];
    
    margin = MARGIN_DEFAULT;
    
    currentBlockIndex = 0;
    dataIndex = 0;
    pageCount = 1;
    tapPoint = CGPointMake(-100, 0);
    
    width =  [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    reuseViewQueen = [NSMutableArray array];
    reuseCellDic = [NSMutableDictionary dictionary];

    [self initBlocks];
}

-(void) initBlocks {
    
    [self.content_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width * 9);
        make.height.mas_equalTo(self.mas_height);
        make.top.mas_equalTo(self.mas_top);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    for(int i = 0; i < MAX_BLOCK; i ++) {
        
        ZHViewPagerBlock *block = [ZHViewPagerBlock initViewLayout];
        [reuseViewQueen addObject:block];
        [self.content_view addSubview:block];
        
        [block mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(self.content_view.mas_height);
            make.top.mas_equalTo(self.content_view.mas_top);
            make.leading.mas_equalTo(4*width + i*width + (i)*margin);
            
        }];
        
        //block.frame = CGRectMake(4*width + i*width + (i)*margin, 0, width, self.content_view.frame.size.height);
        if(i > pageCount - 1) [block setHidden:YES];
        //[block setBackgroundColor:RGB_COLOR(arc4random() % 256, arc4random() % 256, arc4random() % 256)];
        
    }

}

-(void) reloadData {

    if(!self.delegate) return;
    
    [reuseCellDic removeAllObjects];
    
    pageCount = [self.delegate numberOfPage];
    
    for(int i = 0; i < MAX_BLOCK; i ++) {
        
        ZHViewPagerBlock *block = [reuseViewQueen objectAtIndex:i];
        
        if(i > pageCount - 1) {
            
            [block setHidden:YES];
            return;
        }
        
        UIView *cell = [self.delegate viewPagerAttachCell:self indexOf:dataIndex == 0 ? i : dataIndex - currentBlockIndex + i];
        
        [block deattachCell];
        [block attachCell:cell];
        
        [block setHidden:NO];
        
    }

}



-(void) setPageMargin:(NSInteger)m {

    margin = m;
    
}


-(IBAction) panToDrag:(UIPanGestureRecognizer *)ges {
    
    CGPoint p = [ges locationInView:self];
    
    if(tapPoint.x < 0) {
        
        tapPoint = p;
        
        [self resetPos];
        
    }
    
    float offset = p.x - tapPoint.x;
    
    if(dataIndex == 0 && offset > 0) {
    
        offset = offset > 20 ? 20 : offset;
    
    } else if(dataIndex == pageCount - 1 && offset < 0) {
    
        offset = offset <  20 ?  - 20 : offset;
        
    }
    
    for(int i = 0; i < MAX_BLOCK; i ++) {

        ZHViewPagerBlock *block = [reuseViewQueen objectAtIndex:i];
        
        block.frame = CGRectMake([[centerArray objectAtIndex:i] floatValue] + offset, 0, width, self.content_view.bounds.size.height);
    
    }
    
    if (ges.state == UIGestureRecognizerStateEnded || ges.state == UIGestureRecognizerStateCancelled) {
        
        ZHViewPagerBlock *block = [reuseViewQueen objectAtIndex:currentBlockIndex];
        
        if(block.frame.origin.x > 4.2f * width) {
            
            [self toPrevPage:YES];
            
        } else if (block.frame.origin.x + width < 4.8f * width) {
            
            [self toNextPage:YES];
            
        } else {
        
            for(int i = 0; i < MAX_BLOCK; i ++) {
                
                ZHViewPagerBlock *block = [reuseViewQueen objectAtIndex:i];
                
                [UIView animateWithDuration:(0.5)//动画持续时间
                                      delay:(0)//动画延迟执行的时间
                     usingSpringWithDamping:(0.8)//震动效果，范围0~1，数值越小震动效果越明显
                      initialSpringVelocity:(0)//初始速度，数值越大初始速度越快
                                    options:(UIViewAnimationOptionCurveLinear)//动画的过渡效果
                                 animations:^{

                                     block.frame = CGRectMake([[centerArray objectAtIndex:i] floatValue], 0, width, self.content_view.bounds.size.height);
                                     
                                 }
                                 completion:^(BOOL finished) {
                                     
                                     
                                     
                                 }];
                
            }
        
        }
        
        tapPoint = CGPointMake(-10000, 0);
    }
}

-(void) toNextPage:(BOOL) anim {

    for(int i = 0; i < MAX_BLOCK; i ++) {
        
        ZHViewPagerBlock *block = [reuseViewQueen objectAtIndex:i];
        
        [UIView animateWithDuration:(anim ? 0.5 : 0.0)//动画持续时间
                              delay:(0)//动画延迟执行的时间
             usingSpringWithDamping:(anim ? 0.8 : 1.0)//震动效果，范围0~1，数值越小震动效果越明显
              initialSpringVelocity:(0)//初始速度，数值越大初始速度越快
                            options:(UIViewAnimationOptionCurveLinear)//动画的过渡效果
                         animations:^{
                             
                             block.frame = CGRectMake([[centerArray objectAtIndex:i] floatValue] - width - margin, 0, width, self.content_view.bounds.size.height);
                             
                         }
                         completion:^(BOOL finished) {
                             
                             
                             if(i == MAX_BLOCK - 1) {
                                 
                                 if(dataIndex < pageCount - 1) {
                                     
                                     ++ currentBlockIndex;
                                     ++ dataIndex;
                                     if(_pageChangeCallback) [_pageChangeCallback onPageChange:dataIndex];
                                     
                                 }
                                 
                                 if(dataIndex > 2 && dataIndex < pageCount - 2) {
                                     
                                     ZHViewPagerBlock *block = [reuseViewQueen objectAtIndex:0];
                                     [reuseViewQueen removeObjectAtIndex:0];
                                     [reuseViewQueen insertObject:block atIndex:MAX_BLOCK - 1];
                                     block.frame = CGRectMake((MAX_BLOCK + 1)*width + 2*margin, 0, width, self.content_view.bounds.size.height);
                                     
                                     if(self.delegate) {
                                         UIView *cell = [block deattachCell];
                                         if(!cell) return;
                                         [reuseCellDic setObject:cell forKey:CELL_WHEEL];
                                         UIView *newCell = [self.delegate viewPagerAttachCell:self indexOf:dataIndex + 2];
                                         [block attachCell:newCell];
                                     }
                                     
                                     -- currentBlockIndex;
                                 }
                                 
                                 isBusy = false;
                                 NSLog(@"block_index: %d, dataIndex: %d", (int)currentBlockIndex, (int)dataIndex);
                                 
                             }
                             
                         }];
        
    }

}

-(void) toPrevPage:(BOOL) anim {

    for(int i = 0; i < MAX_BLOCK; i ++) {
        
        ZHViewPagerBlock *block = [reuseViewQueen objectAtIndex:i];
        
        [UIView animateWithDuration:(anim ? 0.5 : 0.0)//动画持续时间
                              delay:(0)//动画延迟执行的时间
             usingSpringWithDamping:(anim ? 0.8 : 1)//震动效果，范围0~1，数值越小震动效果越明显
              initialSpringVelocity:(0)//初始速度，数值越大初始速度越快
                            options:(UIViewAnimationOptionCurveLinear)//动画的过渡效果
                         animations:^{
                             
                             block.frame = CGRectMake([[centerArray objectAtIndex:i] floatValue] + width + margin, 0, width, self.content_view.bounds.size.height);
                             
                         }
                         completion:^(BOOL finished) {
                             
                             if(i == MAX_BLOCK - 1) {
                                 
                                 if(dataIndex > 0) {
                                     
                                     -- currentBlockIndex;
                                     -- dataIndex;
                                     if(_pageChangeCallback) [_pageChangeCallback onPageChange:dataIndex];
                                     
                                 }
                                 
                                 if(dataIndex > 1 && dataIndex < pageCount - 3) {
                                     
                                     ZHViewPagerBlock *block = [reuseViewQueen lastObject];
                                     [reuseViewQueen removeLastObject];
                                     [reuseViewQueen insertObject:block atIndex:0];
                                     block.frame = CGRectMake(2*width - 2*margin, 0, width, self.content_view.bounds.size.height);
                                     
                                     if(self.delegate) {
                                         UIView *cell = [block deattachCell];
                                         if(!cell) return;
                                         [reuseCellDic setObject:cell forKey:CELL_WHEEL];
                                         UIView *newCell = [self.delegate viewPagerAttachCell:self indexOf:dataIndex - 2];
                                         [block attachCell:newCell];
                                     }
                                     
                                     ++ currentBlockIndex;
                                 }
                                 
                                 isBusy = false;
                                 NSLog(@"block_index: %d, dataIndex: %d", (int)currentBlockIndex, (int)dataIndex);
                                 
                             }
                             
                         }];
        
    }
//    if(_pageChangeCallback) [_pageChangeCallback onPageChange:dataIndex];
}

-(void) selectPageAtIndex:(int)index anim:(BOOL)showAnim {

    if(index == dataIndex || index < 0 || index > pageCount - 1) return;
    
    if(isBusy) return;
    
    isBusy = true;
    
    [self resetPos];
    
    if((dataIndex > 1 && dataIndex < pageCount - 2) && (index > 1 && index < pageCount - 2)) {
        
        currentBlockIndex = CENTER_BLOCK_INDEX;
        dataIndex = index;
        
        for(int i = 0; i < MAX_BLOCK; i ++) {
            ZHViewPagerBlock *block = [reuseViewQueen objectAtIndex:i];
            if(self.delegate) {
                UIView *cell = [block deattachCell];
                if(!cell) return;
                [reuseCellDic setObject:cell forKey:CELL_WHEEL];
                UIView *newCell = [self.delegate viewPagerAttachCell:self indexOf:dataIndex - 2 + i];
                [block attachCell:newCell];
            }
            
        }
        
        isBusy = false;
        return;
    }
    
    
    int step = 0;
    if(index > dataIndex) {
        
        if(pageCount < MAX_BLOCK) {
            step = index - (int) dataIndex;
        } else {
            if(index < CENTER_BLOCK_INDEX) {
                [self toNextPage:showAnim];
                return;
            } else if(index > 1 && index < pageCount - 2) {
                step = CENTER_BLOCK_INDEX - (int)dataIndex;
            } else if(index > pageCount - 3) {
                if(dataIndex < CENTER_BLOCK_INDEX) {
                    step = TRAILING_BLOCK_INDEX - ((int)pageCount - 1 - index) - (int)dataIndex;
                } else if(dataIndex > 1 && dataIndex < pageCount - 2) {
                    step = TRAILING_BLOCK_INDEX - ((int)pageCount - 1 - index) - 2;
                } else if(index > pageCount - 3) {
                    [self toNextPage:showAnim];
                    return;
                }
            }
        }
        
        currentBlockIndex += step;
        dataIndex = index;
        for(int i = 0; i < MAX_BLOCK; i ++) {
            ZHViewPagerBlock *block = [reuseViewQueen objectAtIndex:i];
            int originX = block.frame.origin.x;
            int offset = (block.frame.size.width + margin)* step;
            int newX = originX - offset;
            [UIView animateWithDuration:(showAnim ? 0.5 : 0) delay:(0)
                usingSpringWithDamping:(10)
                initialSpringVelocity:(0) options:(UIViewAnimationOptionCurveLinear)
                             animations:^{
                                 block.frame = CGRectMake(newX, 0, width, self.content_view.bounds.size.height);
                             } completion:^(BOOL finished) {
                                 if(self.delegate) {
                                     UIView *cell = [block deattachCell];
                                     if(!cell) return;
                                     [reuseCellDic setObject:cell forKey:CELL_WHEEL];
                                     UIView *newCell = [self.delegate viewPagerAttachCell:self indexOf:dataIndex - currentBlockIndex + i];
                                     [block attachCell:newCell];
                                 }
                                 isBusy = false;
                             }];
        }
    } else {
        
        if(pageCount < MAX_BLOCK) {
            step = (int) dataIndex - index;
        } else {
            if(index > pageCount - 3) {
                [self toPrevPage:showAnim];
                return;
            } else if(index > 1 && index < pageCount - 2) {
                step = TRAILING_BLOCK_INDEX - ((int)pageCount - (int)dataIndex - 1) - 2;
            } else if(index < CENTER_BLOCK_INDEX) {
                if(dataIndex > pageCount - 3) {
                    step = TRAILING_BLOCK_INDEX - ((int)pageCount - (int)dataIndex - 1) - index;
                } else if(dataIndex > 1 && dataIndex < pageCount - 2) {
                    step = CENTER_BLOCK_INDEX - index;
                } else if(dataIndex < CENTER_BLOCK_INDEX) {
                    [self toPrevPage:showAnim];
                    return;
                }
            }
        }
        
        currentBlockIndex -= step;
        dataIndex = index;
        for(int i = 0; i < MAX_BLOCK; i ++) {
            ZHViewPagerBlock *block = [reuseViewQueen objectAtIndex:i];
            int originX = block.frame.origin.x;
            int offset = (block.frame.size.width + margin) * step;
            int newX = originX + offset;
            [UIView animateWithDuration:(showAnim ? 0.5 : 0) delay:(0)
                 usingSpringWithDamping:(10)
                  initialSpringVelocity:(0) options:(UIViewAnimationOptionCurveLinear)
                             animations:^{
                                 block.frame = CGRectMake(newX, 0, width, self.content_view.bounds.size.height);
                             } completion:^(BOOL finished) {
                                 if(self.delegate) {
                                     UIView *cell = [block deattachCell];
                                     if(!cell) return;
                                     [reuseCellDic setObject:cell forKey:CELL_WHEEL];
                                     UIView *newCell = [self.delegate viewPagerAttachCell:self indexOf:dataIndex - currentBlockIndex + i];
                                     [block attachCell:newCell];
                                 }
                                 isBusy = false;
                             }];
        }
    }
    if(_pageChangeCallback) [_pageChangeCallback onPageChange:dataIndex];
}

-(void) resetPos {

    if(centerArray != nil) centerArray = nil;
    
    centerArray = [NSMutableArray arrayWithCapacity:5];
    
    for(ZHViewPagerBlock *block in reuseViewQueen) {
        
        CGFloat left = block.frame.origin.x;
        [centerArray addObject:[NSNumber numberWithFloat:left]];
    }

}

-(void) frontPos:(int) index {

    if(dataIndex == 0) {
        [self toNextPage:NO];
        [self toNextPage:NO];
    } else if(dataIndex == 1) {
        [self toNextPage:NO];
    }
    
    if(index == 2) return;
    
    dataIndex = index;
    
    for(int i = 0; i < MAX_BLOCK; i ++) {
        
        ZHViewPagerBlock *block = [reuseViewQueen objectAtIndex:i];
        
        if(i > pageCount - 1) {
            
            [block setHidden:YES];
            return;
        }
        
        UIView *cell = [self.delegate viewPagerAttachCell:self indexOf:dataIndex - 2 + i];
        
        [block deattachCell];
        [block attachCell:cell];
        [block setHidden:NO];
        
    }

}

-(void) backPos:(int) index {
    
    if(dataIndex == pageCount - 1) {
        [self toPrevPage:NO];
        [self toPrevPage:NO];
    } else if(dataIndex == pageCount - 2) {
        [self toPrevPage:NO];
    }
    
    if(index == pageCount - 3) return;
    
    dataIndex = index;
    
    for(int i = 0; i < MAX_BLOCK; i ++) {
        
        ZHViewPagerBlock *block = [reuseViewQueen objectAtIndex:i];
        
        if(i > pageCount - 1) {
            
            [block setHidden:YES];
            return;
        }
        
        UIView *cell = [self.delegate viewPagerAttachCell:self indexOf:dataIndex - 2 + i];
        
        [block deattachCell];
        [block attachCell:cell];
        [block setHidden:NO];
        
    }
    
}

-(NSInteger) getCurrentPageIndex {

    return dataIndex;

}

-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    UITouch *touch = [touches anyObject];
    
    tapPoint = [touch locationInView:self];
    
    [self resetPos];

}

-(UIView *) reuseCell:(NSString *)key {

    UIView * v = [reuseCellDic objectForKey:key];
    return v;
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//        if (gestureRecognizer == self.pan_ges) {
//            if ([touch.view isKindOfClass:[UIButton class]]) {
//                return NO;
//            }
//            if ([touch.view isKindOfClass:[UITableView class]]) {
//                return YES;
//            }
//            if ([touch.view isKindOfClass:[UISlider class]]) {
//                return NO;
//            }
//            if ([touch.view isKindOfClass:[UIImageView class]]) {
//                return NO;
//            }
//            if ([touch.view isKindOfClass:[UITableViewCell class]]) {
//                return NO;
//            }
//            // UITableViewCellContentView => UITableViewCell
//            if([touch.view.superview isKindOfClass:[UITableViewCell class]]) {
//                return NO;
//            }
//            // UITableViewCellContentView => UITableViewCellScrollView => UITableViewCell
//            if([touch.view.superview.superview isKindOfClass:[UITableViewCell class]]) {
//                return NO;
//            }
//        }
    return YES;
}

@end
