const db = require("../databases/pizza_oven_database");
const asyncHandler = require("express-async-handler");
const { code } = require("../constants");

const addToCart = asyncHandler(async (req, res) => {
  const { user_id, pizza_id, size, quantity } = req.body;

  if (!user_id || !pizza_id || !size || !quantity) {
    return res
      .status(code.Invalid)
      .json({ status: 1, message: "All feilds are mandatory" });
  }

  const [isPizza] = await db.query("SELECT * FROM cart WHERE user_id = ? AND pizza_id = ?",[user_id, pizza_id]);

  if(isPizza.length <= 0){
    const [add] = await db.query(
    "INSERT INTO cart(user_id, pizza_id, size, quantity) VALUES(?,?,?,?)",
    [user_id, pizza_id, size, quantity]
  );

  if (add.affectedRows != 1) {
    return res
      .status(code.Invalid)
      .json({ status: 1, message: "Could not add to the cart" });
  }

  return res
    .status(code.Success)
    .json({ status: 0, message: "Added to the cart" });
  }

  else{
    const [updatePizza] = await db.query("UPDATE cart SET size = ?, quantity = ? WHERE user_id = ? AND pizza_id = ?",[size, quantity, user_id, pizza_id]);

    if(updatePizza.affectedRows != 1){
      return res.status(code.ServerError).json({status:1, message:"Unable to update the order already in cart"});
    }
    else{
      return res.status(code.ResourceAlter).json({status:0,message:"Updated pre existing order"});
    }
  }

});

const getCart = asyncHandler(async (req, res) => {
  const id = req.params.id;

  if (!id) {
    return res
      .status(code.Invalid)
      .json({ status: 1, message: "All feilds are mandatory", data: null });
  }

  const [data] = await db.query(
    "SELECT c.id as cart_id, p.id as pizza_id, p.name, p.image,c.size,p.price, c.quantity FROM  pizza p JOIN cart c ON p.id = c.pizza_id WHERE c.user_id = ?;",
    [id]
  );

  if (data.length <= 0) {
    return res
      .status(code.NotFound)
      .json({ status: 1, message: "No data found", data: null });
  }

  let price = [];
  let totalPrice = [];
  let resdata = [];
  for (let i = 0; i < data.length; i++) {
    price[i] =
      data[i]["size"] == "S"
        ? data[i]["price"] - 20
        : data[i]["size"] == "L"
        ? data[i]["price"] + 20
        : data[i]["price"];
    totalPrice[i] = data[i]["quantity"] * price[i];

    resdata[i] = {
        cart_id: data[i]["cart_id"],
      pizza_id: data[i]["pizza_id"],
      name: data[i]["name"],
      image: data[i]["image"],
      size: data[i]["size"],
      price: price[i],
      quantity: data[i]["quantity"],
      totalPrice: totalPrice[i],
    };
  }

  return res
    .status(code.Success)
    .json({ status: 0, message: "success", data: resdata });
});

const deleteFromCart = asyncHandler(async (req, res) => {
  const { cart_id, user_id, pizza_id } = req.body;

  if (!cart_id || !user_id || !pizza_id) {
    return res
      .status(code.Invalid)
      .json({ status: 1, message: "All feilds are mandatory" });
  }

  const [itemExist] = await db.query(
    "SELECT * FROM cart WHERE id = ? AND user_id = ? AND pizza_id = ?",
    [cart_id, user_id, pizza_id]
  );

  if (itemExist.length <= 0) {
    return res
      .status(code.NotFound)
      .json({ status: 1, message: "Item does not exist in cart" });
  }

  const deleted = await db.query("DELETE FROM cart WHERE id = ?", [cart_id]);

  if (deleted[0].affectedRows != 1) {
    return res
      .status(code.ServerError)
      .json({ status: 1, message: "Unable to delete, Internal server error." });
  } else {
    return res
      .status(code.ResourceAlter)
      .json({ status: 0, message: "Ite,m removed from cart" });
  }
});

const updateQuantity = asyncHandler(async (req, res) => {
  const { userId, pizzaId, quantity } = req.body;

  if (!userId || !pizzaId || !quantity) {
    return res
      .status(code.Invalid)
      .json({ status: 1, message: "All feilds are mandatory!" });
  }

  const [inCart] = await db.query(
    "SELECT * FROM cart WHERE user_id = ? AND pizza_id = ?",
    [userId, pizzaId]
  );

  if (inCart.length <= 0) {
    return res
      .status(code.NotFound)
      .json({ Status: 1, message: "Order not found in cart" });
  }

  const updateQuantity = await db.query(
    "UPDATE cart SET quantity = ? WHERE user_id = ? AND pizza_id = ? ",
    [quantity, userId, pizzaId]
  );

  if (updateQuantity[0].affectedRows != 1) {
    return res
      .status(code.ServerError)
      .json({ status: 1, message: "Unable to update the quantity" });
  }

  return res.status(code.ResourceAlter).json({ status: 0, message: "success" });
});

module.exports = { addToCart, getCart, deleteFromCart, updateQuantity };
