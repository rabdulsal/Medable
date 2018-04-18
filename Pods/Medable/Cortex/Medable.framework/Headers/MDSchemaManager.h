//
//  MDSchemaManager.h
//  Medable
//
//  Copyright (c) 2015 Medable. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 The Schema Manager contains the root level information for all data customization
 for a certain organization. Callers don't need to be logged in to make calls to
 this object as the data is public for an organization.
 */
@interface MDSchemaManager : NSObject

/**
 Singleton instance of the Schema Manager.

 @return The singleton MDSChemaManager.
 */
+ (MDSchemaManager*)sharedInstance;

// unavailable
+ (instancetype)new NS_UNAVAILABLE;

// unavailable init
- (instancetype)init NS_UNAVAILABLE;

/**
 Retrieve the list (array) of object definitions for the current organization.
 
 This list is kept up to date with regards to the latest changes on the backend.
 
 @param callback The callback where the NSArray and `MDFault` (if any) are returned.
 */
- (void)objectDefinitionsWithCallback:(MDObjectFaultCallback)callback;

/**
 Get the object definition from an Object Id.
 
 @param Id The Object Id of the object.
 
 @return The `MDObjectDefinition` corresponding to this Id.
 */
- (nullable MDObjectDefinition *)objectWithId:(MDObjectId*)Id;

/**
 Get the object definition from an Object of a certain name.
 
 @param name The name of the object (plural or singular).
 
 @return The `MDObjectDefinition` corresponding to this name.
 */
- (nullable MDObjectDefinition *)objectWithName:(NSString*)name;

/**
 Get the object definition from an Object which plural name matches the parameter.
 
 @param name The plural name of the object.
 
 @return The `MDObjectDefinition` corresponding to this name.
 */
- (nullable MDObjectDefinition *)objectWithPluralName:(NSString*)name DEPRECATED_MSG_ATTRIBUTE("Will be removed in future version. Use `objectWithName:` instead.");

@end

NS_ASSUME_NONNULL_END
