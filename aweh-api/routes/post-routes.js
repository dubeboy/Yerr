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

//Create Post
router.post("/", (req, res, next) => {
    let newPost = new Post({
        body: req.body.body,
        timestamp: req.body.timestamp,
        author: {
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

    newPost.save();
});

//Get All Users
router.get("/", async (req, res) => {
    const users = await User.find({});

    try {
        res.send(users);
    } catch (err) {
        res.status(500).send(err);
    }
});

//GetUser
router.get("/user/:userId", (req, res, next, id) => {
    User.findOne({ _id: id }, function (err, user) {
        if (err) {
            next(err);
        } else {
            req.user = user;
            next();
        }
    });
});

/**
 * Function for retrieving profile information.
 *
 * @route GET /user/profile/{userId}
 * @group user - User information
 * @param {string} userId - user ID to retrieve the profile with
 * @returns {object} 200 - Success
 * @returns {Profile.model} Profile - Profile of user
 * @returns {Error}  default - No profile found
 */
router.get(
    "/user/profile/:userId",
    /*passport.authenticate('jwt', { session: false }),*/ (
        req,
        res,
        next,
        id
    ) => {
        User.findOne({ _id: id }, (err, user) => {
            if (err) {
                throw err;
            } else if (!user) {
                return res.json({
                    success: false,
                    msg: "No profile found for username:" + name,
                });
            }

            res.json({ profile: user.profile });
            next();
        });
    }
);

module.exports = router;
