//
//  ViewController.m
//  ViewPagerDemo
//
//  Created by 张恒 on 2017/5/22.
//  Copyright © 2017年 none. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "InnerCell.h"

@interface ViewController () <ZHViewPagerDelegate, PageChangeCallback> {

    ZHViewPager *viewPager;

}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    viewPager = [ZHViewPager createInstance];
    
    [self.contentView addSubview:viewPager];
    
    [viewPager mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.contentView.mas_top);
        make.leading.mas_equalTo(self.contentView.mas_leading);
        make.width.mas_equalTo(self.contentView.mas_width);
        make.height.mas_equalTo(self.contentView.mas_height);
        
    }];
    
//    viewPager.frame = self.contentView.frame;
    
    viewPager.pageChangeCallback = self;
    viewPager.delegate = self;
    
    [viewPager reloadData];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) numberOfPage {
    
    return 10;

}


-(UIView *) viewPagerAttachCell:(ZHViewPager *) pager indexOf:(NSInteger) index {

    InnerCell *cell = (InnerCell *)[pager reuseCell:CELL_WHEEL];
    
    if(cell == nil) {
        cell = [InnerCell initViewLayout];
    }
    
    [cell setIndex:index];
    
    return cell;
}

-(void) onPageChange:(NSInteger) currentIndex {

    NSLog(@"current page index : %d", (int) currentIndex);

}

-(IBAction) toLastOne:(id)sender {

    [viewPager selectPageAtIndex:(int)(viewPager.getCurrentPageIndex - 1) anim:NO];

}

-(IBAction) toNextONe:(id)sender {

    [viewPager selectPageAtIndex:(int)(viewPager.getCurrentPageIndex + 1) anim:NO];

}

-(IBAction) toCenter:(id)sender {

    [viewPager selectPageAtIndex:4 anim:NO];
    
}

@end
