//
//  TTBluetoothConnectView.h
//  TinkleTeller
//
//  Created by Gavin Benedict on 2/22/14.
//
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "TTBluetoothDeviceListDelegate.h"

@interface TTBluetoothConnectView : UIViewController <UITableViewDataSource, UITableViewDelegate, TTBluetoothDeviceListDelegate>


@end
