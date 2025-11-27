const express = require('express');
const cont = require('../controller/items_controller');
const router = express.Router();
const verifyUser = require('../middlewares/token_verification');

/** 
 * @swagger
 * tags:
 *  - name: Items
 *    description: An application api's
*/

/**
 * @swagger
 * /item/get_home_data:
 *   get:
 *     summary: getting data for home screen
 *     tags: [Items]
 *     responses:
 *        200:
 *          description: success
 *        404:
 *          description: data not found
 */
router.route("/get_home_data").get(verifyUser,cont.getHomeData);

/**
 * @swagger
 * /item/get_one_item/{user_id}/{pizza_id}:
 *   get:
 *     summary: Get single item's data
 *     tags: [Items]
 *     parameters:
 *       - in: path
 *         name: user_id
 *         schema:
 *           type: integer
 *         required: true
 *         description: ID of the user
 * 
 *       - in: path
 *         name: pizza_id
 *         schema:
 *           type: integer
 *         required: true
 *         description: ID of the pizza
 *     responses:
 *       200:
 *         description: Success
 *       400:
 *         description: Invalid or missing fields
 *       404:
 *         description: Item not found
 */

router.route("/get_one_item/:user_id/:pizza_id").get(verifyUser,cont.getOneItem);

/**
 * @swagger
 * /item/update_favourite/{user_id}/{pizza_id}:
 *   put:
 *     summary: adding pizza to or removing pizza from favourites
 *     tags: [Items]
 *     parameters:
 *       - in: path
 *         name: user_id
 *         schema:
 *           type: integer
 *         required: true
 *         description: ID of the user
 * 
 *       - in: path
 *         name: pizza_id
 *         schema:
 *           type: integer
 *         required: true
 *         description: ID of the pizza
 *     responses:
 *       201:
 *         description: Successfully added
 *       204:
 *         description: Successfully removed
 *       400:
 *         description: Invalid or missing fields
 *       500:
 *         description: Internal server error
 */

router.route("/update_favourite/:user_id/:pizza_id").put(verifyUser,cont.updateFavourite);

module.exports = router;