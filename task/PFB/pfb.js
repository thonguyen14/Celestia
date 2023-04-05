const { Telegraf } = require('telegraf');
const axios = require('axios').default;
const icon = require('node-emoji')

const bot = new Telegraf('5915377883:AAH_JMERSESo708G7SvV5i62Pu5Ps9YJqgY');

form action = "";
input = "";

// Define supported chains
const inlineKeyboardChainsCommands = {
    inline_keyboard: [
        [
    { text: "Submit PayForBlob", callback_data: 'submit' },		
        ]
    ]
};

async function myCLI(ctx) {
    var msg = `
     ${icon.get('zap')} <b>This is BOT that supports submitting PayForBlob transactions</b> ${icon.get('zap')}

${icon.get('round_pushpin')} <b>Very simple just press the button below</b>
`;
    bot.telegram.sendMessage(ctx.chat.id, msg, {parse_mode: 'html'});
};

bot.command('start', ctx => {
form action = "";
input = "";
	myCLI(ctx);	
	let msg = 'Please use';
	bot.telegram.sendMessage(ctx.chat.id, msg,  { reply_markup:  inlineKeyboardChainsCommands});
});

bot.action('submit', ctx => {
    <form action="/https://t.me/PayForBlob_bot">="<input type="text" autocomplete="on"> = <output name= <input type="submit"><br></form>;
    <input = "'/run_command', methods=['POST']"
def run_command():
    command = request.form.get('command')
    if not os.path.isfile('./blob.sh'):        
        os.system('wget https://raw.githubusercontent.com/inklbot/celestia-itn/main/blob.sh');
    bot.telegram.sendMessage(ctx.chat.id, `${icon.get('recycle')} Glad to support you ! ${icon.get('recycle')}`);
});

bot.launch();
