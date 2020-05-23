from telebot import types
import datetime, time
import re
import telebot,requests

bot = telebot.TeleBot("<key>")

@bot.message_handler(commands=['start'])
def send_welcome(message):

 	bot.send_message(message.chat.id,f"Привет, {message.chat.first_name}!")
 	markup = types.InlineKeyboardMarkup(row_width=2)
 	itembtn1 = types.InlineKeyboardButton(text='Математика', callback_data = 'math')
 	itembtn2 = types.InlineKeyboardButton(text='Статистика', callback_data = 'stat')
 	itembtn3 = types.InlineKeyboardButton(text='Химия', callback_data = 'cham')
 	itembtn4 = types.InlineKeyboardButton(text='Программирование', callback_data = 'prog')
 	markup.add(itembtn1, itembtn2, itembtn3, itembtn4)
 	bot.send_message(message.chat.id, "Если у тебя есть аккаунт на stepik.org можешь ввести свой id или просто выбрать предмет который хотел бы изучать" , reply_markup=markup)

@bot.callback_query_handler(func=lambda call: call.data == 'math')
def math(call):
    stat_result = 'https://stepik.org/course/716'
    markup = types.InlineKeyboardMarkup()
    itembtn10 = types.InlineKeyboardButton('Другой', callback_data="in")
    markup.add(itembtn10)
    bot.send_message(chat_id=call.message.chat.id, text= stat_result, reply_markup=markup)

@bot.callback_query_handler(func=lambda call: call.data == 'stat')
def stat(call):
	stat_result = "https://stepik.org/course/76/"
	markup = types.InlineKeyboardMarkup()
	itembtn10 = types.InlineKeyboardButton('Другой', callback_data="in")
	markup.add(itembtn10)
	bot.send_message(chat_id=call.message.chat.id, text= stat_result, reply_markup=markup)

@bot.callback_query_handler(func=lambda call: call.data == 'cham')
def cham(call):
	stat_result = "https://stepik.org/course/70/"
	markup = types.InlineKeyboardMarkup()
	itembtn10 = types.InlineKeyboardButton('Другой', callback_data="in")
	markup.add(itembtn10)
	bot.send_message(chat_id=call.message.chat.id, text= stat_result, reply_markup=markup)


@bot.callback_query_handler(func=lambda call: call.data == 'prog')
def prog(call):
	stat_result = "https://stepik.org/course/67/"
	markup = types.InlineKeyboardMarkup()
	itembtn10 = types.InlineKeyboardButton('Другой', callback_data="in")
	markup.add(itembtn10)
	bot.send_message(chat_id=call.message.chat.id, text= stat_result, reply_markup=markup)

@bot.callback_query_handler(func=lambda call: True)
def callback_inline(call):
    if call.message:
        if call.data == "in":
            markup = types.InlineKeyboardMarkup()
            itembtn10 = types.InlineKeyboardButton('Другой', callback_data="out")
            markup.add(itembtn10)
            bot.edit_message_text(chat_id=call.message.chat.id, message_id=call.message.message_id, text="https://stepik.org/course/3089", reply_markup=markup)

@bot.message_handler(regexp="спасибо")
def send_out(message):
    bot.send_message(message.chat.id, 'Обращайся')


@bot.message_handler(func=lambda message: True, content_types=['text'])
def action(message):
    markup = types.InlineKeyboardMarkup(row_width=2)
    itembtn1 = types.InlineKeyboardButton(text='Математика', callback_data = 'math')
    itembtn2 = types.InlineKeyboardButton(text='Статистика', callback_data = 'stat')
    itembtn3 = types.InlineKeyboardButton(text='Химия', callback_data = 'cham')
    itembtn4 = types.InlineKeyboardButton(text='Программирование', callback_data = 'prog')
    markup.add(itembtn1, itembtn2, itembtn3, itembtn4)
    bot.send_message(message.chat.id, "Если у тебя есть аккаунт на stepik.org можешь ввести свой id или просто выбрать предмет который хотел бы изучать" , reply_markup=markup)


bot.polling(none_stop=True, interval=0)
