const Message = require("./Message");
const mongoose = require("mongoose");
const Level = require("./Level");
const Interest = require("./Interest");

const ProfileSchema = mongoose.Schema({
    profilePicUUID: String,
    totalPoints: Number,
    level: Level.schema,
    interests: [Interest.schema],
    rating: Number,
});

const Profile = (module.exports = mongoose.model("Profile", ProfileSchema));

module.exports = Profile;
