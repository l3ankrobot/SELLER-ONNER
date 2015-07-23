//
//  LoginViewController.m
//  SELLER-ONNER
//
//  Created by Bank on 7/20/2558 BE.
//  Copyright (c) 2558 TANONGSAK SEANGLUM. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tf_username;
@property (weak, nonatomic) IBOutlet UITextField *tf_password;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self didHidenBar];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        if (textField == self.tf_username) {
            [self.tf_username resignFirstResponder];
            [self.tf_password becomeFirstResponder];
        }else
            [self.tf_password resignFirstResponder];
    }
    return YES;
}

@end
