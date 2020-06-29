const User = require("../models/User");

exports.readOne = (req, res) => {
    const userId = req.params.id;
    /*passport.authenticate('jwt', { session: false }),*/
    User.findById(userId)
        .then((user) => {
            if (!user) {
                res.status(404).send({ message: "Profile not found" });
            } else {
                res.send(user.profile);
            }
        })
        .catch((error) => {
            res.status(500).send({
                message:
                    error.message ||
                    "Unable to get the specific profile. Server error occurred.",
            });
        });
};
