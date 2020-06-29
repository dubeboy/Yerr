/**
 * Routes for user related pages:
 * - Login
 * - User account management
 * - Profile management
 */
const express = require("express");
const userController = require("../controllers/users.controller");
const profileController = require("../controllers/profile.controller");
const router = express.Router();

/**
 * @typedef Level
 * @property {string} name.required - Level Name
 * @property {string} description.required - Level Description
 */
const Level = require("../models/Level");

/**
 * @typedef Interest
 * @property {string} title.required - Title of interest (example: Food, Sports, Cars)
 * @property {string} description.required - Description of interest
 */
const Interest = require("../models/Interest");

/**
 * @typedef Address
 * @property {string} street - Street name and building number
 * @property {string} city - City/Town
 * @property {string} state - State or province depending on country
 * @property {string} postCode - Postal code
 * @property {string} country - Country of address
 */
const Address = require("../models/Address");

/**
 * @typedef Profile
 * @property {string} profilePicUUID - Profile picture ID
 * @property {number} totalPoints.required - Total profile points used to determine level
 * @property {Level.model} Level - Profile ranking based on the points gained from using the app
 * @property {Array.<Interest>} Interests - Array of interests the user is subscribed to
 * @property {integer} rating -(Profile rating Only for businesses/professionals)
 */
const Profile = require("../models/Profile");

/**
 * @typedef User
 * @property {string} username.required - Unique user identifier
 * @property {string} password.required - Password (8-16 characters)
 * @property {string} website - Website URL
 * @property {string} phoneNumber - Cell phone or contact number
 * @property {Address.model} Address - Required for business verification
 * @property {Profile.model} Profile - User profile with more details about account
 * @property {boolean} isBusiness.required - True or false value stating whether account is for business
 */
const User = require("../models/User");

/**
 * Function for login.
 * Authenticates user based on provided username and password.
 *
 * @route POST /users
 * @group user - User information
 * @param {string} username - Unique identifier of user
 * @param {string} password - Unique password to authenticate the user
 * @returns {object} 200 - Success code
 * @returns {string} AccessToken - Token to be used in the request header for managing account
 * @returns {Error} default - Unable to create user
 */
router.post("/login", userController.login);

/**
 * Function for creating a new user.
 *
 * @route POST /users
 * @group user - User information
 * @param {User} User - User to create
 * @returns {object} 200 - Success code
 * @returns {Error} default - Unable to create user
 */
router.post("/users", userController.create);

/**
 * Function for retrieving all users.
 *
 * @route GET /users
 * @group user - User information
 * @returns {object} 200 - Success code
 * @returns {Array.<User>} Users - Array of users
 * @returns {Error} default - No user found with provided ID
 */
router.get("/users", userController.readAll);

/**
 * Function for retrieving specific user.
 * Accepts a userId as a parameter and returns a single user.
 *
 * @route GET /users/user/{userId}
 * @group user - User information
 * @param {string} userId - userId to retrieve the user with
 * @returns {object} 200 - Success code
 * @returns {User.model} User - User that has the provided user ID
 * @returns {Error} default - No user found with provided ID
 */
router.get("/users/user/:userId", userController.readOne);

/**
 * Function for retrieving profile information.
 *
 * @route GET /users/user/profile/{userId}
 * @group user - User information
 * @param {string} userId - user ID to retrieve the profile with
 * @returns {object} 200 - Success code
 * @returns {Profile.model} Profile - Profile of user
 * @returns {Error}  default - No profile found
 */
router.get("/users/user/profile/:userId", profileController.readOne);

module.exports = router;
