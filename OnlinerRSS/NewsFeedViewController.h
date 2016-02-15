//
//  NewsFeedViewController.h
//  OnlinerRSS
//
//  Created by Vladislav on 15.02.16.
//  Copyright © 2016 domik. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewsFeedViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end
