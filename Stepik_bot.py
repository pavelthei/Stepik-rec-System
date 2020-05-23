from telebot import types
import datetime, time
import re
import telebot,requests
import pandas as pd
import random
df = pd.read_csv('cou_with_rev.csv')


bot = telebot.TeleBot("<Key>")

@bot.message_handler(commands=['start'])
def send_welcome(message):

 	bot.send_message(message.chat.id,f"Привет, {message.chat.first_name}!")
 	markup = types.InlineKeyboardMarkup(row_width=1)
 	itembtn1 = types.InlineKeyboardButton(text='Изучение языков', callback_data = '0')
 	itembtn2 = types.InlineKeyboardButton(text='Математика', callback_data = 'math')
 	itembtn3 = types.InlineKeyboardButton(text='Статистика и Программирование', callback_data = 'stat')
 	itembtn4 = types.InlineKeyboardButton(text='Школьные предметы', callback_data = 'scho')
 	itembtn5 = types.InlineKeyboardButton(text='Право', callback_data = 'law')
 	itembtn6 = types.InlineKeyboardButton(text='Экономика и менеджмент', callback_data = 'econ')
 	itembtn7 = types.InlineKeyboardButton(text='Курсы на иностранном языке', callback_data = '15')
 	itembtn8 = types.InlineKeyboardButton(text='Мне повезет!', callback_data = '12')
 	markup.add(itembtn1, itembtn2, itembtn3, itembtn4, itembtn5, itembtn6, itembtn7, itembtn8)
 	bot.send_message(message.chat.id, "Выбери что хотел бы изучать:" , reply_markup=markup)


@bot.callback_query_handler(func=lambda call: call.data == 'math')
def math(call):
    markup = types.InlineKeyboardMarkup(row_width=1)
    itembtn11 = types.InlineKeyboardButton('Мат. анализ, статистика', callback_data="2")
    itembtn12 = types.InlineKeyboardButton('Экономика, менеджмент', callback_data="9")
    itembtn13 = types.InlineKeyboardButton('Школьный курс, ЕГЭ', callback_data="11")
    itembtn10 = types.InlineKeyboardButton('Назад', callback_data="out")
    markup.add(itembtn11, itembtn12, itembtn13, itembtn10)
    bot.edit_message_text(chat_id=call.message.chat.id, message_id=call.message.message_id, text="Математика", reply_markup=markup)

@bot.callback_query_handler(func=lambda call: call.data == 'stat')
def stat(call):
    markup = types.InlineKeyboardMarkup(row_width=1)
    itembtn11 = types.InlineKeyboardButton('Мат. анализ, статистика', callback_data="2")
    itembtn12 = types.InlineKeyboardButton('Введение в анализ данных', callback_data="5")
    itembtn13 = types.InlineKeyboardButton('Продвинутый анализ данных', callback_data="7")
    itembtn10 = types.InlineKeyboardButton('Назад', callback_data="out")
    markup.add(itembtn11, itembtn12, itembtn13, itembtn10)
    bot.edit_message_text(chat_id=call.message.chat.id, message_id=call.message.message_id, text="Статистика и Программирование", reply_markup=markup)

@bot.callback_query_handler(func=lambda call: call.data == 'scho')
def scho(call):
    markup = types.InlineKeyboardMarkup(row_width=1)
    itembtn11 = types.InlineKeyboardButton('ОГЭ/ЕГЭ', callback_data="3")
    itembtn12 = types.InlineKeyboardButton('Школьные предметы', callback_data="4")
    itembtn13 = types.InlineKeyboardButton('ЕГЭ по математике', callback_data="11")
    itembtn10 = types.InlineKeyboardButton('Назад', callback_data="out")
    markup.add(itembtn11, itembtn12, itembtn13, itembtn10)
    bot.edit_message_text(chat_id=call.message.chat.id, message_id=call.message.message_id, text="Школьные предметы", reply_markup=markup)

