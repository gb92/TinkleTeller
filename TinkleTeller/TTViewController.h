//
//  TTViewController.h
//  TinkleTeller
//
//  Created by Gavin Benedict on 2/21/14.
//
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface TTViewController : UIViewController <CBPeripheralDelegate>

@property (strong, nonatomic) CBPeripheral * connectedPeripheral;

@end
