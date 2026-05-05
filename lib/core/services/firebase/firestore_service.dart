import 'package:cloud_firestore/cloud_firestore.dart';
import '../logger/logger_service.dart';

/// Single wrapper for all [FirebaseFirestore] SDK calls.
///
/// Provides typed collection references and generic CRUD helpers.
/// No other file in the app should import `cloud_firestore` directly
/// (except this service and data-layer models for [Timestamp] etc.).
class FirestoreService {
  final FirebaseFirestore _firestore;
  final LoggerService _logger;

  FirestoreService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _logger = LoggerService(className: 'FirestoreService');

  // ---------------------------------------------------------------------------
  // Collection References
  // ---------------------------------------------------------------------------

  /// Reference to the `users` collection.
  CollectionReference<Map<String, dynamic>> get usersCollection =>
      _firestore.collection('users');

  /// Reference to the `posts` collection.
  CollectionReference<Map<String, dynamic>> get postsCollection =>
      _firestore.collection('posts');

  /// Reference to the `likes` sub-collection under a specific post.
  CollectionReference<Map<String, dynamic>> likesCollection(String postId) =>
      _firestore.collection('posts').doc(postId).collection('likes');

  /// Reference to the `comments` sub-collection under a specific post.
  CollectionReference<Map<String, dynamic>> commentsCollection(String postId) =>
      _firestore.collection('posts').doc(postId).collection('comments');

  // ---------------------------------------------------------------------------
  // Generic CRUD Helpers
  // ---------------------------------------------------------------------------

  /// Sets (creates or overwrites) a document at [docId] in [ref].
  Future<void> setDocument(
    CollectionReference<Map<String, dynamic>> ref,
    String docId,
    Map<String, dynamic> data,
  ) async {
    _logger.info('Setting document: ${ref.path}/$docId');
    await ref.doc(docId).set(data);
    _logger.success('Document set: ${ref.path}/$docId');
  }

  /// Gets a single document by [docId] from [ref].
  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument(
    CollectionReference<Map<String, dynamic>> ref,
    String docId,
  ) async {
    _logger.info('Getting document: ${ref.path}/$docId');
    final doc = await ref.doc(docId).get();
    _logger.success(
      'Document retrieved: ${ref.path}/$docId (exists: ${doc.exists})',
    );
    return doc;
  }

  /// Updates specific fields on an existing document at [docId] in [ref].
  Future<void> updateDocument(
    CollectionReference<Map<String, dynamic>> ref,
    String docId,
    Map<String, dynamic> data,
  ) async {
    _logger.info('Updating document: ${ref.path}/$docId');
    await ref.doc(docId).update(data);
    _logger.success('Document updated: ${ref.path}/$docId');
  }

  /// Deletes a document at [docId] from [ref].
  Future<void> deleteDocument(
    CollectionReference<Map<String, dynamic>> ref,
    String docId,
  ) async {
    _logger.info('Deleting document: ${ref.path}/$docId');
    await ref.doc(docId).delete();
    _logger.success('Document deleted: ${ref.path}/$docId');
  }

  /// Provides access to the underlying [FirebaseFirestore] instance
  /// for batch writes and transactions that need it.
  FirebaseFirestore get firestore => _firestore;
}
