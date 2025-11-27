const nodemailer = require('nodemailer');

const transporter = nodemailer.createTransport({
    service: "gmail",
    auth:{
        user:"harjaishivam03@gmail.com",
        pass:"tuiw mcri tsph vkyh"
    }
});

function generateotp (){
    return Math.floor(1000 + Math.random() * 9000).toString();
}

module.exports = {transporter, generateotp};