/**
 * Routes for user related pages:
 * - Login
 * - Profile
 */
//Dependency imports
const express = require("express");
//const passport = require("passport");
const jwt = require("jsonwebtoken");
const db = require("../config/db");

const User = require("../models/User");

/**
 * @typedef Profile
 * @property {string} profilePicUUID.required - Profile picture ID
 * @property {integer} rating - Profile rating (Only for businesses/professionals)
 */
const Profile = require("../models/Profile");

const router = express.Router();

//UserLogin
router.post("/login", (req, res, next) => {
    const username = req.body.username;
    const password = req.body.password;

    User.find({ username: username }, (err, user) => {
        if (err) {
            throw err;
        } else if (!user) {
            return res.json({ success: false, msg: "No user found" });
        }

        User.verifyPassword(password, user.password, (err, isCorrect) => {
            if (err) {
                throw err;
            } else if (isCorrect) {
                //Creating a signed token that expires in a week
                const token = jwt.sign(user.toJSON(), db.secret, {
                    expiresIn: 604880,
                });

                res.json({
                    success: true,
                    token: "JWT " + token,
                    user: {
                        id: user._id,
                        name: user.username,
                        email: user.email,
                    },
                });
            } else {
                return res.json({
                    success: false,
                    msg: "Incorrect details entered",
                });
            }
        });
    });
});

//CreateUser
router.post("/", (req, res, next) => {
    let newUser = new User({
        name: req.body.name,
        username: req.body.username,
        email: req.body.email,
        password: req.body.password,
    });

    User.addUser(newUser, (err, user) => {
        if (err) {
            res.json({
                success: false,
                msg: "Failed to create user",
            });
        } else {
            res.json({
                success: true,
                msg: "User created",
            });
        }
    });
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
