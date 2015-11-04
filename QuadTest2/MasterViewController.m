//
//  MasterViewController.m
//  QuadTest2
//
//  Created by A on 6/30/15.
//  Copyright (c) 2015 SHPQuad. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "SimpleTableCell.h"

@interface MasterViewController (){
    HomeModel *_homeModel;
    NSArray *_feedItems;
    NSMutableArray *_filteredItems;
    FeedItem *_selectedFeedItem;
    WebItem *_selectedWebItem;
    NSUserDefaults *_defaults;
    UIRefreshControl *_refreshControl;
}

@property NSMutableArray *objects;
@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    self.clearsSelectionOnViewWillAppear = NO;
    self.preferredContentSize = CGSizeMake(320.0, 600.0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    /*self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;*/
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    

    
    _feedItems = [[NSArray alloc] init];
    _homeModel = [[HomeModel alloc] init];
    
    _homeModel.delegate = self;
    
    //[_homeModel downloadItems];
    
    _defaults = [NSUserDefaults standardUserDefaults];
    if (![_defaults boolForKey:@"notFirstTime"]) {
        [_defaults setBool:YES forKey:@"notFirstTime"];
        [_defaults setBool:NO forKey:@"SpeedMode"];
        NSLog(@"Did first time setup");
    }
    
    self.navigationController.navigationBar.translucent = NO;
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIImage *image = [UIImage imageNamed:@"QuadLogoSlogan1_appv.png"];
    UIImageView *myImageView = [[UIImageView alloc] initWithImage:image];
    
    image = [UIImage imageNamed:@"loading2.png"];
    UIImageView *tableBackgroundView = [[UIImageView alloc]initWithImage:image];
    tableBackgroundView.contentMode = UIViewContentModeScaleAspectFit;
    
    UIBarButtonItem *tabButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"QuadTabButton.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showTabView)];
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"settingsGear.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showSettings)];
    
    myImageView.contentMode = UIViewContentModeTop;
    
    self.tableView.backgroundView = tableBackgroundView;
    
    self.navigationController.navigationItem.title = nil;
    self.navigationItem.titleView = myImageView;
    self.navigationItem.leftBarButtonItem = tabButton;
    self.navigationItem.rightBarButtonItem = settingsButton;
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor colorWithRed:0.3765 green:0 blue:0 alpha:1]];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.6784 green:0.0588 blue:0.1137 alpha:1]];
    
    _refreshControl = [[UIRefreshControl alloc]init];
    [self.view addSubview:_refreshControl];
    [_refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [_refreshControl beginRefreshing];
    [self refreshTable];
    [self.tableView sendSubviewToBack:_refreshControl];
    [self.tableView bringSubviewToFront:self.tableView.tableHeaderView];
 
    _resultsTableController = [[ResultsTableController alloc] init];
    _searchController = [[UISearchController alloc] initWithSearchResultsController:self.resultsTableController];
    self.searchController.searchResultsUpdater = self;
    //[self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    // we want to be the delegate for our filtered table so didSelectRowAtIndexPath is called for both tables
    self.resultsTableController.tableView.delegate = self;
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO; // default is YES
    self.searchController.searchBar.delegate = self; // so we can monitor text changes + others
    self.searchController.hidesNavigationBarDuringPresentation = NO;

    
    // Search is now just presenting a view controller. As such, normal view controller
    // presentation semantics apply. Namely that presentation will walk up the view controller
    // hierarchy until it finds the root view controller or one that defines a presentation context.
    //
    self.definesPresentationContext = YES;  // know where you want UISearchController to be displayed
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // restore the searchController's active state
    if (self.searchControllerWasActive) {
        self.searchController.active = self.searchControllerWasActive;
        _searchControllerWasActive = NO;
        
        if (self.searchControllerSearchFieldWasFirstResponder) {
            [self.searchController.searchBar becomeFirstResponder];
            _searchControllerSearchFieldWasFirstResponder = NO;
        }
    }
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.tableView.tableHeaderView.frame =
    CGRectMake(0, 0, self.tableView.tableHeaderView.frame.size.width, self.tableView.tableHeaderView.frame.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)itemsDownloaded:(NSArray *)items
{
    // This delegate method will get called when the items are finished downloading
    
    // Set the downloaded items to the array by resetting it and appending new data
    _feedItems = items;
    _filteredItems = [NSMutableArray arrayWithCapacity:[_feedItems count]];
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [_refreshControl endRefreshing];
        [self.tableView reloadData];
    });
    
}

- (void)itemsDownloaded:(NSArray *)items withTarget:(NSString *)target {
    
    if ([target isEqual:@"0"]) {
        NSLog(@"Recieved test notification");
        target = @"5639";
    }
    
    _feedItems = items;
    _filteredItems = [NSMutableArray arrayWithCapacity:[_feedItems count]];
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self.tableView reloadData];
    });
    
    // Set selected feeditem to var
    for (FeedItem* item in _feedItems) {
        if ([item.link isEqual:[NSString stringWithFormat:@"http://www.shpquad.org/archives/%@", target]]) {
            _selectedFeedItem = item;
            break;
        }
    }
    
    
    
    // Set selected webitem to var
    _selectedWebItem = [WebItem webItemWithTitle:_selectedFeedItem.title andURL:[NSURL URLWithString:_selectedFeedItem.link]];
    
    // Manually call segue to detail view controller
    if (_selectedFeedItem) {
        [self performSegueWithIdentifier:@"showDetail" sender:self];
    }
}

#pragma mark - Refresh

