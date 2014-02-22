//
//  TTBluetoothConnectView.h
//  TinkleTeller
//
//  Created by Gavin Benedict on 2/22/14.
//
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface TTBluetoothConnectView : UIViewController <CBCentralManagerDelegate, CBPeripheralDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) CBCentralManager* centralManager;


@end
