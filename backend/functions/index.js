
const functions = require("firebase-functions");
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendRequestNotification = functions.database.ref('/users/{userID}/requests/{key}')
    .onCreate(async (snapshot, context) => {
        const requestID = snapshot.val();
        const userID = context.params.userID;
        functions.logger.log(requestID, ' has sent a request to ', userID);

        // Get a list of device notification tokens
        const deviceTokensPromise = admin.database()
            .ref(`/userid_tokens_map/${userID}`).once('value');

        // Get the request username
        const requestUsernamePromise = admin.database()
            .ref(`/users/${requestID}/userName`).once('value');

        const results = await Promise.all([deviceTokensPromise, requestUsernamePromise]);

        // Snapshot of the user's tokens and request user's username
        let tokensSnapshot = results[0];
        let requestUsername = results[1].val();
        functions.logger.log('Fetched ', requestUsername);

        if (!tokensSnapshot.hasChildren()) {
            return functions.logger.log('No notification tokens to send to.');
        }

        // Notification
        const notif = {
            notification: {
                title: 'Scribbly',
                body: `${requestUsername} has requested to follow you`
            }
        };

        // Send notification to all tokens
        let tokens = Object.values(tokensSnapshot.val());
        const response = await admin.messaging().sendToDevice(tokens, notif);

        // Clean up tokens that have an error
        const removeTokens = [];
        response.results.forEach((result, index) => {
            const error = result.error;
            if (error) {
                functions.logger.error(
                    'Removing the following token: ',
                    tokens[index],
                    error
                );
                if (error.code == 'messaging/invalid-registration-token' ||
                    error.code === 'messaging/registration-token-not-registered') {
                        removeTokens.push(tokensSnapshot.ref.child(tokens[index]).remove());
                }
            }
        });
    });

exports.likedPostNotification = functions.database.ref('/posts/{postID}/likedUsers/{key}')
    .onCreate(async (snapshot, context) => {
        const likedUserID = snapshot.val();
        const postID = context.params.postID;
        functions.logger.log(likedUserID, ' has liked the post ', postID);

        const postUserIDPromise = admin.database()
            .ref(`/posts/${postID}/user`).once('value');

        const arr  = await Promise.all([postUserIDPromise])
        const postUserID = arr[0].val();
        functions.logger.log('Post user id ', postUserID);

        // Get a list of device notification tokens
        const deviceTokensPromise = admin.database()
            .ref(`/userid_tokens_map/${postUserID}`).once('value');

        // Get the liked user's username
        const likedUsernamePromise = admin.database()
            .ref(`/users/${likedUserID}/userName`).once('value');

        const results = await Promise.all([deviceTokensPromise, likedUsernamePromise]);

        // Snapshot of the post user's tokens and liked user's username
        let tokensSnapshot = results[0];
        let likedUsername = results[1].val();
        functions.logger.log('Like user username ', likedUsername);

        if (!tokensSnapshot.hasChildren()) {
            return functions.logger.log('No notification tokens to send to.');
        }

        // Notification
        const notif = {
            notification: {
                title: 'Scribbly',
                body: `${likedUsername} liked your post`
            }
        };

        // Send notification to all tokens
        let tokens = Object.values(tokensSnapshot.val());
        const response = await admin.messaging().sendToDevice(tokens, notif);

        // Clean up tokens that have an error
        const removeTokens = [];
        response.results.forEach((result, index) => {
            const error = result.error;
            if (error) {
                functions.logger.error(
                    'Removing the following token: ',
                    tokens[index],
                    error
                );
                if (error.code == 'messaging/invalid-registration-token' ||
                    error.code === 'messaging/registration-token-not-registered') {
                        removeTokens.push(tokensSnapshot.ref.child(tokens[index]).remove());
                }
            }
        });
    });

