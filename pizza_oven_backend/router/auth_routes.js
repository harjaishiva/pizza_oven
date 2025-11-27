const express = require('express');
const cont = require('../controller/auth_controller');
const router = express.Router();
const verifyUser = require('../middlewares/token_verification');


/** 
 * @swagger
 * tags:
 *  - name: Auth
 *    description: An application api's
*/

/**
 * @swagger
 * /auth/sign_up:
 *   post:
 *     summary: Signing up a new user
 *     tags: [Auth]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *               email:
 *                 type: string
 *               password:
 *                 type: string
 *     responses:
 *        201:
 *          description: A new user is created
 *        400:
 *          description: Invalid or missing feilds
 *        409:
 *          description: User already exists
 *        500:
 *          description: Internal server error
 */
router.route("/sign_up").post(cont.signUp);

/**
 * @swagger
 * /auth/sign_in:
 *   post:
 *     summary: Signing in a user
 *     tags: [Auth]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               email:
 *                 type: string
 *               password:
 *                 type: string
 *     responses:
 *        200:
 *          description: Successfull signing in
 *        400:
 *          description: Invalid or missing feilds
 *        403:
 *          description: Password id inavlid
 *        404:
 *          description: User not found
 *        500:
 *          description: Internal server error
 */
router.route("/sign_in").post(cont.signIn);

/**
 * @swagger
 * /auth/get_otp:
 *   post:
 *     summary: for requesting otp
 *     tags: [Auth]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               email:
 *                 type: string
 *     responses:
 *        200:
 *          description: success
 *        400:
 *          description: Invalid or missing feilds
 *        404:
 *          description: User not found
 *        500:
 *          description: Internal server error
 */
router.route("/get_otp").post(verifyUser,cont.getOtp);

/**
 * @swagger
 * /auth/verify_otp:
 *   post:
 *     summary: verification of otp
 *     tags: [Auth]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               email:
 *                 type: string
 *               otpId:
 *                 type: string
 *               otp:
 *                 type: string
 *     responses:
 *        200:
 *          description: success
 *        400:
 *          description: Invalid or missing feilds
 *        404:
 *          description: User not found
 *        500:
 *          description: Internal server error
 */
router.route("/verify_otp").post(verifyUser,cont.verifyOtp);

/**
 * @swagger
 * /auth/verify_user:
 *   post:
 *     summary: verification of user
 *     tags: [Auth]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - email
 *             properties:
 *               email:
 *                 type: string
 *               oldPassword:
 *                 type: string
 *     responses:
 *        200:
 *          description: success
 *        400:
 *          description: Invalid or missing feilds
 *        404:
 *          description: User not found
 *        500:
 *          description: Internal server error
 */
router.route("/verify_user").post(verifyUser,cont.verifyUser);

/**
 * @swagger
 * /auth/update_password:
 *   put:
 *     summary: updating the password
 *     tags: [Auth]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               email:
 *                 type: string
 *               newPassword:
 *                 type: string
 *     responses:
 *        204:
 *          description: Successfully updated the password
 *        400:
 *          description: Invalid or missing feilds
 *        404:
 *          description: User not found
 *        500:
 *          description: Internal server error
 */
router.route("/update_password").put(verifyUser,cont.updatePassword);

/**
 * @swagger
 * /auth/verify_token:
 *   post:
 *     summary: verification of token
 *     tags: [Auth]
 *     responses:
 *        200:
 *          description: success
 *        400:
 *          description: Invalid or missing feilds
 *        404:
 *          description: User not found
 *        500:
 *          description: Internal server error
 */
router.route("/verify_token").post(verifyUser, cont.verifyToken);

module.exports = router;