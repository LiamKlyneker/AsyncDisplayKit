//
//  ASLayoutNodeTestsHelper.m
//  AsyncDisplayKit
//
//  Created by Huy Nguyen on 28/05/15.
//  Copyright (c) 2015 Facebook. All rights reserved.
//

#import "ASLayoutNodeSnapshotTestsHelper.h"

#import "ASDisplayNode.h"
#import "ASLayoutNode.h"

@interface ASTestNode : ASDisplayNode
- (void)setLayoutNodeUnderTest:(ASLayoutNode *)layoutNodeUnderTest sizeRange:(ASSizeRange)sizeRange;
@end

@implementation ASLayoutNodeSnapshotTestCase

- (void)testLayoutNode:(ASLayoutNode *)layoutNode
             sizeRange:(ASSizeRange)sizeRange
              subnodes:(NSArray *)subnodes
            identifier:(NSString *)identifier
{
  ASTestNode *node = [[ASTestNode alloc] init];

  for (ASDisplayNode *subnode in subnodes) {
    [node addSubnode:subnode];
  }
  
  [node setLayoutNodeUnderTest:layoutNode sizeRange:sizeRange];
  
  ASSnapshotVerifyNode(node, identifier);
}

@end

@implementation ASTestNode
{
  ASLayout *_layoutUnderTest;
}

- (instancetype)init
{
  if (self = [super init]) {
    self.layerBacked = YES;
  }
  return self;
}

- (void)setLayoutNodeUnderTest:(ASLayoutNode *)layoutNodeUnderTest sizeRange:(ASSizeRange)sizeRange
{
  _layoutUnderTest = [layoutNodeUnderTest calculateLayoutThatFits:sizeRange];
  self.frame = CGRectMake(0, 0, _layoutUnderTest.size.width, _layoutUnderTest.size.height);
  [self measure:_layoutUnderTest.size];
}

- (ASLayout *)calculateLayoutThatFits:(ASSizeRange)constrainedSize
{
  return _layoutUnderTest;
}

@end

@implementation ASStaticSizeDisplayNode

- (ASLayout *)calculateLayoutThatFits:(ASSizeRange)constrainedSize
{
  return CGSizeEqualToSize(_staticSize, CGSizeZero)
    ? [super calculateLayoutThatFits:constrainedSize]
    : [ASLayout newWithLayoutableObject:self size:ASSizeRangeClamp(constrainedSize, _staticSize)];
}

@end