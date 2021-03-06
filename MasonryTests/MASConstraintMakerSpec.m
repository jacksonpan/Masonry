//
//  MASConstraintMakerSpec.m
//  Masonry
//
//  Created by Jonas Budelmann on 25/08/13.
//  Copyright (c) 2013 Jonas Budelmann. All rights reserved.
//

#import "MASConstraintMaker.h"
#import "MASCompositeConstraint.h"
#import "MASViewConstraint.h"

@interface MASConstraintMaker () <MASConstraintDelegate>

@property (nonatomic, weak) MAS_VIEW *view;
@property (nonatomic, strong) NSMutableArray *constraints;

@end

@interface MASCompositeConstraint ()

@property (nonatomic, strong) NSMutableArray *childConstraints;

@end

SpecBegin(MASConstraintMaker)

__block MASConstraintMaker *maker;
__block MAS_VIEW *superview;
__block MAS_VIEW *view;
__block MASCompositeConstraint *composite;

beforeEach(^{
    composite = nil;
    view = MAS_VIEW.new;
    superview = MAS_VIEW.new;
    [superview addSubview:view];

    maker = [[MASConstraintMaker alloc] initWithView:view];
});

it(@"should create centerY and centerX children", ^{
    composite = maker.center;

    expect(composite.childConstraints).to.haveCountOf(2);

    MASViewConstraint *viewConstraint = composite.childConstraints[0];
    expect(viewConstraint.firstViewAttribute.view).to.beIdenticalTo(maker.view);
    expect(viewConstraint.firstViewAttribute.layoutAttribute).to.equal(NSLayoutAttributeCenterX);

    viewConstraint = composite.childConstraints[1];
    expect(viewConstraint.firstViewAttribute.view).to.beIdenticalTo(maker.view);
    expect(viewConstraint.firstViewAttribute.layoutAttribute).to.equal(NSLayoutAttributeCenterY);
});

it(@"should create top, left, bottom, right children", ^{
    MAS_VIEW *newView = MAS_VIEW.new;
    composite = maker.edges;
    composite.equalTo(newView);

    expect(composite.childConstraints).to.haveCountOf(4);

    //top
    MASViewConstraint *viewConstraint = composite.childConstraints[0];
    expect(viewConstraint.firstViewAttribute.view).to.beIdenticalTo(maker.view);
    expect(viewConstraint.firstViewAttribute.layoutAttribute).to.equal(NSLayoutAttributeTop);

    //left
    viewConstraint = composite.childConstraints[1];
    expect(viewConstraint.firstViewAttribute.view).to.beIdenticalTo(maker.view);
    expect(viewConstraint.firstViewAttribute.layoutAttribute).to.equal(NSLayoutAttributeLeft);

    //bottom
    viewConstraint = composite.childConstraints[2];
    expect(viewConstraint.firstViewAttribute.view).to.beIdenticalTo(maker.view);
    expect(viewConstraint.firstViewAttribute.layoutAttribute).to.equal(NSLayoutAttributeBottom);

    //right
    viewConstraint = composite.childConstraints[3];
    expect(viewConstraint.firstViewAttribute.view).to.beIdenticalTo(maker.view);
    expect(viewConstraint.firstViewAttribute.layoutAttribute).to.equal(NSLayoutAttributeRight);
});

it(@"should create width and height children", ^{
    composite = maker.size;
    expect(composite.childConstraints).to.haveCountOf(2);

    MASViewConstraint *viewConstraint = composite.childConstraints[0];
    expect(viewConstraint.firstViewAttribute.view).to.beIdenticalTo(maker.view);
    expect(viewConstraint.firstViewAttribute.layoutAttribute).to.equal(NSLayoutAttributeWidth);

    viewConstraint = composite.childConstraints[1];
    expect(viewConstraint.firstViewAttribute.view).to.beIdenticalTo(maker.view);
    expect(viewConstraint.firstViewAttribute.layoutAttribute).to.equal(NSLayoutAttributeHeight);
});

it(@"should install constraints", ^{
    MAS_VIEW *newView = MAS_VIEW.new;
    [superview addSubview:newView];

    maker.edges.equalTo(newView);
    maker.centerX.equalTo(@[newView, @10]);

    expect([maker install]).to.haveCountOf(2);
});

it(@"should update constraints", ^{
    MAS_VIEW *newView = MAS_VIEW.new;
    [superview addSubview:newView];

    maker.updateExisting = YES;
    maker.left.equalTo(newView).offset(10);
    [maker install];

    NSLayoutConstraint *constraint1 = superview.constraints[0];
    expect(constraint1.constant).to.equal(10);

    maker.left.equalTo(newView).offset(20);
    [maker install];

    expect(superview.constraints).to.haveCountOf(1);
    NSLayoutConstraint *constraint2 = superview.constraints[0];
    expect(constraint2.constant).to.equal(20);

    expect(constraint2).to.beIdenticalTo(constraint2);
});

it(@"should not update constraint", ^{
    MAS_VIEW *newView = MAS_VIEW.new;
    [superview addSubview:newView];

    maker.updateExisting = YES;
    maker.left.equalTo(newView).offset(10);
    [maker install];

    NSLayoutConstraint *constraint1 = superview.constraints[0];
    expect(constraint1.constant).to.equal(10);

    maker.right.equalTo(newView).offset(20);
    [maker install];

    expect(superview.constraints).to.haveCountOf(2);
    NSLayoutConstraint *constraint2 = superview.constraints[1];
    expect(constraint1.constant).to.equal(10);
    expect(constraint2.constant).to.equal(20);
});

it(@"should create new constraints", ^{
    expect(maker.left).notTo.beIdenticalTo(maker.left);
    expect(maker.right).notTo.beIdenticalTo(maker.right);
    expect(maker.top).notTo.beIdenticalTo(maker.top);
    expect(maker.bottom).notTo.beIdenticalTo(maker.bottom);
    expect(maker.baseline).notTo.beIdenticalTo(maker.baseline);
    expect(maker.leading).notTo.beIdenticalTo(maker.leading);
    expect(maker.trailing).notTo.beIdenticalTo(maker.trailing);
    expect(maker.width).notTo.beIdenticalTo(maker.width);
    expect(maker.height).notTo.beIdenticalTo(maker.height);
    expect(maker.centerX).notTo.beIdenticalTo(maker.centerX);
    expect(maker.centerY).notTo.beIdenticalTo(maker.centerY);
});

SpecEnd