//
//  NewsFeedViewController.m
//  OnlinerRSS
//
//  Created by Vladislav on 15.02.16.
//  Copyright © 2016 domik. All rights reserved.
//

#import "NewsFeedViewController.h"
#import "NewsFeedTableViewCell.h"
#import "NewsDetailsViewController.h"
#import "News.h"


static NSString *CellIdentifier = @"CellIdentifier";


@interface NewsFeedViewController ()

@property (strong, nonatomic) NSArray *newsData;
@property (strong, nonatomic) NSMutableDictionary *offscreenCells;

@end


@implementation NewsFeedViewController


- (void)awakeFromNib
{
    self.offscreenCells = [NSMutableDictionary dictionary];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[NewsFeedTableViewCell class] forCellReuseIdentifier:CellIdentifier];
    
    self.newsData = [News MR_findAll];
    
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.newsData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    News *newsItem = [self.newsData objectAtIndex:indexPath.row];
    
    NSURL *url = [NSURL URLWithString: newsItem.image];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = nil;
    __weak NewsFeedTableViewCell *weakCell = cell;
    
    [cell.newsImage setImageWithURLRequest:request
                          placeholderImage:placeholderImage
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
    {
                                          
        weakCell.newsImage.image = image;
        [weakCell setNeedsLayout];
    }
                                   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
    {
        weakCell.newsImage.image = nil;
        [weakCell setNeedsLayout];
    }];
    cell.newsTitle.text = newsItem.title;
    cell.newsPubDate.text = newsItem.pubDate;
    cell.newsDescription.text = newsItem.shortDesc;
    
    // Make sure the constraints have been added to this cell, since it may have just been created from scratch
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // This project has only one cell identifier, but if you are have more than one, this is the time
    // to figure out which reuse identifier should be used for the cell at this index path.
    NSString *reuseIdentifier = CellIdentifier;
    
    // Use the dictionary of offscreen cells to get a cell for the reuse identifier, creating a cell and storing
    // it in the dictionary if one hasn't already been added for the reuse identifier.
    // WARNING: Don't call the table view's dequeueReusableCellWithIdentifier: method here because this will result
    // in a memory leak as the cell is created but never returned from the tableView:cellForRowAtIndexPath: method!
    NewsFeedTableViewCell *cell = [self.offscreenCells objectForKey:reuseIdentifier];
    if (!cell) {
        cell = [[NewsFeedTableViewCell alloc] init];
        [self.offscreenCells setObject:cell forKey:reuseIdentifier];
    }
    
    News *newsItem = [self.newsData objectAtIndex:indexPath.row];

    cell.newsTitle.text = newsItem.title;
    cell.newsPubDate.text = newsItem.pubDate;
    cell.newsDescription.text = newsItem.shortDesc;
    
    // Make sure the constraints have been added to this cell, since it may have just been created from scratch
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    // The cell's width must be set to the same size it will end up at once it is in the table view.
    // This is important so that we'll get the correct height for different table view widths, since our cell's
    // height depends on its width due to the multi-line UILabel word wrapping. Don't need to do this above in
    // -[tableView:cellForRowAtIndexPath:] because it happens automatically when the cell is used in the table view.
    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
    // NOTE: if you are displaying a section index (e.g. alphabet along the right side of the table view), or
    // if you are using a grouped table view style where cells have insets to the edges of the table view,
    // you'll need to adjust the cell.bounds.size.width to be smaller than the full width of the table view we just
    // set it to above. See http://stackoverflow.com/questions/3647242 for discussion on the section index width.
    
    // Do the layout pass on the cell, which will calculate the frames for all the views based on the constraints
    // (Note that the preferredMaxLayoutWidth is set on multi-line UILabels inside the -[layoutSubviews] method
    // in the UITableViewCell subclass
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    // Get the actual height required for the cell
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    // Add an extra point to the height to account for the cell separator, which is added between the bottom
    // of the cell's contentView and the bottom of the table view cell.
    height += 1;
    
    return height;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"NewsDetails"
                              sender:[self.newsData objectAtIndex:indexPath.row]];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"NewsDetails"])
    {
        News *newsForDetails = sender;
        NewsDetailsViewController *destVC = segue.destinationViewController;
        NSLog(@"%@", newsForDetails.link);
        destVC.url = newsForDetails.link;
    }
}


@end
