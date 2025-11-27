const db = require("../databases/pizza_oven_database");
const { code } = require("../constants");
const asyncHandler = require("express-async-handler");
const fs = require("fs");
const path = require("path");

const getProfile = asyncHandler(
  async(req,res)=>{
    const userid = req.params.id;

    if(!userid){
      return res.status(code.Invalid).json({status:1, message:"User id is mandatory!",data:null});
    }

    const [isUser] = await db.query("SELECT u.id AS user_id,u.name,u.email,u.password,u.phone_number,a.id AS address_id,a.address_name,a.house_no,a.building_no,a.locality,a.district,a.state,a.landmark FROM user u JOIN address a ON a.user_id = u.id WHERE u.id = ?;",[userid]);

    if(isUser.length <= 0){
      return res.status(code.NotFound).json({status:1, message:"User not found",data:null});
    }

    const user = {
      userId: isUser[0].user_id,
      name: isUser[0].name,
      email: isUser[0].email,
      password: isUser[0].password,
      phoneNumber: isUser[0].phone_number
    }

    const addresses = isUser[0].address_id ?
    isUser.map(rows=>({
      addId : rows.address_id,
      addName : rows.address_name,
      houseNo : rows.house_no,
      buildingNo : rows.building_no,
      locality : rows.locality,
      district : rows.district,
      state : rows.state,
      landmark : rows.landmark
    })) : [];

    return res.status(code.Success).json({status:0, message:"Success",data:{user,addresses}});
  }
);

const editProfile = asyncHandler(async (req, res) => {
  const { userId, name, email, phoneNo } = req.body;

  if (!userId) {
    return res
      .status(code.Invalid)
      .json({ status: 1, message: "userId is mandatory" });
  }

  const [isUser] = await db.query("SELECT * FROM user WHERE id = ?",[userId]);

  if(isUser.length == 0){
    return res.status(code.NotFound).json({status:1, message: "User not found"});
  }
  const update = {};
  if (name) {
    update.name = name;
  }
  if (email) {
    update.email = email;
  }
  if (phoneNo) {
    update.phone_number = phoneNo;
  }

  if (Object.keys(update).length == 0) {
    return res
      .status(code.Invalid)
      .json({ status: 1, message: "No feilds provided to update" });
  }

  const feilds = Object.keys(update)
    .map((key) => `${key} = ?`)
    .join(", ");
  const values = Object.values(update);

  const query = `UPDATE user SET ${feilds} WHERE id = ?`;

  const isUpdated = await db.query(query, [...values, userId]);

  if (isUpdated) {
    return res
      .status(code.ResourceAlter)
      .json({ status: 0, message: "Profile updated successfully" });
  } else {
    return res
      .status(code.ServerError)
      .json({ status: 1, message: "Internal Server Error" });
  }
});

const imageUpload = asyncHandler(async (req, res) => {
  const file = req.file;
  const id = req.params.id;

  if (!file || !id) {
    return res
      .status(code.Invalid)
      .json({ status: 1, message: "All feilds are mandatory", imagePath: "" });
  }

  const [isUser] = await db.query("SELECT * FROM user WHERE id = ?", [id]);
  if (isUser.length == 0) {
    return res
      .status(code.NotFound)
      .json({ status: 1, message: "User not found", imagePath: "" });
  }

  const filePath = `/images/${file.filename}`;

  const updateImage = await db.query("UPDATE user SET image = ? WHERE id = ?", [
    filePath,
    id,
  ]);

  const imagePath = path.join(__dirname, "../images/", file.filename);

  if (fs.existsSync(imagePath)) {
    if (updateImage[0].affectedRows != 1) {
      return res.status(code.ServerError).json({
        status: 1,
        message: "Unbale to upload Image",
        imagePath: "",
      });
    } else {
      return res.status(code.Success).json({
        status: 0,
        message: "Image uploaded successfully",
        imagePath: `https://97jfzdmz-3000.inc1.devtunnels.ms/${filePath}`,
      });
    }
  } else {
    return res
      .status(code.ServerError)
      .json({ message: "Internal server error", imagePath: "" });
  }
});

