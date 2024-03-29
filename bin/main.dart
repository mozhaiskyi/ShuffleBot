import 'package:ShuffleBot/shuffle_bot.dart';
import 'package:teledart/model.dart';
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';
import 'dart:io';

main(List<String> arguments) {

  final String FLAVOR = arguments.isNotEmpty ? arguments[0] : null; 

  final Map env = Platform.environment;
  var TOKEN;
  switch (FLAVOR) {
    case 'RELEASE': {
      TOKEN = env['CHU_WA_CHI_TELEGRAM_TOKEN'];
    }
    break;

    default: {
      TOKEN = env['CHU_WA_CHI_TELEGRAM_TOKEN_DEV'];
    }
    break;
  }
  
  Telegram telegram = Telegram(TOKEN);
  TeleDart teledart = TeleDart(telegram, Event());

  teledart.start().then((me) => print('${me.username} is initialised'));

  teledart.onCommand('start').listen((message) => handleCommand('START', message, teledart));
  teledart.onCommand('create').listen(((message) => handleCommand('CREATE', message, teledart)));
  teledart.onCommand('shuffle').listen((message) => handleCommand('SHUFFLE', message, teledart));
  teledart.onCommand('add').listen((message) => handleCommand('ADD', message, teledart));
  teledart.onCommand('remove').listen((message) => handleCommand('REMOVE', message, teledart));
  teledart.onCommand('go').listen((message) => handleCommand('GO', message, teledart));
  teledart.onCommand('run').listen((message) => handleCommand('RUN', message, teledart));
  teledart.onCommand('current').listen((message) => handleCommand('CURRENT', message, teledart));
  teledart.onCommand('info').listen((message) => handleCommand('INFO', message, teledart));
  teledart.onCommand('strategy').listen((message) => handleCommand('STRATEGY', message, teledart));

  teledart.onMessage(keyword: '\\+', entityType: '*').listen((message) => handleMessage('PLUS', message, teledart));
}

void handleMessage(String keyword, Message message, TeleDart teledart) {
  onMessage(keyword, message)
  .then((result) => result != null ? teledart.replyMessage(message, result) : null);
}

Future<String> onMessage(String keyword, Message message) {
  var chat_id = () => message.chat.id.toString();
  var sender = () => message.from.username ?? message.from.first_name;

  switch(keyword) {
    case "PLUS": return ShuffleBot.plusKeyword(chat_id(), sender()); break;
    default: return Future.value(null);
  }
}

void handleCommand(String command, Message message, TeleDart teledart) {
  onCommand(command, message)
  .then((result) => result != null ? teledart.replyMessage(message, result, parse_mode: 'markdown') : null);
}

Future<String> onCommand(String command, Message message) {
  final chat_id = () => message.chat.id.toString();
  final text = () => message.text;
  final sender = () => message.from.username ?? message.from.first_name;

  switch (command) {
    case "CREATE": return ShuffleBot.createCommand(chat_id(), text());
    case "SHUFFLE": return ShuffleBot.shuffleCommand(chat_id(), text());
    case "ADD": return ShuffleBot.addCommand(chat_id(), text());
    case "REMOVE": return ShuffleBot.removeCommand(chat_id(), text());
    case "GO": return ShuffleBot.goCommand(chat_id(), sender());
    case "CURRENT": return ShuffleBot.currentCommand(chat_id());
    case "START": return ShuffleBot.startCommand(chat_id(), sender());
    case "INFO": return ShuffleBot.infoCommand();
    case "STRATEGY": return ShuffleBot.strategyCommand(chat_id(), text());
    default: return Future.value(null);
  }
}
