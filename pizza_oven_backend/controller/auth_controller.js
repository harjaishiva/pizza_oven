const db = require('../databases/pizza_oven_database');
const asyncHandler = require('express-async-handler');
const bcrypt = require('bcrypt');
const {code} = require('../constants');
const jwt = require('jsonwebtoken');
const methods = require('../methods');
require('dotenv').config();

const signUp = asyncHandler(
    async(req,res)=>{
        const { name, email, password } = req.body;

        if(!name || !email || !password){
            return res.status(code.Invalid).json({status: 1,message:"All feilds are mandatory!"});
        }

        let [alreadyExist] = await db.query('SELECT * FROM user WHERE email = ?',[email]);

        if(alreadyExist.length > 0){
            return res.status(code.AlredyExists).json({status: 1,message:"User already exists"});
        }

        const hash = await bcrypt.hash(password,10);

        const [result] = await db.query("INSERT INTO user(name, email, password, hash_password) Values(?,?,?,?)",[name,email,password,hash]);

        if(result.affectedRows > 0){
            return res.status(code.Created).json({status: 0,message:"registered"});
        }
        else{
            return res.status(code.ServerError).json({status: 1,message:"Internal Server Error"});
        }
    }
);

const signIn = asyncHandler(
    async(req,res)=>{
        const { email, password } = req.body;

        if(!email || !password){
            return res.status(code.Invalid).json({status: 1,message:"All feilds are mandatory!",token:"", userId:"",image:""});
        }

        const [isUser] = await db.query("SELECT * FROM user WHERE email = ?",[email]);

        if(isUser.length > 0){
            const hashPass = isUser[0]['hash_password'];
            const ispassword = await bcrypt.compare(password, hashPass);
            if(ispassword){
                const secretKey = process.env.SECRET_KEY;
                let name = isUser[0]['name'];
                const payLoad = {name, email};
                const token = jwt.sign(payLoad,secretKey,{expiresIn:"24h"});
                return res.status(code.Success).json({status: 0,message:"Logged in successfully",token:token,userId:isUser[0]['id'],image:isUser[0]['image']});
            }
            else{
                return res.status(code.Unaccessible).json({status: 1,message:"Password does not match",token:"",userId:"",image:""});
            }
        }
        else{
            return res.status(code.NotFound).json({status: 1,message:"User does not exist",token:"", userId:"",image:""});
        }
    }
);

const getOtp = asyncHandler(
    async(req,res)=>{
        const { email } = req.body;

        if(!email){
            return res.status(code.Invalid).json({status:1,message:"All feilds are mandatory",otpId:""});
        }

        const [isUser] = await db.query("SELECT * FROM user WHERE email = ?",[email]);

        if(isUser.length <= 0){
            return res.status(code.NotFound).json({status: 1, message: "User does not exist",otpId: ""});
        }
        
        const otp = methods.generateotp();
        const otpId = methods.generateotp();

        try{
            

        const mailOptions = {
            from: "harjaishivam03@gmail.com",
            to: email,
            subject: "OTP for user verification",
            text: `Your OTP for verification is : ${otp}`
        };

        methods.transporter.sendMail(mailOptions);

        const inserted = await db.query("INSERT INTO otp(email_id,otp,otp_id) VALUES(?,?,?) ON DUPLICATE KEY UPDATE otp = ?, otp_id = ?",[email,otp,otpId,otp,otpId]);

        return res.status(code.Success).json({status:0,message:"OTP sent successfully",otpId: otpId});
        }catch(err){
            return res.status(code.Invalid).json({status:1,message:"OTP request failed",otpId: ""})
        }
    }
);

const verifyOtp = asyncHandler(
    async(req,res)=>{
        const {email,otpId,otp} = req.body;

        if(!email || !otpId || !otp){
            return res.status(code.Invalid).json({status:1, message:"All feilds are mandatory"});
        }

        const [isUser] = await db.query("SELECT * FROM user WHERE email = ?",[email]);      
        
        if(isUser.length > 0){
            const [otpDet] = await db.query("SELECT * FROM otp WHERE otp_id = ? AND email_id = ?",[otpId,email]);
            if(otpDet.length > 0){
                if(otpDet[0]['otp'] == otp){
                    return res.status(code.Success).json({status:0,message:"OTP verified"});
                }
                else{
                    return res.status(code.Invalid).json({status:1,message:"OTP does not match"});
                }
            }
            else{
                return res.status(code.Invalid).json({status:1,message:"Invalid request"});
            }
        }
        else{
            return res.status(code.NotFound).json({status:1,message:"User not found"});
        }
    }
);

const verifyUser = asyncHandler(
    async(req,res)=>{

        const { email, oldPassword} = req.body;

        if(!email){
            return res.status(code.Invalid).json({status:1,message:"Email is mandatory"});
        }

        let [isUser] = await db.query("SELECT * FROM user WHERE email = ?",[email]);
        if(!oldPassword){
            if(isUser.length > 0){
                return res.status(code.Success).json({status:0,message:"User exists and verified"});
            }
            else{
                return res.status(code.NotFound).json({status:0,message:"User does not exist"});
            }
        }
        else{
            if(isUser.length <= 0){
                return res.status(code.NotFound).json({status:0,message:"User does not exist"});
            }
            const dbPassword = isUser[0]['hash_password'];
            const matched = await bcrypt.compare(oldPassword,dbPassword);
            if(matched){
                return res.status(code.Success).json({status:0,message:"User exists and verified"});
            }
            else{
                return res.status(code.NotFound).json({status:0,message:"Password does not match"});
            }
        }
    }
);

const updatePassword = asyncHandler(
    async(req,res)=>{
        const{email, newPassword} = req.body;

        if(!email || !newPassword){
            return res.status(code.Invalid).json({status:1,message:"All feilds are mandatory"});
        }

        const [isUser] = await db.query("SELECT * FROM user WHERE email = ?",[email]);

        if(isUser.length <= 0){
            return res.status(code.NotFound).json({status:1,message:"User deos not exist"});
        }

        const newHash = await bcrypt.hash(newPassword,10);

        let updated = db.query("UPDATE user SET password = ?, hash_password = ? WHERE email = ?",[newPassword, newHash,email]);

        return res.status(code.ResourceAlter).json({status:0, message:"Password is updated"});
    }
);

const verifyToken = asyncHandler(
    async(req,res)=>{
        return res.status(code.Success).json({status:0, message:"Token verified"});
    }
);

module.exports = {signUp, signIn, getOtp, verifyOtp, verifyUser, updatePassword, verifyToken};