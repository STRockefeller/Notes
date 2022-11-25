# LeetCode:355:20221108:Dart

[Reference](https://leetcode.com/problems/design-twitter/)

## Question

Design a simplified version of Twitter where users can post tweets, follow/unfollow another user, and is able to see the 10 most recent tweets in the user's news feed.

Implement the Twitter class:

Twitter() Initializes your twitter object.
void postTweet(int userId, int tweetId) Composes a new tweet with ID tweetId by the user userId. Each call to this function will be made with a unique tweetId.
`List<Integer> getNewsFeed(int userId)` Retrieves the 10 most recent tweet IDs in the user's news feed. Each item in the news feed must be posted by users who the user followed or by the user themself. Tweets must be ordered from most recent to least recent.
void follow(int followerId, int followeeId) The user with ID followerId started following the user with ID followeeId.
void unfollow(int followerId, int followeeId) The user with ID followerId started unfollowing the user with ID followeeId.

Example 1:

```text
Input
["Twitter", "postTweet", "getNewsFeed", "follow", "postTweet", "getNewsFeed", "unfollow", "getNewsFeed"]
[[], [1, 5], [1], [1, 2], [2, 6], [1], [1, 2], [1]]
Output
[null, null, [5], null, null, [6, 5], null, [5]]

Explanation
Twitter twitter = new Twitter();
twitter.postTweet(1, 5); // User 1 posts a new tweet (id = 5).
twitter.getNewsFeed(1);  // User 1's news feed should return a list with 1 tweet id -> [5]. return [5]
twitter.follow(1, 2);    // User 1 follows user 2.
twitter.postTweet(2, 6); // User 2 posts a new tweet (id = 6).
twitter.getNewsFeed(1);  // User 1's news feed should return a list with 2 tweet ids -> [6, 5]. Tweet id 6 should precede tweet id 5 because it is posted after tweet id 5.
twitter.unfollow(1, 2);  // User 1 unfollows user 2.
twitter.getNewsFeed(1);  // User 1's news feed should return a list with 1 tweet id -> [5], since user 1 is no longer following user 2.
```

Constraints:

1 <= userId, followerId, followeeId <= 500
0 <= tweetId <= 10^4
All the tweets have unique IDs.
At most 3 * 10^4 calls will be made to postTweet, getNewsFeed, follow, and unfollow.

## My Solution

久違的發現了有趣的題目。初始狀態如下。

```dart
class Twitter {

  Twitter() {

  }

  void postTweet(int userId, int tweetId) {

  }

  List<int> getNewsFeed(int userId) {

  }

  void follow(int followerId, int followeeId) {

  }

  void unfollow(int followerId, int followeeId) {

  }
}

/**
 * Your Twitter object will be instantiated and called as such:
 * Twitter obj = Twitter();
 * obj.postTweet(userId,tweetId);
 * List<int> param2 = obj.getNewsFeed(userId);
 * obj.follow(followerId,followeeId);
 * obj.unfollow(followerId,followeeId);
 */
```

首先先把限制加上去避免之後忘掉，userID不能為0但是tweetsID可以，然後tweetsID不能重複。題目沒有提到出錯怎辦，總之我先讓程式直接中斷好了。

```dart
class Twitter {
  Twitter() {}

  void postTweet(int userId, int tweetId) {
    if (userId < 1 || userId > 500) throw Exception('invalid user');
    if (tweetId < 0 || tweetId > 10000) throw Exception('invalid tweet');
  }

  List<int> getNewsFeed(int userId) {
    if (userId < 1 || userId > 500) throw Exception('invalid user');
  }

  void follow(int followerId, int followeeId) {
    if (followerId < 1 || followerId > 500) throw Exception('invalid user');
    if (followeeId < 1 || followeeId > 500) throw Exception('invalid user');
  }

  void unfollow(int followerId, int followeeId) {
    if (followerId < 1 || followerId > 500) throw Exception('invalid user');
    if (followeeId < 1 || followeeId > 500) throw Exception('invalid user');
  }
}

```

接著就是怎麼處理文章跟使用者之間的關係了，使用者的部分應該可以簡單的用map來表示成 `map[key=使用者]value=follow的人`。

文章則是要記錄發文順序，以及能夠查找特定使用者發布的文章。
像是 `SELECT FROM tweets WHERE user_id IN $1 ORDER BY posted_at` 這樣。

應該用一個array存{userID,ID}這樣的結構就夠了吧。

寫完大概像這樣

```dart
import 'dart:collection';

class Twitter {
  // key user, value followees
  var followees = <int, List<int>>{};
  var tweets = <Tweet>[];
  var tweetsCheck = HashSet<int>();

  Twitter() {}

  void postTweet(int userId, int tweetId) {
    if (userId < 1 || userId > 500) throw Exception('invalid user');
    if (tweetId < 0 || tweetId > 10000) throw Exception('invalid tweet');
    if (tweetsCheck.contains(tweetId)) throw Exception('duplicated tweet id');

    tweetsCheck.add(tweetId);
    tweets.insert(0,new Tweet(tweetId, userId));
  }

  List<int> getNewsFeed(int userId) {
    if (userId < 1 || userId > 500) throw Exception('invalid user');

    var condition = followees[userId] ?? <int>[];
    condition.add(userId);

    return tweets.where((tw) => condition.contains(tw.userId)).take(10).map((tw) => tw.id).toList();
  }

  void follow(int followerId, int followeeId) {
    if (followerId < 1 || followerId > 500) throw Exception('invalid user');
    if (followeeId < 1 || followeeId > 500) throw Exception('invalid user');

    var fw = followees[followerId] ?? <int>[];
    fw.add(followeeId);
    followees[followerId] = fw;
  }

  void unfollow(int followerId, int followeeId) {
    if (followerId < 1 || followerId > 500) throw Exception('invalid user');
    if (followeeId < 1 || followeeId > 500) throw Exception('invalid user');

    var fw = followees[followerId] ?? <int>[];
    fw.remove(followeeId);
    followees[followerId] = fw;
  }
}

class Tweet {
  late int id;
  late int userId;

  Tweet(int id, int userId) {
    this.id = id;
    this.userId = userId;
  }
}

```

![result](https://i.imgur.com/V4t2hmC.png)

挖靠，我根本天才，本來還想說如果太慢我就把全部的檢查都拔掉再跑一次，結果直接100 100 ...。

![oh..](https://i.imgur.com/qbUs7px.png)

好吧，白高興一場。

## Better Solutions
