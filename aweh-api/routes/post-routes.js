/**
 * Routes for post related queries
 */
//Dependency imports
const express = require("express");
const db = require("../config/db");

/**
 * @typedef Post
 * @property {string} body.required - post content
 * @property {dateTime} timestamp - times and date of post
 */
const Post = require("../models/Post");

/**
 * @typedef Comment
 * @property {string} body.required - comment content
 * @property {dateTime} timestamp - times and date of comment
 */
const Comment = require("../models/Comment");

const router = express.Router();

/**
 * Function for creating a new post.
 *
 * @route POST /posts
 * @group posts - Post information
 * @operationId createPost
 * @param {Post.model} post.body.required - post content
 * @returns {object} 200 - Success
 * @returns {Error}  default - No posts found
 */
router.post("/", (req, res, next) => {
    let newPost = new Post({
        body: req.body.body,
        timestamp: req.body.timestamp,
        author: {
            id: req.body.author.id,
            username: req.body.username,
            profilePicUUID: req.body.profilePictureUUID,
        },
        media: {
            uuid: req.body.media.uuid,
            type: req.body.media.type,
            metaData: req.body.media.metaData,
        },
        comments: [],
        isEmergency: req.body.isEmergency,
        isFlagged: req.body.isFlagged,
        isHidden: req.body.isHidden,
        timeLimit: req.body.timeLimit,
    });

    newPost
        .save(newPost)
        .then((data) => {
            res.send(data);
        })
        .catch((error) => {
            res.status(500).send({
                message: error.message || "Unable to save. Please try again.",
            });
        });
});

/**
 * Function for retrieving a specific post.
 *
 * @route GET /posts
 * @group posts - Post information
 * @operationId getAllPosts
 * @param {string} postId - ID to retrieve the post with
 * @returns {object} 200 - Success
 * @returns {Array.<Post>} PostList - Array of posts
 * @returns {Error}  default - No post found, may be deleted
 */
router.get("/", async (req, res) => {
    const posts = await Post.find({});

    try {
        res.send(posts);
    } catch (err) {
        res.status(500).send(err);
    }
});

/**
 * Function for retrieving a specific post.
 *
 * @route GET /posts/{postId}
 * @group posts - Post information
 * @operationId getPostByID
 * @param {string} postId - ID to retrieve the post with
 * @returns {object} 200 - Success
 * @returns {Post.model} Post - Public post made by user
 * @returns {Error}  default - No post found, may be deleted
 */
router.get("/posts/:postId", (req, res, next, id) => {
    User.findOne({ _id: postId }, function (err, user) {
        if (err) {
            next(err);
        } else {
            req.user = user;
            next();
        }
    });
});

module.exports = router;
