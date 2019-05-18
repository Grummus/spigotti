const Gamedig = require('gamedig');
var colors = require('colors');


Gamedig.query({
    type: 'minecraft',
    host: 'localhost'
}).then((state) => { 
	var info = state;
	var players = state.players;

	console.log('There are', players.length, 'out of', state.raw.players.max, 'players online!');
	for(let i = 0, len = players.length; i < len; i++) {
 		console.log(players[i].name);
	}
	
	
}).catch((error) => {
    console.log("Server is offline");
});





// 
