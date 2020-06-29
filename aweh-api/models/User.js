/**
 * Users model for user related CRUD
 */
//Dependency imports
const mongoose = require("mongoose");
const bcrypt = require("bcryptjs");
const Profile = require("./Profile");
const Address = require("./Address");

const UserSchema = mongoose.Schema({
    username: {
        type: String,
        required: true,
    },
    password: {
        type: String,
        required: true,
    },
    website: String,
    phoneNumber: String,
    address: Address.schema,
    profile: Profile.schema,
    isBusiness: Boolean,
});

const User = (module.exports = mongoose.model("User", UserSchema));

module.exports = User;

module.exports.addUser = function (newUser, callback) {
    bcrypt.genSalt(10, (err, salt) => {
        bcrypt.hash(newUser.password, salt, (err, hash) => {
            if (err) {
                throw err;
            }
            newUser.password = hash;
            newUser.save(newUser, callback);
        });
    });
};

module.exports.verifyPassword = function (password, hash, callback) {
    bcrypt.compare(password, hash, (err, isCorrect) => {
        if (err) {
            throw err;
        }
        callback(null, isCorrect);
    });
};
