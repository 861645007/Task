//
//  LocationAttendanceViewController.h
//  Task
//
//  Created by wanghuanqiang on 14/12/17.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "BaseViewController.h"
#import "RBImagePickerController.h"

@interface LocationAttendanceViewController : BaseViewController<UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, copy) NSString *attendancePatten;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *address;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;

- (IBAction)sureAttendance:(id)sender;
- (IBAction)hiddenKeyboard:(id)sender;

@end
