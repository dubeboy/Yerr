const Post = require("../models/Post");

exports.create = (req, res) => {
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
                message: error.message || "Unable to save. Please try again",
            });
        });
};

exports.readAll = async (req, res) => {
    await Post.find({})
        .then((posts) => {
            if (!posts) {
                res.status(404).send({ message: "No posts found" });
            } else {
                res.send(posts);
            }
        })
        .catch((error) => {
            res.status(500).send({
                message:
                    error.message ||
                    "Unable to get all posts. Server error occurred.",
            });
        });
};

exports.readOne = (req, res) => {
    const postId = req.params.id;

    Post.findById(postId)
        .then((post) => {
            if (!post) {
                res.status(404).send({ message: "Post not found" });
            } else {
                res.send(post);
            }
        })
        .catch((error) => {
            res.status(500).send({
                message:
                    error.message ||
                    "Unable to get your post. Server error occurred.",
            });
        });
};

exports.update = (req, res) => {
    if (!req.body) {
        return res.status(400).send({
            message: "Please provide a valid post",
        });
    }

    const postId = req.params.id;

    Post.findByIdAndUpdate(postId, req.body, { useFindAndModify: false })
        .then((post) => {
            if (!post) {
                console.log(
                    `Cannot update post with id=${postId}. Post was not found`
                );
                res.status(404).send({
                    message: "Could not find post to update",
                });
            } else res.send({ message: "Post updated" });
        })
        .catch((error) => {
            console.log("Failed to update post=" + postId);
            res.status(500).send({
                message:
                    error.message ||
                    "Unable to update post. Server Error occurred",
            });
        });
};

exports.delete = (req, res) => {
    const postId = req.params.id;

    Post.findByIdAndRemove(postId)
        .then((post) => {
            if (!post) {
                console.log(
                    `Cannot delete post with id=${postId}. Post was not found`
                );
                res.status(404).send({
                    message: "Could not find post to delete",
                });
            } else res.send({ message: "Post deleted" });
        })
        .catch((error) => {
            console.log("Failed to delete post=" + postId);
            res.status(500).send({
                message:
                    error.message ||
                    "Failed to delete post. Server Error occurred",
            });
        });
};
