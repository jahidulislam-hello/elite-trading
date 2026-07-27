import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/model/comment.dart';
import '../../data/model/post_data.dart';
import '../screen/comment_screen.dart';

class PostController extends GetxController {
  final String userAvatar = 'asset/image/profile/alex.png';

  //---------------- Posts ----------------
  final RxList<PostModel> posts = <PostModel>[].obs;

  //---------------- Comments (per selected post) ----------------
  final Rx<PostModel?> selectedPost = Rx<PostModel?>(null);
  final RxList<CommentModel> comments = <CommentModel>[].obs;
  final TextEditingController commentInputController = TextEditingController();

  int get totalComments => comments.length;

  void onPostTap(PostModel post) {
    selectedPost.value = post;
    _loadDummyComments();
    Get.to(() => const CommentScreen());
  }

  void onSendComment() {
    final text = commentInputController.text.trim();
    if (text.isEmpty) return;
    comments.add(
      CommentModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        authorInitials: 'ME',
        authorName: 'You',
        timeAgo: 'now',
        text: text,
        likes: 0,
      ),
    );
    commentInputController.clear();
  }

  @override
  void onInit() {
    super.onInit();
    _loadDummyPosts();
  }

  void _loadDummyPosts() {
    posts.assignAll([
      const PostModel(
        id: '1',
        tag: 'Market Update',
        imageAsset: 'asset/image/post/post1.png',
        authorName: 'Elite Trading',
        isVerified: true,
        timeAgo: '1h ago',
        title: 'Bitcoin Reclaims Key \$67K Level',
        description:
        'BTC has broken above the \$67,000 resistance with strong volume. Bulls are in control heading into the weekend. Our BTC/USDT long signal rem...',
        likes: 142,
        comments: 28,
        shares: 34,
      ),
      const PostModel(
        id: '2',
        tag: 'Education',
        imageAsset: 'asset/image/post/post2.png',
        authorName: 'Elite Trading',
        isVerified: true,
        timeAgo: '3h ago',
        title: 'Understanding Risk-to-Reward Ratios',
        description:
        'BTC has broken above the \$67,000 resistance with strong volume. Bulls are in control heading into the weekend. Our BTC/USDT long signal rem...',
        likes: 89,
        comments: 2,
        shares: 12,
      ),
      const PostModel(
        id: '3',
        tag: 'Market Update',
        imageAsset: 'asset/image/post/post3.png',
        authorName: 'Elite Trading',
        isVerified: true,
        timeAgo: '5h ago',
        title: 'Gold Holds Firm Above \$2,840',
        description:
        'Metals stayed resilient this week despite dollar strength. Watch the \$2,850 breakout zone for continuation setups.',
        likes: 76,
        comments: 14,
        shares: 9,
      ),
      const PostModel(
        id: '4',
        tag: 'Education',
        imageAsset: 'asset/image/post/post4.png',
        authorName: 'Elite Trading',
        isVerified: true,
        timeAgo: '1d ago',
        title: 'Reading Order Blocks Like a Pro',
        description:
        'Order blocks help identify where institutions entered the market. Here is how to spot valid zones before price reacts.',
        likes: 210,
        comments: 41,
        shares: 22,
      ),
    ]);
  }

  void _loadDummyComments() {
    comments.assignAll([
      const CommentModel(
        id: '1',
        authorInitials: 'DC',
        authorName: 'David Chen',
        timeAgo: '30m ago',
        text: 'R:R is the most underrated concept in trading. Thanks for the breakdown!',
        likes: 15,
      ),
      const CommentModel(
        id: '2',
        authorInitials: 'ML',
        authorName: 'Mia Laurent',
        timeAgo: '1h ago',
        text: 'This is exactly what every beginner needs to understand first.',
        likes: 9,
      ),
    ]);
  }

  @override
  void onClose() {
    commentInputController.dispose();
    super.onClose();
  }
}