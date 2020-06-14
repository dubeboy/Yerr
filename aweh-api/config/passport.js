const JwtStrat = require('passport-jwt').Strategy;
const JwtExtract = require('passport-jwt').ExtractJwt;
const User = require('../models/User');
const Database = require('../config/db');

module.exports = function(passport){
    let options = {};
    options.jwtFromRequest = JwtExtract.fromAuthHeaderWithScheme("JWT");
    options.secretOrKey  = Database.secret;
    passport.use(new JwtStrat(options, (jwt_payload, done) =>{
        User.getUserById(jwt_payload._id, (err,user)=>{
            if(err){
                return done(err,false);
            }
            else if(user){
                return done(null,user);
            }
            else{
                return done(null,false);
            }
        });
    }));
}