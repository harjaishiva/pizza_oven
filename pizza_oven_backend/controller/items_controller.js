const db = require("../databases/pizza_oven_database");
const asyncHandler = require("express-async-handler");
const { code } = require("../constants");

const getHomeData = asyncHandler(async (req, res) => {
  const [data] = await db.query(
    "SELECT id, name, image, weight, price, is_veg FROM pizza"
  );
  if (data.length <= 0) {
    return res
      .status(code.NotFound)
      .json({ status: 1, message: "Data not found", data: null });
  }

  return res
    .status(code.Success)
    .json({ status: 0, message: "Success", data: data });
});

const getOneItem = asyncHandler(async (req, res) => {
  const userId = req.params.user_id;
  const pizzaId = req.params.pizza_id;

  if (!userId || !pizzaId) {
    return res
      .status(code.Invalid)
      .json({ status: 1, message: "All feilds are mandatory", data: null });
  }

  const [data] = await db.query(
    "SELECT p.*, GROUP_CONCAT(i.name SEPARATOR ',') AS ingredients FROM pizza p JOIN pizza_ingredients pi ON p.id = pi.pizza_id JOIN ingredients i ON pi.ingredients_id = i.id WHERE p.id = ? GROUP BY p.id;",
    [pizzaId]
  );

  if (data.length <= 0) {
    return res
      .status(code.NotFound)
      .json({ status: 1, message: "Data not found", data: null });
  }

  const [isLiked] = await db.query("SELECT u.id,p.id,p.name FROM user u JOIN favourite f ON f.user_id = u.id JOIN pizza p ON p.id = f.pizza_id WHERE u.id = ? AND p.id = ?;",[userId, pizzaId]);

  if(!isLiked.length <= 0){
    data[0]['is_liked'] = 1;
  }

  return res
    .status(code.Success)
    .json({ status: 0, message: "Success", data: data[0]});
});

const updateFavourite = asyncHandler(
  async(req,res) => {
    const userId = req.params.user_id;
    const pizzaId = req.params.pizza_id;

    if(!userId || !pizzaId){
      return res.status(code.Invalid).json({status:1, message:"All feilds are mandatory!"});
    }

    const [exist] = await db.query("SELECT * FROM favourite WHERE user_id = ? AND pizza_id = ?",[userId, pizzaId]);

    if(exist.length <= 0){
      const [addPizza] = await db.query("INSERT INTO favourite VALUES(?,?)",[userId, pizzaId]);
      if(addPizza.affectedRows != 1){
        return res.status(code.ServerError).json({status:1,message: "Unable to add to favourites"});
      }else{
        return res.status(code.Created).json({status:0, message:"Added to favourites"});
      }
    }else{
      const [removePizza] = await db.query("DELETE FROM favourite WHERE user_id = ? AND pizza_id = ?",[userId,pizzaId]);
      if(removePizza.affectedRows != 1){
        return res.status(code.ServerError).json({status:1,message: "Unable to remove from favourites"});
      }else{
        return res.status(code.ResourceAlter).json({status:0, message:"Removed from favourites"});
      }
    }
  }
);


module.exports = { getHomeData, getOneItem, updateFavourite };
