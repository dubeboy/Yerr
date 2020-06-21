/**
 * Routes for user related pages:
 * - Login
 * - Profile
 */
//Dependency imports
const express = require("express");
const jwt = require("jsonwebtoken");
const db = require("../config/db");
const userController = require("../controllers/users.controller");
const User = require("../models/User");

/**
 * @typedef Profile
 * @property {string} profilePicUUID.required - Profile picture ID
 * @property {integer} rating -( Profile rating Only for businesses/professionals)
 */
const Profile = require("../models/Profile");

const router = express.Router();

//UserLogin
router.post("/login", userController.login);

//CreateUser
router.post("/", userController.create);

//Get All Users
router.get("/", userController.readAll);

//GetUser
router.get("/user/:userId", userController.readOne);

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
router.get("/user/profile/:userId", (req, res, next, id) => {
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
});

module.exports = router;
