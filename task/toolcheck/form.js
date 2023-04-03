const { Telegraf } = require('telegraf');
const axios = require('axios').default;
const icon = require('node-emoji')

const bot = new Telegraf('56206xxxxxxxxxxxxxxxxxxxxxx1jDFY1O27Y4Tmp4');

var instance = "";
var denom = "";
var chainid = "";

// Define supported chains
const inlineKeyboardChainsCommands = {
    inline_keyboard: [
        [
	 	{ text: "LIGHT", callback_data: 'light' },
    { text: "BRIDGE", callback_data: 'bridge' },		
        ]
    ]
};

async function myCLI(ctx) {
    var msg = `
     ${icon.get('zap')} <b> Go to CLI command help </b> ${icon.get('zap')}

${icon.get('round_pushpin')} <b>It's so easy to use</b>
${icon.get('small_blue_diamond')} Commands about wallet: /wallet
${icon.get('small_blue_diamond')} Commands about status: /status
${icon.get('small_blue_diamond')} Commands about node id: /nodeid
${icon.get('small_blue_diamond')} Commands about Useful links: /links
`;
    bot.telegram.sendMessage(ctx.chat.id, msg, {parse_mode: 'html'});
};




bot.command('start', ctx => {
	instance = "";
  	denom = "";
	chainid = "";
	myCLI(ctx);	
	let msg = 'Please choose one of the nodes below';
	bot.telegram.sendMessage(ctx.chat.id, msg,  { reply_markup:  inlineKeyboardChainsCommands});
});

bot.action('light', ctx => {
    instance = "./cel-key";
    denom = "utia";
    chainid = "blockspacerace";
    Nodetype = "light";
    bot.telegram.sendMessage(ctx.chat.id, `${icon.get('recycle')} Glad to support you ! ${icon.get('recycle')}`);
});


bot.action('bridge', ctx => {
    instance = "./cel-key";
    denom = "utia";
    chainid = "blockspacerace";
    Nodetype = "bridge";
    bot.telegram.sendMessage(ctx.chat.id, `${icon.get('recycle')} Glad to support you ! ${icon.get('recycle')}`);
});


bot.command('wallet', ctx => {
if(instance) {
    bot.telegram.sendMessage(ctx.chat.id,`
${icon.get('white_check_mark')} <b>Create new wallet</b>
${instance} add <b>WALLET_NAME</b> --keyring-backend test  --node.type ${Nodetype} --p2p.network ${chainid}

${icon.get('white_check_mark')} <b>Restore wallet</b>
${instance} add <b>WALLET_NAME</b> --keyring-backend test  --node.type ${Nodetype} --p2p.network ${chainid} --recover

${icon.get('white_check_mark')} <b>Export private key</b>
${instance} export <b>WALLET_NAME</b> --unarmored-hex --unsafe --keyring-backend test  --node.type ${Nodetype} --p2p.network ${chainid}

${icon.get('white_check_mark')} <b>Show list of wallet</b>
${instance} list <b>WALLET_NAME</b> --keyring-backend test  --node.type ${Nodetype} --p2p.network ${chainid}

${icon.get('white_check_mark')} <b>Query wallet balance</b>

curl -X GET http://127.0.0.1:26659/balance  | jq


${icon.get('white_check_mark')} <b>Import private key</b>
${instance} import <b>WALLET_NAME</b> <b>key_file</b> --keyring-backend test  --node.type ${Nodetype} --p2p.network ${chainid}
    `, {parse_mode: 'html'});
} else {
   bot.telegram.sendMessage(ctx.chat.id,`${icon.get('warning')} You did not select chain! Kindly select !`,{reply_markup: inlineKeyboardChainsCommands});
  }
});

bot.command('status', ctx => {
if(instance) {	
    bot.telegram.sendMessage(ctx.chat.id,`
${icon.get('white_check_mark')} <b>Synchronization status</b>
sudo journalctl -u celestia-${Nodetype} -f -o cat
    `, {parse_mode: 'html'});
} else {
   bot.telegram.sendMessage(ctx.chat.id,`${icon.get('warning')} You did not select chain! Kindly select !`,{reply_markup: inlineKeyboardChainsCommands});
  }
});

bot.command('nodeid', ctx => {
if(instance) {	
    bot.telegram.sendMessage(ctx.chat.id,`
${icon.get('white_check_mark')} <b>Show node id</b>

NODE_TYPE=${Nodetype}
AUTH_TOKEN=$(celestia $NODE_TYPE auth admin --p2p.network blockspacerace)
curl -X POST \
     -H "Authorization: Bearer $AUTH_TOKEN" \
     -H 'Content-Type: application/json' \
     -d '{"jsonrpc":"2.0","id":0,"method":"p2p.Info","params":[]}' \
     http://localhost:26658
     
    `, {parse_mode: 'html'});
 } else {
    bot.telegram.sendMessage(ctx.chat.id,`${icon.get('warning')} You did not select chain! Kindly select !`,{reply_markup: inlineKeyboardChainsCommands});
  }	
});

bot.command('links', ctx => {
if(instance) {	
    bot.telegram.sendMessage(ctx.chat.id,`
${icon.get('white_check_mark')} <b>official document</b>

https://docs.celestia.org/


${icon.get('white_check_mark')} <b>check tx</b>

https://testnet.mintscan.io/celestia-incentivized-testnet


${icon.get('white_check_mark')} <b>check node id status</b>

https://tiascan.com/light-nodes

    `, {parse_mode: 'html'});
} else {
   bot.telegram.sendMessage(ctx.chat.id,`${icon.get('warning')} You did not select chain! Kindly select !`,{reply_markup: inlineKeyboardChainsCommands});
  }	
});

bot.launch();
