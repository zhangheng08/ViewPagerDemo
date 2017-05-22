//
//  ZWBaseView.m
//  zhiwang_Pro
//
//  Created by 张恒 on 2017/2/3.
//  Copyright © 2017年 zhiwang123. All rights reserved.
//

#import "ZWBaseView.h"
#import "MBProgressHUD.h"
//#import "HOMEHeader.h"

@implementation ZWBaseView

//@synthesize AFNManager = _AFNManager;

-(void) awakeFromNib {
    [super awakeFromNib];
//    _AFNManager = [AFHTTPRequestOperationManager manager];
}

-(void) toast:(NSString *) msg {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.yOffset = + 200;
    //hud.dimBackground = YES;
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelFont = [UIFont systemFontOfSize:13];
    hud.detailsLabelText = msg;
    [hud hide:YES afterDelay:1.5f];
    hud.removeFromSuperViewOnHide = YES;
    
}

-(MBProgressHUD *) progress {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.detailsLabelFont = [UIFont systemFontOfSize:13];
    hud.detailsLabelText = @"";
    hud.removeFromSuperViewOnHide = YES;
    return hud;
    
}

-(MBProgressHUD *) progress:(NSString *) message {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.detailsLabelFont = [UIFont systemFontOfSize:13];
    hud.detailsLabelText = message;
    hud.removeFromSuperViewOnHide = YES;
    return hud;
    
}

@end
