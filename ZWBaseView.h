//
//  ZWBaseView.h
//  zhiwang_Pro
//
//  Created by 张恒 on 2017/2/3.
//  Copyright © 2017年 zhiwang123. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
//#import "AFHTTPRequestOperationManager.h"

@interface ZWBaseView : UIView

//@property (strong, nonatomic) AFHTTPRequestOperationManager *AFNManager;

@property (strong, nonatomic) UIView *parent_view;

-(void) toast:(NSString *) msg;
-(MBProgressHUD *) progress;
-(MBProgressHUD *) progress:(NSString *) message;

@end
