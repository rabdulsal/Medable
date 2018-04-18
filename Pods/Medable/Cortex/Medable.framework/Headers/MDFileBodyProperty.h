//
//  MDFileBodyProperty.h
//  Medable
//
//  Copyright © 2015 Medable. All rights reserved.
//

#import "MDBodyProperty.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * File body property containing the attachments for the File property's facets.
 */
@interface MDFileBodyProperty : MDBodyProperty

/**
 * Add an attachment mapped to a facet.
 *
 * @param facetName Name of the facet that's getting the attachment.
 * @param data Binary data being attached.
 * @return the generated file name of the upload. Can be used to track and map.
 */
- (NSString *)addFacetAttachment:(NSString *)facetName
                            data:(NSData *)data;

/**
 * Add an attachment mapped to a facet.
 *
 * @param facetName Name of the facet that's getting the attachment.
 * @param mime Mime type of the attachment.
 * @param data Binary data being attached.
 * @return the generated file name of the upload. Can be used to track and map.
 */
- (NSString *)addFacetAttachment:(NSString *)facetName
                            mime:(NSString *)mime
                            data:(NSData *)data;

/**
 * Add an attachment mapped to a facet.
 *
 * @param facetName Name of the facet that's getting the attachment.
 * @param data Binary data being attached.
 * @param fileName File name to be used by the upload. Note: Avoid using repeated file names.
 * @return the generated file name of the upload. Can be used to track and map.
 */
- (NSString *)addFacetAttachment:(NSString *)facetName
                            data:(NSData *)data
                        fileName:(NSString *)fileName;

@end

NS_ASSUME_NONNULL_END