@bot.callback_query_handler(func=lambda call: call.data == 'law')
def law(call):
    markup = types.InlineKeyboardMarkup(row_width=1)
    itembtn11 = types.InlineKeyboardButton('ПДД', callback_data="8")
    itembtn12 = types.InlineKeyboardButton('Правоведение, психология, история', callback_data="10")
    itembtn13 = types.InlineKeyboardButton('НКО', callback_data="16")
    itembtn10 = types.InlineKeyboardButton('Назад', callback_data="out")
    markup.add(itembtn11, itembtn12, itembtn13, itembtn10)
    bot.edit_message_text(chat_id=call.message.chat.id, message_id=call.message.message_id, text="Право", reply_markup=markup)

@bot.callback_query_handler(func=lambda call: call.data == 'econ')
def econ(call):
    markup = types.InlineKeyboardMarkup(row_width=1)
    itembtn11 = types.InlineKeyboardButton('Мат. анализ, статистика', callback_data="2")
    itembtn12 = types.InlineKeyboardButton('Экономика, менеджмент', callback_data="9")
    itembtn13 = types.InlineKeyboardButton('Управление', callback_data="17")
    itembtn10 = types.InlineKeyboardButton('Назад', callback_data="out")
    markup.add(itembtn11, itembtn12, itembtn13, itembtn10)
    bot.edit_message_text(chat_id=call.message.chat.id, message_id=call.message.message_id, text="Экономика и менеджмент", reply_markup=markup)

@bot.callback_query_handler(func=lambda call: call.data == '0')
def forlang(call):
    text = "https://stepik.org/course/" + random.choice([str(i) for i in df['id'][df.cluster_x == 0]])
    markup = types.InlineKeyboardMarkup()
    itembtn10 = types.InlineKeyboardButton('Назад', callback_data="out")
    itembtn11 = types.InlineKeyboardButton('Другое', callback_data="0")
    markup.add(itembtn10, itembtn11)
    bot.edit_message_text(chat_id=call.message.chat.id, message_id=call.message.message_id, text=text , reply_markup=markup)

@bot.callback_query_handler(func=lambda call: call.data == '2')
def forlang(call):
    text = "https://stepik.org/course/" + random.choice([str(i) for i in df['id'][df.cluster_x == 2]])
    markup = types.InlineKeyboardMarkup()
    itembtn10 = types.InlineKeyboardButton('Назад', callback_data="out")
    itembtn11 = types.InlineKeyboardButton('Другое', callback_data="2")
    markup.add(itembtn10, itembtn11)
    bot.edit_message_text(chat_id=call.message.chat.id, message_id=call.message.message_id, text=text , reply_markup=markup)

@bot.callback_query_handler(func=lambda call: call.data == '3')
def forlang(call):
    text = "https://stepik.org/course/" + random.choice([str(i) for i in df['id'][df.cluster_x == 3]])
    markup = types.InlineKeyboardMarkup()
    itembtn10 = types.InlineKeyboardButton('Назад', callback_data="out")
    itembtn11 = types.InlineKeyboardButton('Другое', callback_data="3")
    markup.add(itembtn10, itembtn11)
    bot.edit_message_text(chat_id=call.message.chat.id, message_id=call.message.message_id, text=text , reply_markup=markup)

@bot.callback_query_handler(func=lambda call: call.data == '4')
def forlang(call):
    text = "https://stepik.org/course/" + random.choice([str(i) for i in df['id'][df.cluster_x == 4]])
    markup = types.InlineKeyboardMarkup()
    itembtn10 = types.InlineKeyboardButton('Назад', callback_data="out")
    itembtn11 = types.InlineKeyboardButton('Другое', callback_data="4")
    markup.add(itembtn10, itembtn11)
    bot.edit_message_text(chat_id=call.message.chat.id, message_id=call.message.message_id, text=text , reply_markup=markup)

@bot.callback_query_handler(func=lambda call: call.data == '5')
def forlang(call):
    text = "https://stepik.org/course/" + random.choice([str(i) for i in df['id'][df.cluster_x == 5]])
    markup = types.InlineKeyboardMarkup()
    itembtn10 = types.InlineKeyboardButton('Назад', callback_data="out")
    itembtn11 = types.InlineKeyboardButton('Другое', callback_data="5")
    markup.add(itembtn10, itembtn11)
    bot.edit_message_text(chat_id=call.message.chat.id, message_id=call.message.message_id, text=text , reply_markup=markup)

