const Gamedig = require('gamedig');
var colors = require('colors');

Gamedig.query({
	    type: 'minecraft',
	    host: 'localhost'
}).then((state) => {
	    var players = state.players;
	    console.log("Server is online".green);
	    console.log("");
	    console.log("There are " + state.raw.players.online + " out of " + state.raw.players.max  + " players online");
	    console.log(players);
}).catch((error) => {
	    console.log("Server is offline".red);
});
