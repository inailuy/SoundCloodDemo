//
//  LikedTrackObject.m
//  
//
//  Created by inailuy on 1/13/15.
//
//

#import "LikedTrackObject.h"

NSString * const kArtwork_url = @"artwork_url";
NSString * const kAttachments_uri = @"attachments_uri";
NSString * const kBpm = @"bpm";
NSString * const kComment_count = @"comment_count";
NSString * const kCommentable = @"commentable";
NSString * const kCreated_at = @"created_at";
NSString * const kDescription = @"description";
NSString * const kDownload_count = @"download_count";
NSString * const kDownloadable = @"downloadable";
NSString * const kDuration = @"duration";
NSString * const kEmbeddable_by = @"embeddable_by";
NSString * const kFavoritings_count = @"favoritings_count";
NSString * const kGenre = @"genre";
NSString * const kID = @"id";
NSString * const kIsrc = @"isrc";
NSString * const kKey_signature = @"key_signature";
NSString * const kKind = @"kind";
NSString * const kLabel_id = @"label_id";
NSString * const kLabel_name = @"label_name";
NSString * const kLast_modified = @"last_modified";
NSString * const kLicense = @"license";
NSString * const kOriginal_content_size = @"original_content_size";
NSString * const kOriginal_format = @"original_format";
NSString * const kPermalink = @"permalink";
NSString * const kPermalink_url = @"permalink_url";
NSString * const kPlayback_count = @"playback_count";
NSString * const kPolicy = @"policy";
NSString * const kPkPurchase_title = @"purchase_title";
NSString * const kPurchase_url = @"purchase_url";
NSString * const kRelease = @"release";
NSString * const kRelease_day = @"release_day";
NSString * const kRelease_month = @"release_month";
NSString * const kRelease_year = @"release_year";
NSString * const kSharing = @"sharing";
NSString * const kState = @"state";
NSString * const kStream_url = @"stream_url";
NSString * const kStreamable = @"streamable";
NSString * const kTag_list = @"tag_list";
NSString * const kTitle = @"title";
NSString * const kTrack_type = @"track_type";
NSString * const kUri = @"uri";
NSString * const kUser = @"user";
NSString * const kUser_favorite = @"user_favorite";
NSString * const kUser_id = @"user_id";
NSString * const kUser_playback_count = @"user_playback_count";
NSString * const kVideo_url = @"video_url";
NSString * const kWaveform_url = @"waveform_url";

@implementation LikedTrackObject

/*
NSURL          *artworkURL;
NSURL          *attachmentsURI;
NSString       *bpm;
NSNumber       *commentCount;
NSNumber       *commentTable;
NSDate         *createdAt;
NSString       *descriptionValue;
NSNumber       *downloadCount;
NSNumber       *downloadable;
NSNumber       *duration;
NSString       *embeddableBy;
NSNumber       *favoritingCount;
NSString       *genre;
NSNumber       *idValue;
NSString       *isrc;
NSString       *keySignature;
NSString       *kind;
NSString       *labelId;
NSString       *labelName;
NSDate         *lastModified;
NSString       *license;
NSNumber       *originalContentSize;
NSString       *originalFormat;
NSString       *permalink;
NSURL          *permalinkURL;
NSNumber       *playbackCount;
NSString       *policy;
NSString       *purchaseTitle;
NSURL          *purchaseURL;
NSString       *releaseValue;
NSString       *releaseDay;
NSString       *releaseMonth;
NSString       *sharing;
NSString       *state;
NSURL          *streamURL;
NSNumber       *streamable;
NSString       *tagList;
NSString       *title;
NSString       *trackType;
NSURL          *uri;
NSDictionary   *user;
NSNumber       *userFavorite;
NSNumber       *userID;
NSNumber       *userPlaybackCount;
NSURL          *videoURL;
NSURL          *waveformURL;
 */



+(LikedTrackObject *)createLikedTrackObject:(NSDictionary *)jsonDictionary
{
    if (!jsonDictionary)
    {
        NSLog(@"dictionary empty check json");
        return nil;
    }
    
    LikedTrackObject *obj = [[LikedTrackObject alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss x"];
    
    if (![jsonDictionary[kArtwork_url] isKindOfClass:[NSNull class]])
        obj.artworkURL = [NSURL URLWithString:jsonDictionary[kArtwork_url]];
    obj.attachmentsURI = [NSURL URLWithString:jsonDictionary[kAttachments_uri]];
    obj.bpm = jsonDictionary[kBpm];
    obj.commentCount = jsonDictionary[kComment_count];
    obj.commentTable = jsonDictionary[kCommentable];
    obj.createdAt = [dateFormatter dateFromString:jsonDictionary[kCreated_at]];
    obj.descriptionValue = jsonDictionary[kDescription];
    obj.downloadCount = jsonDictionary[kDownload_count];
    obj.downloadable = jsonDictionary[kDownloadable];
    obj.duration = jsonDictionary[kDuration];
    obj.embeddableBy = jsonDictionary[kEmbeddable_by];
    obj.favoritingCount = jsonDictionary[kFavoritings_count];
    obj.genre = jsonDictionary[kGenre];
    obj.idValue = jsonDictionary[kID];
    obj.isrc = jsonDictionary[kIsrc];
    obj.keySignature = jsonDictionary[kKey_signature];
    obj.labelId = jsonDictionary[kLabel_id];
    obj.labelName = jsonDictionary[kLabel_name];
    obj.lastModified = [dateFormatter dateFromString:jsonDictionary[kLast_modified]];
    obj.license = jsonDictionary[kLicense];
    obj.originalContentSize = jsonDictionary[kOriginal_content_size];
    obj.originalFormat = jsonDictionary[kOriginal_format];
    obj.permalink = jsonDictionary[kPermalink];
    obj.permalinkURL = [NSURL URLWithString:jsonDictionary[kPermalink_url]];
    obj.playbackCount = jsonDictionary[kPlayback_count];
    obj.policy = jsonDictionary[kPolicy];
    obj.purchaseTitle = jsonDictionary[kPkPurchase_title];
    if (![jsonDictionary[kPurchase_url] isKindOfClass:[NSNull class]])
        obj.purchaseURL = [NSURL URLWithString:jsonDictionary[kPurchase_url]];
    obj.releaseValue = jsonDictionary[kRelease];
    obj.releaseDay = jsonDictionary[kRelease_day];
    obj.releaseMonth = jsonDictionary[kRelease_month];
    obj.releaseYear = jsonDictionary[kRelease_year];
    obj.sharing = jsonDictionary[kSharing];
    obj.state = jsonDictionary[kState];
    obj.streamURL = [NSURL URLWithString:jsonDictionary[kStream_url]];
    obj.streamable = jsonDictionary[kStreamable];
    obj.tagList = jsonDictionary[kTag_list];
    obj.title = jsonDictionary[kTitle];
    obj.trackType = jsonDictionary[kTrack_type];
    obj.uri = [NSURL URLWithString:jsonDictionary[kUri]];
    obj.user = jsonDictionary[kUser];
    obj.userFavorite = jsonDictionary[kUser_favorite];
    obj.userID = jsonDictionary[kUser_id];
    obj.userPlaybackCount = jsonDictionary[kUser_playback_count];
    if (![jsonDictionary[kVideo_url] isKindOfClass:[NSNull class]])
        obj.videoURL = [NSURL URLWithString:jsonDictionary[kVideo_url]]; //Returns nil
    obj.waveformURL = [NSURL URLWithString:jsonDictionary[kWaveform_url]];
    
    return obj;
}

@end