@bot.callback_query_handler(func=lambda call: call.data == '7')
def forlang(call):
    text = "https://stepik.org/course/" + random.choice([str(i) for i in df['id'][df.cluster_x == 7]])
    markup = types.InlineKeyboardMarkup()
    itembtn10 = types.InlineKeyboardButton('Назад', callback_data="out")
    itembtn11 = types.InlineKeyboardButton('Другое', callback_data="7")
    markup.add(itembtn10, itembtn11)
    bot.edit_message_text(chat_id=call.message.chat.id, message_id=call.message.message_id, text=text , reply_markup=markup)

@bot.callback_query_handler(func=lambda call: call.data == '8')
def forlang(call):
    text = "https://stepik.org/course/" + random.choice([str(i) for i in df['id'][df.cluster_x == 8]])
    markup = types.InlineKeyboardMarkup()
    itembtn10 = types.InlineKeyboardButton('Назад', callback_data="out")
    itembtn11 = types.InlineKeyboardButton('Другое', callback_data="8")
    markup.add(itembtn10, itembtn11)
    bot.edit_message_text(chat_id=call.message.chat.id, message_id=call.message.message_id, text=text , reply_markup=markup)

@bot.callback_query_handler(func=lambda call: call.data == '9')
def forlang(call):
    text = "https://stepik.org/course/" + random.choice([str(i) for i in df['id'][df.cluster_x == 9]])
    markup = types.InlineKeyboardMarkup()
    itembtn10 = types.InlineKeyboardButton('Назад', callback_data="out")
    itembtn11 = types.InlineKeyboardButton('Другое', callback_data="9")
    markup.add(itembtn10, itembtn11)
    bot.edit_message_text(chat_id=call.message.chat.id, message_id=call.message.message_id, text=text , reply_markup=markup)

@bot.callback_query_handler(func=lambda call: call.data == '10')
def forlang(call):
    text = "https://stepik.org/course/" + random.choice([str(i) for i in df['id'][df.cluster_x == 10]])
    markup = types.InlineKeyboardMarkup()
    itembtn10 = types.InlineKeyboardButton('Назад', callback_data="out")
    itembtn11 = types.InlineKeyboardButton('Другое', callback_data="10")
    markup.add(itembtn10, itembtn11)
    bot.edit_message_text(chat_id=call.message.chat.id, message_id=call.message.message_id, text=text , reply_markup=markup)

@bot.callback_query_handler(func=lambda call: call.data == '11')
def forlang(call):
    text = "https://stepik.org/course/" + random.choice([str(i) for i in df['id'][df.cluster_x == 11]])
    markup = types.InlineKeyboardMarkup()
    itembtn10 = types.InlineKeyboardButton('Назад', callback_data="out")
    itembtn11 = types.InlineKeyboardButton('Другое', callback_data="11")
    markup.add(itembtn10, itembtn11)
    bot.edit_message_text(chat_id=call.message.chat.id, message_id=call.message.message_id, text=text , reply_markup=markup)

@bot.callback_query_handler(func=lambda call: call.data == '12')
def rand(call):
    text = "https://stepik.org/course/" + random.choice([str(i) for i in df['id'][df.cluster_x == 12]])
    markup = types.InlineKeyboardMarkup()
    itembtn10 = types.InlineKeyboardButton('Назад', callback_data="out")
    itembtn11 = types.InlineKeyboardButton('Другое', callback_data="12")
    markup.add(itembtn10, itembtn11)
    bot.edit_message_text(chat_id=call.message.chat.id, message_id=call.message.message_id, text=text , reply_markup=markup)

@bot.callback_query_handler(func=lambda call: call.data == '15')
def lang(call):
    text = "https://stepik.org/course/" + random.choice([str(i) for i in df['id'][df.cluster_x == 15]])
    markup = types.InlineKeyboardMarkup()
    itembtn10 = types.InlineKeyboardButton('Назад', callback_data="out")
    itembtn11 = types.InlineKeyboardButton('Другое', callback_data="15")
    markup.add(itembtn10, itembtn11)
    bot.edit_message_text(chat_id=call.message.chat.id, message_id=call.message.message_id, text=text , reply_markup=markup)

