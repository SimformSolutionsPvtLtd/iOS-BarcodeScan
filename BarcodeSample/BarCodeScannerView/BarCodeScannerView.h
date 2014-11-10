//
//  BarCodeScannerView.h
//  MissionRabiesApp
//
//  Created by Sunil Chauhan on 06/11/14.
//  Copyright (c) 2014 Shah.Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef void(^BarCodeScanCompletionBlock) (NSString *result);

@interface BarCodeScannerView : UIViewController <AVCaptureMetadataOutputObjectsDelegate>{
    IBOutlet UIView *viewResultMain;
    IBOutlet UIView *viewResult;
    IBOutlet UITextView *txtResult;
    IBOutlet NSLayoutConstraint *viewResultCenterYAlignConstraint;
    
    NSString *resultString;
}

@property (nonatomic,copy) BarCodeScanCompletionBlock completionBlock;

-(IBAction) doneTapped:(id)sender;
-(IBAction) retryTapped:(id)sender;

+(void) showScannerWithCompletionBlock:(BarCodeScanCompletionBlock)completionBlock;


@end
