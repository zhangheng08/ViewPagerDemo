//
//  ViewController.h
//  ViewPagerDemo
//
//  Created by 张恒 on 2017/5/22.
//  Copyright © 2017年 none. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZHViewPager.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIButton *centerBtn;

-(IBAction) toLastOne:(id)sender;
-(IBAction) toNextONe:(id)sender;
-(IBAction) toCenter:(id)sender;

@end

