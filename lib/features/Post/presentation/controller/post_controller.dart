import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../data/model/post_model.dart';
import '../../post_service.dart';
import '../screen/comment_screen.dart';

class PostController extends GetxController {
  // ─── Service ──────────────────────────────────────────────────────────────
  final PostService _service = PostService();

  // ─── Post feed ────────────────────────────────────────────────────────────
  final RxList<PostModel> posts = <PostModel>[].obs;
  final RxBool isPostsLoading = false.obs;
  final RxString postsError = ''.obs;
  final RxString accessLevel = 'full'.obs;
  final RxInt totalPosts = 0.obs;
  final RxBool isLoadingMorePosts = false.obs;
  int _currentPostsPage = 1;
  int _totalPostsPages = 1;
  int _postsRequestId = 0;

  // ─── Selected post + comments ────────────────────────────────────────────
  final Rx<PostModel?> selectedPost = Rx<PostModel?>(null);
  final RxList<CommentModel> comments = <CommentModel>[].obs;
  final RxBool isCommentsLoading = false.obs;
  final RxBool isLoadingMoreComments = false.obs;
  final RxString commentsError = ''.obs;
  int _currentCommentsPage = 1;
  int _totalCommentsPages = 1;
  int _commentsRequestId = 0;
  final TextEditingController commentInputController = TextEditingController();
  final RxBool isSendingComment = false.obs;

  int get totalComments => selectedPost.value?.commentsCount ?? comments.length;
  bool get hasMorePosts => _currentPostsPage < _totalPostsPages;
  bool get hasMoreComments => _currentCommentsPage < _totalCommentsPages;

