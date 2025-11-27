const swaggerJsDoc = require('swagger-jsdoc');
require('dotenv').config();

const port = process.env.PORT;

const swaggerOptions = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: "Pizza Oven API's",
      version: "1.0.0",
      description: "API documentation for Pizza Oven backend"
    },
    servers: [
      {
        url: `http://localhost:${port}/api`,
        description: "Local server"
      }
    ],
    components: {
      securitySchemes: {
        bearerAuth: {
          type: 'http',
          scheme: 'bearer',
          bearerFormat: 'JWT'
        }
      }
    },
    security: [
      {
        bearerAuth: []
      }
    ]
  },
  apis: ['./router/*.js'], 
};

const swaggerDocs = swaggerJsDoc(swaggerOptions);

module.exports = swaggerDocs;