exports.commentPostNotification = functions.database.ref('/posts/{postID}/comments/{key}/user')
    .onCreate(async (snapshot, context) => {
        const commentUserID = snapshot.val();
        const postID = context.params.postID;
        functions.logger.log(commentUserID, ' has commented on the post ', postID);

        const postUserIDPromise = admin.database()
            .ref(`/posts/${postID}/user`).once('value');

        const arr  = await Promise.all([postUserIDPromise]);
        const postUserID = arr[0].val();
        functions.logger.log('Post user id ', postUserID);

        // Get a list of device notification tokens
        const deviceTokensPromise = admin.database()
            .ref(`/userid_tokens_map/${postUserID}`).once('value');

        // Get the comment user's username
        const commentUsernamePromise = admin.database()
            .ref(`/users/${commentUserID}/userName`).once('value');

        const results = await Promise.all([deviceTokensPromise, commentUsernamePromise]);

        // Snapshot of the post user's tokens and comment user's username
        let tokensSnapshot = results[0];
        let commentUsername = results[1].val();
        functions.logger.log('Comment user username ', commentUsername);

        if (!tokensSnapshot.hasChildren()) {
            return functions.logger.log('No notification tokens to send to.');
        }

        // No need to notify if you are commenting on your own post
        if (commentUserID == postUserID) {
            return functions.logger.log('Comment user is the post user.')
        }

        // Notification
        const notif = {
            notification: {
                title: 'Scribbly',
                body: `${commentUsername} commented on your post`
            }
        };

        // Send notification to all tokens
        let tokens = Object.values(tokensSnapshot.val());
        const response = await admin.messaging().sendToDevice(tokens, notif);

        // Clean up tokens that have an error
        const removeTokens = [];
        response.results.forEach((result, index) => {
            const error = result.error;
            if (error) {
                functions.logger.error(
                    'Removing the following token: ',
                    tokens[index],
                    error
                );
                if (error.code == 'messaging/invalid-registration-token' ||
                    error.code === 'messaging/registration-token-not-registered') {
                        removeTokens.push(tokensSnapshot.ref.child(tokens[index]).remove());
                }
            }
        });
    });

exports.replyNotification = functions.database.ref('/posts/{postID}/comments/{commentKey}/replies/{replyKey}')
    .onCreate(async (snapshot, context) => {
        const replyUserID = snapshot.val()['user'];
        const text = snapshot.val()['text'];

        // Get the id of the original user
        const spacePos = text.indexOf(' ');
        const ogUsername = text.substring(1, spacePos);
        const ogUserIDPromise = admin.database()
            .ref(`username_id_map/${ogUsername}`).once('value');
        const arr = await Promise.all([ogUserIDPromise]);
        const ogUserID = arr[0].val();

        functions.logger.log(replyUserID, ' is replying to ', ogUserID);

        // Get a list of device notification tokens
        const deviceTokensPromise = admin.database()
            .ref(`/userid_tokens_map/${ogUserID}`).once('value');

        // Get the reply user's username
        const commentUsernamePromise = admin.database()
            .ref(`/users/${replyUserID}/userName`).once('value');

        const results = await Promise.all([deviceTokensPromise, commentUsernamePromise]);

        // Snapshot of the og user's tokens and reply user's username
        let tokensSnapshot = results[0];
        let replyUsername = results[1].val();
        functions.logger.log('Reply user username ', replyUsername);

        if (!tokensSnapshot.hasChildren()) {
            return functions.logger.log('No notification tokens to send to.');
        }

        // No need to notify if you are replying to yourself
        if (replyUserID == ogUserID) {
            return functions.logger.log('OG user is the reply user.')
        }

        // Notification
        const notif = {
            notification: {
                title: 'Scribbly',
                body: `${replyUsername} replied to your comment`
            }
        };

        // Send notification to all tokens
        let tokens = Object.values(tokensSnapshot.val());
        const response = await admin.messaging().sendToDevice(tokens, notif);

        // Clean up tokens that have an error
        const removeTokens = [];
        response.results.forEach((result, index) => {
            const error = result.error;
            if (error) {
                functions.logger.error(
                    'Removing the following token: ',
                    tokens[index],
                    error
                );
                if (error.code == 'messaging/invalid-registration-token' ||
                    error.code === 'messaging/registration-token-not-registered') {
                        removeTokens.push(tokensSnapshot.ref.child(tokens[index]).remove());
                }
            }
        });
    });

/**
 * Remove the value of todaysPost for every user at 12:00 PM Eastern Time
 */
exports.resetTodaysPost = functions.pubsub.schedule('0 12 * * *').onRun((context) => {
    return admin.database().ref('users').once('value').then((snapshot) => {
        snapshot.forEach((userSnap) => {
            userSnap.ref.update({
                'todaysPost' : ''
            })
            functions.logger.log('todaysPost has been resetted');
        });
    });
});