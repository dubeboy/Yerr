const User = require("../models/User");
//const passport = require("passport");

exports.create = (req, res) => {
    let newUser = new User({
        name: req.body.name,
        username: req.body.username,
        email: req.body.email,
        password: req.body.password,
    });

    User.save(newUser)
        .then((user) => {
            res.send(user);
        })
        .catch((error) => {
            res.status(500).send({
                message:
                    error.message || "Unable to save. Error occurred on server",
            });
        });
};

exports.readAll = async (req, res) => {
    await User.find({})
        .then((users) => {
            if (!users) {
                res.status(404).send({ message: "No users found" });
            } else {
                res.send(users);
            }
        })
        .catch((error) => {
            res.status(500).send({
                message:
                    error.message ||
                    "Unable to get all users. Server error occurred.",
            });
        });
};

exports.readOne = (req, res) => {
    const userId = req.params.id;
    /*passport.authenticate('jwt', { session: false }),*/
    User.findById(userId)
        .then((user) => {
            if (!user) {
                res.status(404).send({ message: "User not found" });
            } else {
                res.send(user);
            }
        })
        .catch((error) => {
            res.status(500).send({
                message:
                    error.message ||
                    "Unable to get the specific user. Server error occurred.",
            });
        });
};

exports.update = (req, res) => {
    if (!req.body) {
        return res.status(400).send({
            message: "Please provide a valid user",
        });
    }

    const userId = req.params.id;

    User.findByIdAndUpdate(userId, req.body, { useFindAndModify: false })
        .then((user) => {
            if (!user) {
                console.log(
                    `Cannot update user with id=${userId}. user was not found`
                );
                res.status(404).send({
                    message: "Could not find user to update",
                });
            } else res.send({ message: "user updated" });
        })
        .catch((error) => {
            console.log("Failed to update user=" + userId);
            res.status(500).send({
                message:
                    error.message ||
                    "Unable to update user. Server Error occurred",
            });
        });
};

exports.delete = (req, res) => {
    const userId = req.params.id;

    User.findByIdAndRemove(userId)
        .then((user) => {
            if (!user) {
                console.log(
                    `Cannot delete user with id=${userId}. user was not found`
                );
                res.status(404).send({
                    message: "Could not find user to delete",
                });
            } else res.send({ message: "user deleted" });
        })
        .catch((error) => {
            console.log("Failed to delete user=" + userId);
            res.status(500).send({
                message:
                    error.message ||
                    "Failed to delete user. Server Error occurred",
            });
        });
};

exports.login = (req, res) => {
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
};
