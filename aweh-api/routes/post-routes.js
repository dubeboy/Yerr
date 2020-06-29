/**
 * Routes for post related functions
 */
//Dependency imports
const express = require("express");
const router = express.Router();
const postController = require("../controllers/posts.controller");
const Interest = require("../models/Interest");
/**
 * @typedef Vote
 * @property {string} voterID - UserId of the person that voted
 * @property {boolean} isUpVote - True or false value dictating whether the vote was positive or not
 */
const Vote = require("../models/Vote");

/**
 * @typedef Comment
 * @property {string} body.required - comment content
 * @property {string} authorName.required - username of person posting comment
 * @property {string} authorProfilePicUUID
 * @property {date} timestamp - times and date of comment
 * @property {Array.<Vote>} votes - array of votes from users
 * @property {boolean} isFlagged - True or false value stating if comment is flagged or reported
 * @property {boolean} isDeleted - True or false value stating whether a user deleted the comment
 * @property {boolean} isEdited  - True or false value stating whether the comment has been updated since being posted
 */
const Comment = require("../models/Comment");

/**
 * @typedef Media
 * @property {string} uuid.required - unique identifier of the
 * @property {string} type.required - type of file (jpg, mp4)
 * @property {string} metadata - data related to the file
 */
const Media = require("../models/Media");

/**
 * @typedef Post
 * @property {string} body.required - post content
 * @property {date} timestamp - times and date of post
 * @property {string} authorName - username of user that's posting
 * @property {string} authorProfilePicUUID - unique identifier of thr user's profile picture
 * @property {Interest.model} interest - interest the post relates to
 * @property {Media.model} Media - attached media file
 * @property {Array.<Comment>} Comments - Collection of comments on the post
 * @property {boolean} isEmergency - True or false value of whether the post is an emergency or not
 * @property {boolean} isFlagged - True or false value to track whether post is reported/flagged
 * @property {boolean} isDeleted - True or false value to stating whether user has deleted their post
 * @property {number} timeLimit - Number dictating how many hours on main page user's post get to stay
 */
const Post = require("../models/Post");

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
 * Function for retrieving a all posts.
 *
 * @route GET /posts
 * @group posts - Post management
 * @operationId getAllPosts
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
