import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  // ─── Selected post + comments ────────────────────────────────────────────
  final Rx<PostModel?> selectedPost = Rx<PostModel?>(null);
  final RxList<CommentModel> comments = <CommentModel>[].obs;
  final RxBool isCommentsLoading = false.obs;
  final RxString commentsError = ''.obs;
  final TextEditingController commentInputController = TextEditingController();
  final RxBool isSendingComment = false.obs;

  int get totalComments => comments.length;

  // ─── Lifecycle ────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    loadPosts();
  }

  // ─── Data loading ─────────────────────────────────────────────────────────

  Future<void> loadPosts({bool refresh = false}) async {
    if (refresh) posts.clear();
    isPostsLoading.value = true;
    postsError.value = '';
    try {
      final result = await _service.getPosts();
      posts.value = result.posts;
      accessLevel.value = result.access;
      totalPosts.value = result.totalPosts;
    } on AppException catch (e) {
      postsError.value = e.message;
    } catch (_) {
      postsError.value = 'Failed to load posts. Please try again.';
    } finally {
      isPostsLoading.value = false;
    }
  }

  // ─── Navigation: open post detail / comments ──────────────────────────────

  void onPostTap(PostModel post) {
    selectedPost.value = post;
    comments.clear();
    commentsError.value = '';
    Get.to(() => const CommentScreen());
    _loadComments(post.id);
  }

  Future<void> _loadComments(String postId) async {
    isCommentsLoading.value = true;
    commentsError.value = '';
    try {
      final result = await _service.getPostComments(postId);
      comments.value = result.comments;
    } on AppException catch (e) {
      commentsError.value = e.message;
    } catch (_) {
      commentsError.value = 'Failed to load comments.';
    } finally {
      isCommentsLoading.value = false;
    }
  }

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
      comments[index] =
          comments[index].copyWith(isLiked: result.isLiked, likes: result.likesCount);
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
      posts[index] =
          posts[index].copyWith(isLiked: result.isLiked, likes: result.likesCount);
      if (selectedPost.value?.id == postId) {
        selectedPost.value = posts[index];
      }
    } catch (_) {
      posts[index] = old; // revert
      if (selectedPost.value?.id == postId) selectedPost.value = old;
    }
  }

  Future<void> onSharePost(String postId) async {
    try {
      await _service.sharePost(postId);
      _updatePostInList(postId,
          sharesCount: (posts.firstWhereOrNull((p) => p.id == postId)
                  ?.sharesCount ??
              0) +
              1);
    } catch (_) {
      // Share recording is best-effort; don't show error to user
    }
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────

  void _updatePostInList(String postId,
      {int? likes, int? commentsCount, int? sharesCount, bool? isLiked}) {
    final index = posts.indexWhere((p) => p.id == postId);
    if (index < 0) return;
    posts[index] = posts[index].copyWith(
      likes: likes,
      commentsCount: commentsCount,
      sharesCount: sharesCount,
      isLiked: isLiked,
    );
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
