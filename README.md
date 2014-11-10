### iOS-BarcodeScan - By Sunil Chauhan @Simform Solutions
#### Version: 1.0
##### Supported Barcode Types:
- AVMetadataObjectTypeAztecCode,
- AVMetadataObjectTypeCode128Code,
- AVMetadataObjectTypeCode39Code,
- AVMetadataObjectTypeCode39Mod43Code,
- AVMetadataObjectTypeCode93Code,
- AVMetadataObjectTypeEAN13Code,
- AVMetadataObjectTypeEAN8Code,
- AVMetadataObjectTypePDF417Code,
- AVMetadataObjectTypeQRCode,
- AVMetadataObjectTypeUPCECode


#### Description:
Barcode scanning is general feature which require in most of the application so here is the simple barcode scanning code with just 2-3 steps. This the sample project so you can test it before implementing in the working code. Below is the steps how to implement this code in your code.

#### How to use:

##### Step 1: 
Download the zip file and drag "BarCodeScannerView" folder to your project.
##### Step 2:
Import class file "#import "BarCodeScannerView.h" in your view controller file.
##### Step 3:
Write the following method that will return you the scanned text.
```sh
[BarCodeScannerView showScannerWithCompletionBlock:^(NSString *result) {
        if (result != nil && ![result isEqualToString:@""]) {
            //some text has been scanned and text will return.
            NSLog(@"%@",result);
        }
    }];
```
##### Step 4:
Run project and scan barcode.


License
----

Simform Solutions Pvt Ltd



