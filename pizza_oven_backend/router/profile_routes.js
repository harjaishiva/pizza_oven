const express = require('express');
const router = express.Router();
const cont = require('../controller/profile_controller');
const upload = require('../middlewares/image_upload');
const verifyUser = require('../middlewares/token_verification');

/** 
 * @swagger
 * tags:
 *  - name: Profile
 *    description: An application api's
*/


/**
 * @swagger
 * /profile/get_profile/{id}:
 *   get:
 *     summary: getting user all details
 *     tags: [Profile]
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: integer
 *         required: true
 *         description: ID of the user
 *     responses:
 *        200:
 *          description: success
 *        400:
 *          description: User id is neccessary
 *        404:
 *          description: data not found
 */
router.route("/get_profile/:id").get(verifyUser,cont.getProfile);


/**
 * @swagger
 * /profile/edit_profile:
 *   put:
 *     summary: updating the profile
 *     tags: [Profile]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               userId:
 *                 type: string
 *                 required: true
 *               name:
 *                 type: string
 *                 required: false
 *               email:
 *                 type: string
 *                 required: false
 *               phoneNo:
 *                 type: string
 *                 required: false
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
router.route("/edit_profile").put(verifyUser,cont.editProfile);

/**
 * @swagger
 * /profile/image_upload/{id}:
 *    post:
 *      summary: For uploading image of user
 *      tags: [Profile]
 *      parameters:
 *        - in: path
 *          name: id
 *          schema:
 *            type: integer
 *          required: true
 *      requestBody:
 *        required: true
 *        content:
 *          multipart/form-data:
 *            schema:
 *              type: object
 *              properties:
 *                image:
 *                  type: string
 *                  format: binary
 *      responses:
 *        204:
 *          description: uploaded successfully
 *        400:
 *          description: Missing or Invalid parameters
 *        404:
 *          description: User not found
 *        500:
 *          description: Internal server error
 */
router.route("/image_upload/:id").post(verifyUser,upload.single('image'),cont.imageUpload);

/**
 * @swagger
 * /profile/add_address:
 *   post:
 *     summary: adding new address
 *     tags: [Profile]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               userId:
 *                 type: string
 *                 required: true
 *               addName:
 *                 type: string
 *                 required: true
 *               houseNo:
 *                 type: string
 *                 required: true
 *               buildingNo:
 *                 type: string
 *                 required: false
 *               locality:
 *                 type: string
 *                 required: true
 *               district:
 *                 type: string
 *                 required: true
 *               state:
 *                 type: string
 *                 required: true
 *               landmark:
 *                 type: string
 *                 required: false
 *     responses:
 *        201:
 *          description: Added new address
 *        400:
 *          description: Invalid or missing feilds
 *        404:
 *          description: Not Found
 *        500:
 *          description: Internal Server Error
 */
router.route("/add_address").post(verifyUser,cont.addAddress);

/**
 * @swagger
 * /profile/delete_address:
 *   delete:
 *     summary: removing address
 *     tags: [Profile]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               userId:
 *                 type: integer
 *               addId:
 *                 type: integer
 *               addName:
 *                 type: string
 *     responses:
 *        204:
 *          description: Successfully removed from the cart
 *        400:
 *          description: Invalid or missing feilds
 *        404:
 *          description: User not found
 *        500:
 *          description: Internal server error
 */
router.route("/delete_address").delete(verifyUser,cont.deleteAddress);

/**
 * @swagger
 * /profile/update_address:
 *   put:
 *     summary: updating the address
 *     tags: [Profile]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               userId:
 *                 type: string
 *                 required: true
 *               addId:
 *                 type: string
 *                 required: true
 *               addName:
 *                 type: string
 *                 required: false
 *               houseNo:
 *                 type: string
 *                 required: false
 *               buildingNo:
 *                 type: string
 *                 required: false
 *               locality:
 *                 type: string
 *                 required: false
 *               district:
 *                 type: string
 *                 required: false
 *               state:
 *                 type: string
 *                 required: false
 *               landmark:
 *                 type: string
 *                 required: false
 *     responses:
 *        204:
 *          description: Successfully updated the address
 *        400:
 *          description: Invalid or missing feilds
 *        404:
 *          description: User not found
 *        500:
 *          description: Internal server error
 */
router.route("/update_address").put(verifyUser,cont.updateAddress);

/**
 * @swagger
 * /profile/get_address/{id}:
 *   get:
 *     summary: getting all the addresses for respective user
 *     tags: [Profile]
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: integer
 *         required: true
 *         description: ID of the user
 *     responses:
 *        200:
 *          description: success
 *        400:
 *          description: User id is neccessary
 *        404:
 *          description: data not found
 */
router.route("/get_address/:id").get(verifyUser,cont.getAddress);

module.exports = router;
