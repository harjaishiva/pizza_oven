const multer = require("multer");
const path = require('path');

const storage = multer.diskStorage({
    destination: function(req,file,cb){
        cb(null,path.join(process.cwd(),'images'));
    },

    filename: function(req,file,cb){
        const uname = Date.now()+'-'+file.originalname;
        cb(null,uname);
    }
});

const upload = multer({storage: storage});

module.exports = upload;