  // ─── Lifecycle ────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    loadPosts();
  }

  // ─── Data loading ─────────────────────────────────────────────────────────

  Future<void> loadPosts({bool refresh = false, bool loadMore = false}) async {
    if (loadMore &&
        (isPostsLoading.value ||
            isLoadingMorePosts.value ||
            _currentPostsPage >= _totalPostsPages)) {
      return;
    }

    if (refresh) {
      _currentPostsPage = 0;
      _totalPostsPages = 1;
      posts.clear();
      isLoadingMorePosts.value = false;
    }

    final requestedPage = loadMore ? _currentPostsPage + 1 : 1;
    final requestId = ++_postsRequestId;
    if (loadMore) {
      isLoadingMorePosts.value = true;
    } else {
      isPostsLoading.value = true;
    }
    postsError.value = '';
    try {
      final result = await _service.getPosts(page: requestedPage);
      if (requestId != _postsRequestId) return;

      if (loadMore) {
        posts.addAll(result.posts);
      } else {
        posts.value = result.posts;
      }
      accessLevel.value = result.access; // 'full' or 'limited'
      totalPosts.value = result.totalPosts;
      _currentPostsPage = requestedPage;
      _totalPostsPages = _totalPagesFrom(result.pagination, requestedPage);
      // 'limited' is not an error — the screen renders the upgrade UI instead
    } on SubscriptionRequiredException {
      if (requestId != _postsRequestId) return;
      accessLevel.value = 'limited';
      posts.clear();
      postsError.value = '';
    } on ServerException catch (e) {
      if (requestId != _postsRequestId) return;
      if (e.statusCode == 403) {
        accessLevel.value = 'limited';
        posts.clear();
        postsError.value = '';
      } else {
        postsError.value = e.message;
      }
    } on AppException catch (e) {
      if (requestId != _postsRequestId) return;
      postsError.value = e.message;
    } catch (e, s) {
      if (requestId != _postsRequestId) return;
      debugPrint('loadPosts failed: $e\n$s');
      postsError.value = 'Failed to load posts. Please try again.';
    } finally {
      if (requestId == _postsRequestId) {
        isPostsLoading.value = false;
        isLoadingMorePosts.value = false;
      }
    }
  }

  int _totalPagesFrom(Map<String, dynamic>? pagination, int fallbackPage) {
    final value = pagination?['totalPage'];
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallbackPage;
    return fallbackPage;
  }

  // ─── Navigation: open post detail / comments ──────────────────────────────

  void onPostTap(PostModel post) {
    selectedPost.value = post;
    comments.clear();
    commentsError.value = '';
    _currentCommentsPage = 0;
    _totalCommentsPages = 1;
    isLoadingMoreComments.value = false;
    Get.to(() => const CommentScreen());
    _loadComments(post.id);
  }

  Future<void> _loadComments(String postId, {bool loadMore = false}) async {
    if (loadMore &&
        (isCommentsLoading.value ||
            isLoadingMoreComments.value ||
            !hasMoreComments)) {
      return;
    }

    final requestedPage = loadMore ? _currentCommentsPage + 1 : 1;
    final requestId = ++_commentsRequestId;
    if (loadMore) {
      isLoadingMoreComments.value = true;
    } else {
      isCommentsLoading.value = true;
    }
    commentsError.value = '';
    try {
      final result = await _service.getPostComments(
        postId,
        page: requestedPage,
      );
      if (requestId != _commentsRequestId) return;

      if (loadMore) {
        comments.addAll(result.comments);
      } else {
        comments.value = result.comments;
      }
      _currentCommentsPage = requestedPage;
      _totalCommentsPages = _totalPagesFrom(result.pagination, requestedPage);
    } on AppException catch (e) {
      if (requestId != _commentsRequestId) return;
      commentsError.value = e.message;
    } catch (_) {
      if (requestId != _commentsRequestId) return;
      commentsError.value = 'Failed to load comments.';
    } finally {
      if (requestId == _commentsRequestId) {
        isCommentsLoading.value = false;
        isLoadingMoreComments.value = false;
      }
    }
  }

  Future<void> loadMoreComments(String postId) =>
      _loadComments(postId, loadMore: true);

  // ─── Comments ─────────────────────────────────────────────────────────────

  Future<void> onSendComment() async {
    final text = commentInputController.text.trim();
    if (text.isEmpty) return;
    final post = selectedPost.value;
    if (post == null) return;

    isSendingComment.value = true;
    try {
      final comment = await _service.createComment(post.id, text);
      comments.insert(0, comment);
      commentInputController.clear();
      // Update comment count on the post in the feed
      _updatePostInList(post.id, commentsCount: post.commentsCount + 1);
    } on AppException catch (e) {
      _showError(e.message);
    } catch (_) {
      _showError('Failed to send comment. Please try again.');
    } finally {
      isSendingComment.value = false;
    }
  }

  Future<void> onDeleteComment(String commentId) async {
    final index = comments.indexWhere((c) => c.id == commentId);
    if (index < 0) return;
    final removed = comments[index];
    comments.removeAt(index); // optimistic
    try {
      await _service.deleteComment(commentId);
      final post = selectedPost.value;
      if (post != null) {
        _updatePostInList(post.id,
            commentsCount: (post.commentsCount - 1).clamp(0, 99999));
      }
    } catch (_) {
      comments.insert(index, removed); // revert
      _showError('Failed to delete comment.');
    }
  }

  Future<void> onToggleCommentLike(String commentId) async {
    final index = comments.indexWhere((c) => c.id == commentId);
    if (index < 0) return;
    final old = comments[index];
    // optimistic
    comments[index] = old.copyWith(
      isLiked: !old.isLiked,
      likes: old.isLiked ? old.likes - 1 : old.likes + 1,
    );
    try {
      final result = await _service.toggleCommentLike(commentId);
      comments[index] = comments[index]
          .copyWith(isLiked: result.isLiked, likes: result.likesCount);
    } catch (_) {
      comments[index] = old; // revert
    }
  }

  // ─── Post like / share ────────────────────────────────────────────────────

  Future<void> onTogglePostLike(String postId) async {
    final index = posts.indexWhere((p) => p.id == postId);
    if (index < 0) return;
    final old = posts[index];
    // optimistic
    posts[index] = old.copyWith(
      isLiked: !old.isLiked,
      likes: old.isLiked ? old.likes - 1 : old.likes + 1,
    );
    // Also update selectedPost if open
    if (selectedPost.value?.id == postId) {
      selectedPost.value = posts[index];
    }
    try {
      final result = await _service.togglePostLike(postId);
      posts[index] = posts[index]
          .copyWith(isLiked: result.isLiked, likes: result.likesCount);
      if (selectedPost.value?.id == postId) {
        selectedPost.value = posts[index];
      }
    } catch (_) {
      posts[index] = old; // revert
      if (selectedPost.value?.id == postId) selectedPost.value = old;
    }
  }

  Future<void> onSharePost(String postId) async {
    final post = posts.firstWhereOrNull((p) => p.id == postId) ??
        (selectedPost.value?.id == postId ? selectedPost.value : null);
    if (post == null) return;

    final shareUrl = '${ApiConstants.baseUrl}/post/$postId';
    final text = '${post.title}\n\n'
        '${post.excerpt}\n\n'
        'View on Elite Trading: $shareUrl';

    try {
      final result = await SharePlus.instance.share(
        ShareParams(
          text: text,
          subject: post.title,
        ),
      );

      // Do not count a share when the user closes the platform share sheet.
      if (result.status == ShareResultStatus.dismissed) return;

      await _recordShare(postId);
    } on MissingPluginException catch (e, s) {
      debugPrint('sharePost plugin unavailable: $e\n$s');
      await Clipboard.setData(ClipboardData(text: shareUrl));
      Get.snackbar(
        'Link copied',
        'Share sheet is unavailable, so the post link was copied instead.',
        snackPosition: SnackPosition.BOTTOM,
      );
      await _recordShare(postId);
    } catch (e, s) {
      debugPrint('sharePost failed: $e\n$s');
      _showError('Unable to share this post. Please try again.');
    }
  }

  Future<void> _recordShare(String postId) async {
    final sharesCount = await _service.sharePost(postId);
    _updatePostInList(postId, sharesCount: sharesCount);
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────

  void _updatePostInList(String postId,
      {int? likes, int? commentsCount, int? sharesCount, bool? isLiked}) {
    final index = posts.indexWhere((p) => p.id == postId);
    if (index >= 0) {
      posts[index] = posts[index].copyWith(
        likes: likes,
        commentsCount: commentsCount,
        sharesCount: sharesCount,
        isLiked: isLiked,
      );
    }
    if (selectedPost.value?.id == postId) {
      selectedPost.value = selectedPost.value!.copyWith(
        likes: likes,
        commentsCount: commentsCount,
        sharesCount: sharesCount,
        isLiked: isLiked,
      );
    }
  }

  void _showError(String msg) {
    if (Get.isSnackbarOpen) Get.closeAllSnackbars();
    Get.snackbar(
      'Error',
      msg,
      backgroundColor: const Color(0xFF3A1010),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 4),
      icon: const Icon(Icons.error_outline, color: Colors.redAccent),
    );
  }

  // ─── Dispose ─────────────────────────────────────────────────────────────

  @override
  void onClose() {
    commentInputController.dispose();
    super.onClose();
  }
}
