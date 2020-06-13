const Message = require("./Message");
const mongoose = require("mongoose");

const ProfileSchema = mongoose.Schema({
    profilePicUUID: String,
    reputation: {
        totalPoints: Number,
        level: {
            name: String,
            description: String
        },
    },
    interests: [{
        title: String,
        description: String,
    }],
    rating: Number,
});

const Profile = module.exports = mongoose.model('Profile', ProfileSchema);

module.exports = Profile;