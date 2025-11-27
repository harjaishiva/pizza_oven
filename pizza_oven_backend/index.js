const express = require('express');
const swaggerDocs = require('./swagger');
const swaggerUi = require('swagger-ui-express');
require('dotenv').config();

const app = express();
const port = process.env.PORT;

app.use(express.json());

app.use('/api_docs',swaggerUi.serve, swaggerUi.setup(swaggerDocs));
app.use('/images',express.static("images"));
app.use("/api/auth",require('./router/auth_routes'));
app.use("/api/item",require('./router/item_routes'));
app.use("/api/cart",require('./router/cart_routes'));
app.use("/api/profile",require('./router/profile_routes'));
app.listen(port,(err)=>{
    if(err){
        console.log(`ERROR IN SERVER : ${err}`);
    }
    else{
        console.log(`Server is running at : https://localhost:${port}`);
        console.log(`Swagger Url : http://localhost:${port}/api_docs`);
    }
})