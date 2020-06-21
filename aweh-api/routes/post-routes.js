/**
 * Routes for post related queries
 */
//Dependency imports
const express = require("express");
const postController = require("../controllers/posts.controller");

/**
 * @typedef Post
 * @property {string} body.required - post content
 * @property {Date} timestamp - times and date of post
 */
const Post = require("../models/Post");

/**
 * @typedef Comment
 * @property {string} body.required - comment content
 * @property {Date} timestamp - times and date of comment
 */
const Comment = require("../models/Comment");

const router = express.Router();

/**
 * Function for creating a new post.
 *
 * @route POST /posts
 * @group posts - Post management
 * @operationId createPost
 * @param {Post.model} post.body.required - post content
 * @returns {object} 200 - Success
 * @returns {Error}  default
 */
router.post("/", postController.create);

/**
 * Function for retrieving a specific post.
 *
 * @route GET /posts
 * @group posts - Post management
 * @operationId getAllPosts
 * @param {string} postId - ID to retrieve the post with
 * @returns {object} 200 - Success
 * @returns {Array.<Post>} PostList - Array of posts
 * @returns {Error}  default
 */
router.get("/", postController.readAll);

/**
 * Function for retrieving a specific post.
 *
 * @route GET /posts/{postId}
 * @group posts - Post management
 * @operationId getPostByID
 * @param {string} postId - ID to retrieve the post with
 * @returns {object} 200 - Success
 * @returns {Post.model} Post - Public post made by user
 * @returns {Error}  default
 */
router.get("/posts/:postId", postController.readOne);

/**
 * Function for updating a specific post.
 *
 * @route PUT /posts/{postId}
 * @group posts - Post management
 * @operationId updatePostByID
 * @param {string} postId - ID of post to update
 * @returns {object} 200 - Success
 * @returns {Error}  default
 */
router.put("/posts/:postId", postController.update);

/**
 * Function for retrieving a specific post.
 *
 * @route DELETE /posts/{postId}
 * @group posts - Post management
 * @operationId deletePostByID
 * @param {string} postId - ID of post to delete
 * @returns {object} 200 - Success
 * @returns {Error}  default
 */
router.delete("/posts/:postId", postController.delete);

module.exports = router;