- (void)refreshTable {
    [_homeModel downloadItems];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FeedItem *selectedItem = (tableView == self.tableView) ?
    _feedItems[indexPath.row] : self.resultsTableController.filteredItems[indexPath.row];
    
    //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    _selectedFeedItem = selectedItem;
    
    
    // Set selected webitem to var
    _selectedWebItem = [WebItem webItemWithTitle:_selectedFeedItem.title andURL:[NSURL URLWithString:_selectedFeedItem.link]];
    
    if (_selectedFeedItem) {
        // Manually call segue to detail view controller
        [self performSegueWithIdentifier:@"showDetail" sender:self];
    }
}

/*
- (void)insertNewObject:(id)sender {
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }
    [self.objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}*/


#pragma mark - Transitions

- (void)showTabView
{
    [self performSegueWithIdentifier:@"showTabView" sender:self];
}

- (void)showSettings
{
    [self performSegueWithIdentifier:@"showSettings" sender:self];
}

#pragma mark - AppDelegate stuff

- (void)downloadItemsWithTarget:(NSString *)target {
    [_homeModel downloadItemsWithTarget:target];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        
        if ([_defaults boolForKey:@"SpeedMode"]) {
            [controller setDetailItem:_selectedFeedItem];
        } else {
            [controller setWebItem:_selectedWebItem];
        }
        
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
    
    if ([[segue identifier] isEqualToString:@"showTabView"]) {
        //do stuff
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of feed items (initially 0)
    
    return _feedItems.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Retrieve cell
    NSString *cellIdentifier = @"SimpleTableCell";
    SimpleTableCell *myCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (myCell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimpleTableCell" owner:self options:nil];
        myCell = [nib objectAtIndex:0];
    }
    
    FeedItem *item;
    
    
    item = _feedItems[indexPath.row];
    
    
    
    // Get references to labels of cell
    myCell.titleLabel.text = item.title;
    myCell.authorLabel.text = item.author;
    myCell.dateLabel.text = (NSString *)item.date; //[item.date descriptionWithLocale:[NSLocale currentLocale]];
    // TODO: myCell.thumbnailImageView.image = item.
    
    return myCell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
}

/*- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}*/

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchText = searchController.searchBar.text;
    
    // strip out all the leading and trailing spaces
    NSString *strippedString = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    // break up the search terms (separated by spaces)
    NSArray *searchItems = nil;
    if (strippedString.length > 0) {
        searchItems = [strippedString componentsSeparatedByString:@" "];
    }
    
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [_filteredItems removeAllObjects];
    // Filter the array using NSPredicate
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    [tempArray removeAllObjects];
    // check if title contains search
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.title contains[c] %@",searchText];
    _filteredItems = [NSMutableArray arrayWithArray:[_feedItems filteredArrayUsingPredicate:predicate]];
    // check for search in content
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"SELF.content contains[c] %@",searchText];
    tempArray = [NSMutableArray arrayWithArray:[_feedItems filteredArrayUsingPredicate:predicate2]];
    [_filteredItems arrayByAddingObjectsFromArray:tempArray];
    
    ResultsTableController *tableController = (ResultsTableController *)self.searchController.searchResultsController;
    tableController.filteredItems = _filteredItems;
    [tableController.tableView reloadData];
    
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}


#pragma mark - UISearchControllerDelegate

// Called after the search controller's search bar has agreed to begin editing or when
// 'active' is set to YES.
// If you choose not to present the controller yourself or do not implement this method,
// a default presentation is performed on your behalf.
//
// Implement this method if the default presentation is not adequate for your purposes.
//
- (void)presentSearchController:(UISearchController *)searchController {
    
}

- (void)willPresentSearchController:(UISearchController *)searchController {
    // do something before the search controller is presented
}

- (void)didPresentSearchController:(UISearchController *)searchController {
    // do something after the search controller is presented
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    // do something before the search controller is dismissed
}

- (void)didDismissSearchController:(UISearchController *)searchController {
    // do something after the search controller is dismissed
}





#pragma mark - UIStateRestoration

// we restore several items for state restoration:
//  1) Search controller's active state,
//  2) search text,
//  3) first responder

NSString *const ViewControllerTitleKey = @"ViewControllerTitleKey";
NSString *const SearchControllerIsActiveKey = @"SearchControllerIsActiveKey";
NSString *const SearchBarTextKey = @"SearchBarTextKey";
NSString *const SearchBarIsFirstResponderKey = @"SearchBarIsFirstResponderKey";

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    
    // encode the view state so it can be restored later
    
    // encode the title
    [coder encodeObject:self.title forKey:ViewControllerTitleKey];
    
    UISearchController *searchController = self.searchController;
    
    // encode the search controller's active state
    BOOL searchDisplayControllerIsActive = searchController.isActive;
    [coder encodeBool:searchDisplayControllerIsActive forKey:SearchControllerIsActiveKey];
    
    // encode the first responser status
    if (searchDisplayControllerIsActive) {
        [coder encodeBool:[searchController.searchBar isFirstResponder] forKey:SearchBarIsFirstResponderKey];
    }
    
    // encode the search bar text
    [coder encodeObject:searchController.searchBar.text forKey:SearchBarTextKey];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    
    // restore the title
    self.title = [coder decodeObjectForKey:ViewControllerTitleKey];
    
    // restore the active state:
    // we can't make the searchController active here since it's not part of the view
    // hierarchy yet, instead we do it in viewWillAppear
    //
    _searchControllerWasActive = [coder decodeBoolForKey:SearchControllerIsActiveKey];
    
    // restore the first responder status:
    // we can't make the searchController first responder here since it's not part of the view
    // hierarchy yet, instead we do it in viewWillAppear
    //
    _searchControllerSearchFieldWasFirstResponder = [coder decodeBoolForKey:SearchBarIsFirstResponderKey];
    
    // restore the text in the search field
    self.searchController.searchBar.text = [coder decodeObjectForKey:SearchBarTextKey];
}

@end
