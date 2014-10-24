//
//  CollectionViewController.m
//  CollectionViewSelection
//
//  Created by Hirad Motamed on 2014-10-24.
//  Copyright (c) 2014 Lighthouse Labs. All rights reserved.
//

#import "CollectionViewController.h"

@interface CollectionViewController ()

@property (nonatomic, strong) NSArray* words;
@property (nonatomic, strong) NSMutableArray* selectedWords;
- (IBAction)deleteSelectedWords:(id)sender;
- (IBAction)addMoreWords:(id)sender;

@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.selectedWords = [NSMutableArray array];
    self.words = @[@"Hello", @"World", @"Foo", @"bar"];
    
    self.collectionView.allowsMultipleSelection = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addMoreWords:(id)sender
{
    NSArray* moreWords = @[@"Lighthouse", @"Labs", @"Rocks!!!"];
    NSMutableArray* newIndexPaths = [NSMutableArray array];
    
    NSInteger currentCount = [self.words count];
    for (NSInteger itemCount = 0; itemCount < [moreWords count]; itemCount++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:(currentCount + itemCount) inSection:0];
        [newIndexPaths addObject:indexPath];
    }
    
    self.words = [self.words arrayByAddingObjectsFromArray:moreWords];
    
    [self.collectionView performBatchUpdates:^{
        [self.collectionView insertItemsAtIndexPaths:newIndexPaths];
    } completion:nil];
}

-(void)deleteSelectedWords:(id)sender
{
    // get the selected indexpaths
    NSArray* selectedIndexPaths = [self.collectionView indexPathsForSelectedItems];
    
    // delete words from words array
    NSMutableArray* mutableWords = [self.words mutableCopy];
    NSMutableIndexSet* deletionIndexSet = [NSMutableIndexSet indexSet];
    for (NSIndexPath* indexPath in selectedIndexPaths) {
        [deletionIndexSet addIndex:indexPath.item];
    }
    [mutableWords removeObjectsAtIndexes:deletionIndexSet];
    
    self.words = [NSArray arrayWithArray:mutableWords];
    
    // tell the collection view to delete cells
    [self.collectionView performBatchUpdates:^{
        [self.collectionView deleteItemsAtIndexPaths:selectedIndexPaths];
    } completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.words count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    NSString* displayedWord =self.words[indexPath.item];
    UILabel* label = (UILabel*)[cell viewWithTag:100];
    label.text = displayedWord;
    
    UIView* selectionView = [[UIView alloc] initWithFrame:cell.bounds];
    selectionView.backgroundColor = [UIColor redColor];
    
    cell.selectedBackgroundView = selectionView;
    
    if ([self.selectedWords containsObject:displayedWord]) {
        cell.selected = YES;
    }
    else
        cell.selected = NO;
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* selectedWord = self.words[indexPath.item];
    [self.selectedWords addObject:selectedWord];
    
    NSLog(@"Selected Words: %@", self.selectedWords);
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* deselectedWord = self.words[indexPath.item];
    [self.selectedWords removeObject:deselectedWord];
    
    NSLog(@"Selected Words: %@", self.selectedWords);
}

@end
