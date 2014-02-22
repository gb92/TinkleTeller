//
//  TTBluetoothConnectView.m
//  TinkleTeller
//
//  Created by Gavin Benedict on 2/22/14.
//
//

#import "TTBluetoothConnectView.h"
#import "TTViewController.h"
#import "TTBluetoothSingleton.h"

@interface TTBluetoothConnectView ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) TTBluetoothSingleton * ttBluetooth;

@property (strong, nonatomic) NSArray *deviceList;

@end

@implementation TTBluetoothConnectView


-(TTBluetoothSingleton *) ttBluetooth
{
    if(_ttBluetooth == nil)
    {
        _ttBluetooth=[TTBluetoothSingleton getInstance];
        [_ttBluetooth setDeviceListDelegate:self];
    }
    
    return _ttBluetooth;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)cancelButtonPressed:(id)sender {

   [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //[self.tableView ]
    
    //central manager stuff
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], CBCentralManagerScanOptionAllowDuplicatesKey, NO, nil];
    [self.ttBluetooth.centralManager scanForPeripheralsWithServices:nil options:options];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}



#pragma mark - UITableView Stuff

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.deviceList count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBPeripheral *device=(CBPeripheral *)self.deviceList[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell"];
    
    [cell.textLabel setText:[device.identifier UUIDString]];
    [cell.detailTextLabel setText:device.name];
    
    return cell;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBPeripheral *device=(CBPeripheral *)self.ttBluetooth.discoveredDevices[indexPath.row];
    
    [self.ttBluetooth connectToPeripheral:device];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void) deviceListUpdated:(NSArray *)deviceList
{
    NSLog(@"Device List Updated!");
    
    self.deviceList=deviceList;
    
    [self.tableView reloadData];
    
}



@end