@bot.callback_query_handler(func=lambda call: call.data == '16')
def forlang(call):
    text = "https://stepik.org/course/" + random.choice([str(i) for i in df['id'][df.cluster_x == 16]])
    markup = types.InlineKeyboardMarkup()
    itembtn10 = types.InlineKeyboardButton('Назад', callback_data="out")
    itembtn11 = types.InlineKeyboardButton('Другое', callback_data="16")
    markup.add(itembtn10, itembtn11)
    bot.edit_message_text(chat_id=call.message.chat.id, message_id=call.message.message_id, text=text , reply_markup=markup)

@bot.callback_query_handler(func=lambda call: call.data == '17')
def forlang(call):
    text = "https://stepik.org/course/" + random.choice([str(i) for i in df['id'][df.cluster_x == 17]])
    markup = types.InlineKeyboardMarkup()
    itembtn10 = types.InlineKeyboardButton('Назад', callback_data="out")
    itembtn11 = types.InlineKeyboardButton('Другое', callback_data="17")
    markup.add(itembtn10, itembtn11)
    bot.edit_message_text(chat_id=call.message.chat.id, message_id=call.message.message_id, text=text , reply_markup=markup)

@bot.callback_query_handler(func=lambda call: call.data == 'out')
def forlang(call):
 	markup = types.InlineKeyboardMarkup(row_width=1)
 	itembtn1 = types.InlineKeyboardButton(text='Изучение языков', callback_data = '0')
 	itembtn2 = types.InlineKeyboardButton(text='Математика', callback_data = 'math')
 	itembtn3 = types.InlineKeyboardButton(text='Статистика и Программирование', callback_data = 'stat')
 	itembtn4 = types.InlineKeyboardButton(text='Школьные предметы', callback_data = 'scho')
 	itembtn5 = types.InlineKeyboardButton(text='Право', callback_data = 'law')
 	itembtn6 = types.InlineKeyboardButton(text='Экономика и менеджмент', callback_data = 'econ')
 	itembtn7 = types.InlineKeyboardButton(text='Курсы на иностранном языке', callback_data = '15')
 	itembtn8 = types.InlineKeyboardButton(text='Мне повезет!', callback_data = '12')
 	markup.add(itembtn1, itembtn2, itembtn3, itembtn4, itembtn5, itembtn6, itembtn7, itembtn8)
 	bot.edit_message_text(chat_id=call.message.chat.id, message_id=call.message.message_id, text="Выбери что хотел бы изучать:", reply_markup=markup)


@bot.message_handler(regexp="спасибо")
def send_out(message):
    bot.send_message(message.chat.id, 'Обращайся')

@bot.message_handler(func=lambda message: True, content_types=['text'])
def action(message):

 	markup = types.InlineKeyboardMarkup(row_width=1)
 	itembtn1 = types.InlineKeyboardButton(text='Изучение языков', callback_data = '0')
 	itembtn2 = types.InlineKeyboardButton(text='Математика', callback_data = 'math')
 	itembtn3 = types.InlineKeyboardButton(text='Статистика и Программирование', callback_data = 'stat')
 	itembtn4 = types.InlineKeyboardButton(text='Школьные предметы', callback_data = 'scho')
 	itembtn5 = types.InlineKeyboardButton(text='Право', callback_data = 'law')
 	itembtn6 = types.InlineKeyboardButton(text='Экономика и менеджмент', callback_data = 'econ')
 	itembtn7 = types.InlineKeyboardButton(text='Курсы на иностранном языке', callback_data = '15')
 	itembtn8 = types.InlineKeyboardButton(text='Мне повезет!', callback_data = '12')
 	markup.add(itembtn1, itembtn2, itembtn3, itembtn4, itembtn5, itembtn6, itembtn7, itembtn8)
 	bot.send_message(message.chat.id, "Выбери что хотел бы изучать:" , reply_markup=markup)


bot.polling(none_stop=True, interval=0)