const addAddress = asyncHandler(async (req, res) => {
  let {
    userId,
    addName,
    houseNo,
    buildingNo,
    locality,
    district,
    state,
    landmark,
  } = req.body;

  const required = { userId, addName, houseNo, locality, district, state };

  const missing = [];

  for (let key in required) {
    if (!required[key]) {
      missing.push(key);
    }
  }

  if (missing.length > 0) {
    return res
      .status(code.Invalid)
      .json({
        status: 1,
        message: "Mandatory feilds are missing",
        feilds: missing,
      });
  }

  if (!buildingNo) {
    buildingNo = null;
  }
  if (!landmark) {
    landmark = null;
  }

  const [isUser] = await db.query("SELECT * FROM user WHERE id = ?", [userId]);

  if (isUser.length == 0) {
    return res
      .status(code.NotFound)
      .json({ status: 1, message: "user not found" });
  }

  const addressInserted = await db.query(
    "INSERT INTO address(user_id, address_name, house_no, building_no, locality, district, state, landmark) VALUES(?,?,?,?,?,?,?,?)",
    [userId, addName, houseNo, buildingNo, locality, district, state, landmark]
  );

  if (addressInserted[0].affectedRows != 1) {
    return res
      .status(code.ServerError)
      .json({ status: 1, message: "Unable to insert the address" });
  }

  return res
    .status(code.Created)
    .json({ status: 0, message: "New address is added" });
});

const deleteAddress = asyncHandler(async (req, res) => {
  const { userId, addId, addName } = req.body;

  if (!userId || !addId || !addName) {
    return res
      .status(code.Invalid)
      .json({ status: 1, message: "All feilds are mandatory" });
  }

  const [isAddress] = await db.query(
    "SELECT * FROM address WHERE user_id = ? AND id = ? AND address_name = ?",
    [userId, addId, addName]
  );

  if (isAddress.length == 0) {
    return res
      .status(code.NotFound)
      .json({ status: 1, message: "Respective address does not exist" });
  }

  const isDeleted = await db.query(
    "DELETE FROM address WHERE user_id = ? AND id = ? AND address_name = ?",
    [userId, addId, addName]
  );

  if (isDeleted[0].affectedRows != 1) {
    return res
      .status(code.ServerError)
      .json({ status: 1, message: "Unable to delete the address" });
  } else {
    return res
      .status(code.ResourceAlter)
      .json({ status: 0, message: "Address removed successfully" });
  }
});

const updateAddress = asyncHandler(async (req, res) => {
  let {
    userId,
    addId,
    addName,
    houseNo,
    buildingNo,
    locality,
    district,
    state,
    landmark,
  } = req.body;

  if (!userId || !addId) {
    return res
      .status(code.Invalid)
      .json({ status: 1, message: "All feilds are mandatory" });
  }

  const feilds = {
    addName,
    houseNo,
    buildingNo,
    locality,
    district,
    state,
    landmark,
  };

  const hasValue = [];

  for (let key in feilds) {
    if (feilds[key]) {
      hasValue.push(key);
    }
  }

  if ((hasValue.length = 0)) {
    return res
      .status(code.Invalid)
      .json({ status: 1, message: "No feild to update" });
  }

  const [isAddress] = await db.query(
    "SELECT * FROM address WHERE user_id = ? AND id = ?",
    [userId, addId]
  );

  if (isAddress.length == 0) {
    return res
      .status(code.NotFound)
      .json({ status: 1, message: "address not found" });
  }

  const addressUpdated = await db.query(
    "Update address SET address_name = ?, house_no = ?, building_no = ?, locality = ?, district = ?, state = ?, landmark = ? WHERE user_id = ? AND id = ?",
    [
      addName,
      houseNo,
      buildingNo,
      locality,
      district,
      state,
      landmark,
      userId,
      addId,
    ]
  );

  if (addressUpdated[0].affectedRows != 1) {
    return res
      .status(code.ServerError)
      .json({ status: 1, message: "Unable to update the address" });
  }

  return res
    .status(code.ResourceAlter)
    .json({ status: 0, message: "The address is update" });
});

const getAddress = asyncHandler(
  async(req,res)=>{
    const userId = req.params.id;

    if(!userId){
      return res.status(code.Invalid).json({status:1, message:"UserId is mandatory"});
    }

    const [getAddress] = await db.query("SELECT * FROM address WHERE user_id = ?",[userId]);

    if(getAddress.length <= 0){
      return res.status(code.NotFound).json({status:1, message:"No address found"});
    }

    return res.status(code.Success).json({status:0, message:"Success", addresses : getAddress})
  }
);

module.exports = {
  getProfile,
  editProfile,
  imageUpload,
  addAddress,
  deleteAddress,
  updateAddress,
  getAddress
};
