import '../../core/constants/api_endpoints.dart';
import '../../core/exceptions/app_exceptions.dart';
import '../../core/services/api_service.dart';
import '../../core/utils/access_parser.dart';
import 'data/model/post_model.dart';

/// Handles all post-related API calls for the mobile app.
///
/// Maps 1-to-1 with backend routes at:
///   backend/src/modules/basic_modules/post/post.route.ts  (app section)
class PostService {
  final ApiService _api;

  PostService({ApiService? apiService}) : _api = apiService ?? ApiService();

  // ──────────────────────────────────────────────────────────────────────────
  // 1. GET POSTS (feed)
  // GET /api/v1/post/app?page=&limit=&category=
  // ──────────────────────────────────────────────────────────────────────────
  Future<PostListResult> getPosts({
    int page = 1,
    int limit = 20,
    String? category,
  }) async {
    final query = <String, dynamic>{
      'page': page,
      'limit': limit,
      if (category != null && category != 'All') 'category': category,
    };
    final response =
        await _api.get(ApiEndpoints.postsApp, queryParameters: query);
    _assertSuccess(response.data, 'Failed to load posts.');
    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    final rawPosts = data['posts'] as List? ?? [];
    return PostListResult(
      access: parseAccessLevel(data['access']),
      posts: rawPosts
          .map((e) => PostModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPosts: (data['totalPosts'] as num?)?.toInt() ?? 0,
      pagination: response.data['pagination'] as Map<String, dynamic>?,
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 2. GET POST DETAIL
  // GET /api/v1/post/app/:id
  // ──────────────────────────────────────────────────────────────────────────
  Future<PostModel> getPostDetail(String id) async {
    final response = await _api.get(ApiEndpoints.postDetail(id));
    _assertSuccess(response.data, 'Failed to load post.');
    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    final postJson = data['post'] as Map<String, dynamic>? ?? data;
    return PostModel.fromJson(postJson);
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 3. GET POST COMMENTS
  // GET /api/v1/post/app/:id/comments?page=&limit=
  // ──────────────────────────────────────────────────────────────────────────
  Future<CommentListResult> getPostComments(
    String postId, {
    int page = 1,
    int limit = 30,
  }) async {
    final query = <String, dynamic>{'page': page, 'limit': limit};
    final response = await _api.get(
      ApiEndpoints.postComments(postId),
      queryParameters: query,
    );
    _assertSuccess(response.data, 'Failed to load comments.');
    final data = response.data['data'];
    List rawComments = [];
    if (data is List) {
      rawComments = data;
    } else if (data is Map<String, dynamic>) {
      rawComments = data['comments'] as List? ?? [];
    }
    return CommentListResult(
      comments: rawComments
          .map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: data is Map<String, dynamic>
          ? data['pagination'] as Map<String, dynamic>?
          : response.data['pagination'] as Map<String, dynamic>?,
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 4. CREATE COMMENT
  // POST /api/v1/post/app/:id/comments  body: { text }
  // ──────────────────────────────────────────────────────────────────────────
  Future<CommentModel> createComment(String postId, String text) async {
    final response = await _api.post(
      ApiEndpoints.createComment(postId),
      data: {'text': text},
    );
    _assertSuccess(response.data, 'Failed to post comment.');
    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    return CommentModel.fromJson(data);
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 5. UPDATE COMMENT
  // PATCH /api/v1/post/app/comments/:commentId  body: { text }
  // ──────────────────────────────────────────────────────────────────────────
  Future<CommentModel> updateComment(String commentId, String text) async {
    final response = await _api.patch(
      ApiEndpoints.updateComment(commentId),
      data: {'text': text},
    );
    _assertSuccess(response.data, 'Failed to update comment.');
    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    return CommentModel.fromJson(data);
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 6. DELETE COMMENT
  // DELETE /api/v1/post/app/comments/:commentId
  // ──────────────────────────────────────────────────────────────────────────
  Future<void> deleteComment(String commentId) async {
    final response =
        await _api.delete(ApiEndpoints.deleteComment(commentId));
    _assertSuccess(response.data, 'Failed to delete comment.');
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 7. TOGGLE POST LIKE
  // POST /api/v1/post/app/:id/like
  // Returns: { isLiked, likesCount }
  // ──────────────────────────────────────────────────────────────────────────
  Future<ToggleLikeResult> togglePostLike(String postId) async {
    final response = await _api.post(ApiEndpoints.togglePostLike(postId));
    _assertSuccess(response.data, 'Failed to toggle like.');
    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    return ToggleLikeResult(
      isLiked: data['isLiked'] as bool? ?? false,
      likesCount: (data['likesCount'] as num?)?.toInt() ?? 0,
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 8. TOGGLE COMMENT LIKE
  // POST /api/v1/post/app/comments/:commentId/like
  // Returns: { isLiked, likesCount }
  // ──────────────────────────────────────────────────────────────────────────
  Future<ToggleLikeResult> toggleCommentLike(String commentId) async {
    final response =
        await _api.post(ApiEndpoints.toggleCommentLike(commentId));
    _assertSuccess(response.data, 'Failed to toggle comment like.');
    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    return ToggleLikeResult(
      isLiked: data['isLiked'] as bool? ?? false,
      likesCount: (data['likesCount'] as num?)?.toInt() ?? 0,
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 9. SHARE POST
  // POST /api/v1/post/app/:id/share
  // ──────────────────────────────────────────────────────────────────────────
  Future<int> sharePost(String postId) async {
    final response = await _api.post(ApiEndpoints.sharePost(postId));
    _assertSuccess(response.data, 'Failed to record share.');
    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    return (data['sharesCount'] as num?)?.toInt() ?? 0;
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Helper
  // ──────────────────────────────────────────────────────────────────────────
  void _assertSuccess(dynamic responseData, String fallback) {
    if (responseData is Map<String, dynamic>) {
      if (responseData['success'] == false) {
        final msg = responseData['message'] as String?;
        throw ServerException(
            msg?.isNotEmpty == true ? msg! : fallback, null);
      }
    }
  }
}
