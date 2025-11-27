const express = require('express');
const cont = require('../controller/cart_controller');
const router = express.Router();
const verifyUser = require('../middlewares/token_verification');


/** 
 * @swagger
 * tags:
 *  - name: Cart
 *    description: An application api's
*/

/**
 * @swagger
 * /cart/add_to_cart:
 *   post:
 *     summary: adding to the cart
 *     tags: [Cart]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               user_id:
 *                 type: integer
 *               pizza_id:
 *                 type: integer
 *               size:
 *                 type: string
 *               quantity:
 *                 type: integer
 *     responses:
 *        200:
 *          description: Added to the cart
 *        204:
 *          description: Updated order already in cart
 *        400:
 *          description: Invalid or missing feilds
 *        500:
 *          description: Internal server Error
 */
router.route("/add_to_cart").post(verifyUser,cont.addToCart);

/**
 * @swagger
 * /cart/get_cart/{id}:
 *   get:
 *     summary: Get items in the cart
 *     tags: [Cart]
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: integer
 *         required: true
 *         description: ID of the item
 *     responses:
 *       200:
 *         description: Success
 *       400:
 *         description: Invalid or missing fields
 *       404:
 *         description: Item not found
 */

router.route("/get_cart/:id").get(verifyUser,cont.getCart);

/**
 * @swagger
 * /cart/delete_from_cart:
 *   delete:
 *     summary: removing item from cart
 *     tags: [Cart]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               cart_id:
 *                 type: integer
 *               user_id:
 *                 type: integer
 *               pizza_id:
 *                 type: integer
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
router.route("/delete_from_cart").delete(verifyUser,cont.deleteFromCart);

/**
 * @swagger
 * /cart/update_quantity:
 *   put:
 *     summary: updating quanityt in cart of respective pizza
 *     tags: [Cart]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               userId:
 *                 type: string
 *               pizzaId:
 *                 type: string
 *               quantity:
 *                 type: string
 *     responses:
 *        204:
 *          description: successfully updated the quantity
 *        400:
 *          description: Invalid or missing feilds
 *        409:
 *          description: User already exists
 *        500:
 *          description: Internal server error
 */
router.route("/update_quantity").put(verifyUser,cont.updateQuantity);

module.exports = router;