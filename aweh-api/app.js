/**
 * The logic below serves to setup the webserver with Express
 *
 */
//Dependency import
const express = require("express");
const path = require("path");
const bodyP = require("body-parser");
const cors = require("cors");
const passport = require("passport");
const mongoose = require("mongoose");
//const swaggerUI = require("swagger-ui-express");
const users = require("./routes/user-routes");
const config = require("./config/db");

//App Init
const app = express();
const swagger = require("express-swagger-generator")(app);

//Setup swagger options
let options = {
  swaggerDefinition: {
    info: {
      description: "Aweh Back-end Server",
      title: "Aweh API",
      version: "1.0.0",
    },
    host: "localhost:8080",
    basePath: "/v1",
    produces: ["application/json"],
    schemes: ["http", "https"],
    /* securityDefinitions: {
        JWT: {
            type: 'apiKey',
            in: 'header',
            name: 'Authorization',
            description: "",
        }
    } */
  },
  basedir: __dirname, //app absolute path
  files: ["./routes/*.js"], //Path to the API handle folder
};
swagger(options);

app.use(express.static(path.join(__dirname, "public")));
//app.use("/api/docs", swaggerUI.serve, swaggerUI.setup(swaggerDocument));

//DB init
mongoose.connect(config.database);
mongoose.connection.on("connected", () => {
  console.log("Connected to DB: " + config.database);
});
mongoose.connection.on("error", (err) => {
  console.log("Failed to connect to DB: " + err);
});

//Middleware init
app.use(cors());
app.use(bodyP.json());

app.use(passport.initialize());
app.use(passport.session());

require("./config/passport")(passport);

//Routes
app.use("/api/users", users);
app.get("/", (req, res) => {
  res.send("Sorry. Nothing here.");
});

//Start Application Server
const port = process.env.PORT || 8080;
app.listen(port, () => {
  console.log("Server Started: port=" + port);
});
