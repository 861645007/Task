//
//  ImageAccessorysViewController.h
//  Task
//
//  Created by wanghuanqiang on 14/12/26.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "BaseViewController.h"

@interface ImageAccessorysViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;

- (IBAction)deleteImage:(id)sender;

@end
