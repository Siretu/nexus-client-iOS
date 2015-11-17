//
//  NexusTableViewController.m
//  nexus-client-iOS
//
//  Created by Erik on 11/15/15.
//  Copyright © 2015 Erik. All rights reserved.
//

#import "JasperTableViewController.h"

@interface JasperTableViewController ()

// MARK: Properties
@property (weak, nonatomic) IBOutlet UISwitch *onlineSwitch;
@property (weak, nonatomic) IBOutlet UILabel *onlineLabel;


@end

@implementation JasperTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"Loaded TableViewController");
    NSString *jasperUrl = @"http://192.168.1.18:5000/nexus/api/jasper/status";
    NSDictionary *resp = [self makeRestAPICall: jasperUrl];
    NSInteger status = [(NSString*)[resp valueForKey:@"status"] integerValue];
    NSLog(@"Status: %ld", (long)status);
    NSLog(@"Status: %@", [resp description]);
    
    self.onlineSwitch.on = (status == 1);
    [self.tableView setSeparatorColor:[UIColor blackColor]];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)switchJasper:(UISwitch *)sender {
    NSString *jasperUrl = @"http://192.168.1.18:5000/nexus/api/jasper/status";
    NSMutableDictionary* tmp;
    if (sender.on) {
        NSLog(@"Switch is on");
        tmp = [[NSDictionary alloc] initWithObjectsAndKeys: @YES, @"status", nil];
        self.onlineLabel.text = @"Online";
    } else {
        tmp = [[NSDictionary alloc] initWithObjectsAndKeys: @NO, @"status", nil];
        self.onlineLabel.text = @"Offline";
    }
    NSLog(@"Dict: %@", [tmp description]);
    [self makeRestPostAPICall: jasperUrl PostDict:tmp];
}

-(NSDictionary*) makeRestAPICall : (NSString*) reqURLStr
{
    NSURLRequest *Request = [NSURLRequest requestWithURL:[NSURL URLWithString: reqURLStr]];
    NSURLResponse *resp = nil;
    NSError *error = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest: Request returningResponse: &resp error: &error];
    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
    return responseDict;
}

-(void) makeRestPostAPICall : (NSString*) reqURLStr PostDict:(NSDictionary*) postDict {
    NSData *postData = [NSJSONSerialization dataWithJSONObject:postDict options:0 error:nil];
    NSString *postLength = [NSString stringWithFormat:@"%lu",[postData length]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: reqURLStr]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(conn) {
        NSLog(@"Connection Successful");
    } else {
        NSLog(@"Connection could not be made");
    }
    /*NSURLResponse *resp = nil;
    NSError *error = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest: request returningResponse: &resp error: &error];
    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:response options:nil error:nil];
    return responseDict;*/
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //return nil;
    /*UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NexusClassIdentifier" forIndexPath:indexPath];
    NSLog(@"Foo");
    if (cell == nil) {
        NSLog(@"IS nil");
    }
    cell.textLabel.text = @"Jasper";
    // Configure the cell...
    
    return cell;*/
//}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
