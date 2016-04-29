//
//  LikedTrackObject.h
//  
//
//  Created by inailuy on 1/13/15.
//
//

#import <Foundation/Foundation.h>

@interface LikedTrackObject : NSObject

@property (nonatomic, strong) NSURL          *artworkURL;
@property (nonatomic, strong) NSURL          *attachmentsURI;
@property (nonatomic, strong) NSString       *bpm;
@property (nonatomic, strong) NSNumber       *commentCount;
@property (nonatomic, strong) NSNumber       *commentTable;
@property (nonatomic, strong) NSDate         *createdAt;
@property (nonatomic, strong) NSString       *descriptionValue;
@property (nonatomic, strong) NSNumber       *downloadCount;
@property (nonatomic, strong) NSNumber       *downloadable;
@property (nonatomic, strong) NSNumber       *duration;
@property (nonatomic, strong) NSString       *embeddableBy;
@property (nonatomic, strong) NSNumber       *favoritingCount;
@property (nonatomic, strong) NSString       *genre;
@property (nonatomic, strong) NSNumber       *idValue;
@property (nonatomic, strong) NSString       *isrc;
@property (nonatomic, strong) NSString       *keySignature;
@property (nonatomic, strong) NSString       *kind;
@property (nonatomic, strong) NSString       *labelId;
@property (nonatomic, strong) NSString       *labelName;
@property (nonatomic, strong) NSDate         *lastModified;
@property (nonatomic, strong) NSString       *license;
@property (nonatomic, strong) NSNumber       *originalContentSize;
@property (nonatomic, strong) NSString       *originalFormat;
@property (nonatomic, strong) NSString       *permalink;
@property (nonatomic, strong) NSURL          *permalinkURL;
@property (nonatomic, strong) NSNumber       *playbackCount;
@property (nonatomic, strong) NSString       *policy;
@property (nonatomic, strong) NSString       *purchaseTitle;
@property (nonatomic, strong) NSURL          *purchaseURL;
@property (nonatomic, strong) NSString       *releaseValue;
@property (nonatomic, strong) NSString       *releaseDay;
@property (nonatomic, strong) NSString       *releaseMonth;
@property (nonatomic, strong) NSString       *releaseYear;
@property (nonatomic, strong) NSString       *sharing;
@property (nonatomic, strong) NSString       *state;
@property (nonatomic, strong) NSURL          *streamURL;
@property (nonatomic, strong) NSNumber       *streamable;
@property (nonatomic, strong) NSString       *tagList;
@property (nonatomic, strong) NSString       *title;
@property (nonatomic, strong) NSString       *trackType;
@property (nonatomic, strong) NSURL          *uri;
@property (nonatomic, strong) NSDictionary   *user;
@property (nonatomic, strong) NSNumber       *userFavorite;
@property (nonatomic, strong) NSNumber       *userID;
@property (nonatomic, strong) NSNumber       *userPlaybackCount;
@property (nonatomic, strong) NSURL          *videoURL;
@property (nonatomic, strong) NSURL          *waveformURL;


+(LikedTrackObject *)createLikedTrackObject:(NSDictionary *)jsonDictionary;

@end
