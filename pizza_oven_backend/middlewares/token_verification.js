const jwt = require("jsonwebtoken");
const {code} = require('../constants');
require('dotenv').config();

const verifYToken = (req,res,next)=>{
    const authHeader = req.headers.authorization;

    if(!authHeader || !authHeader.startsWith('Bearer ')){
        return res.status(code.Unauthorised).json({status: 1,message:"Token not found"});
    }

    const token = authHeader.split(" ")[1];

    try{
        const secretKey = process.env.SECRET_KEY;
        const verify = jwt.verify(token, secretKey);
        req.user = verify;
        next();
     }catch(err){
        console.log(`Token verification error : ${err}`);
        switch(err){
            case "TokenExpiredError":{
                return res.status(code.Unauthorised).json({status:1,message:"Token is expired"});
            }
            case "JsonWebTokenError":{
                return res.status(code.Unauthorised).json({status:1,message:"Invalid token"});
            }
            default:{
                return res.status(code.ServerError).json({status:1, message:"Token verification failed"});
            }
        }
     }
}

module.exports = verifYToken;