#!/bin/bash

#создание базы данных 3 поля (дата,время, признак работы), имя базы DB_FILE

sqlite3=`which sqlite3`
DB_FILE=state.db
SQLITE_OPTIONS=" -column -header  "



$sqlite3 $DB_FILE  "
        create table IF NOT EXISTS  state(
                date TEXT,
                time TEXT,
                crash TEXT);"

#фунция добавления записи в базу включений выключений компа и печати журнала включений
function sq () {
$sqlite3 $DB_FILE  " insert into state (date,time,crash) values  ('"$(date +"%m-%d-%Y")"' , '"$(date +"%T")"' , '"$1"')"

echo "     
          On/Off host log:"
$sqlite3 $SQLITE_OPTIONS $DB_FILE <<EOF
        SELECT * FROM state;
EOF
}
#функция поиска состояния последнего включения компа и запись в переменную output
function state(){
output=`$sqlite3 $DB_FILE  <<EOF
      SELECT crash FROM state ORDER BY TIME DESC LIMIT 1;
EOF`
}


function power_off(){
echo "Выключение компа.."

#проверка наличия рабочего  состояния компа state (work -рабочий burn- сгорел)

state

   if [ $output == "work" ]
     then
       echo "Введите цифру ресурса от 0 до 1"
       read a
       if [ $a == $((RANDOM % 1)) ]
         then
           echo "Лимит ресурса не превышен. Комп выключен!"; sq work
         else echo "Превышение лимита ресурса Ваш комп сгорел"; sq burn
        fi
      else echo "Ваш комп сгорел выключение невозможно!"; 
    fi
}


function power_on(){
echo "Включение компа..";
#проверка наличия рабочего  состояния компа state (work -рабочий burn- сгорел) 
state 

if [ $output == "work" ] 
 then 
   echo "Комп включен" "Введите цифру ресурса от 0 до 1"
   read a
    if [ $a == $((RANDOM % 1)) ] 
     then 
     echo "Лимит ресурса не превышен. Комп выключается.."; sq work; power_off
     else echo "Превышение лимита ресурса Ваш комп сгорел!"; sq burn 
   fi
  else echo "Ваш комп сгорел включение невозможно!" 
fi
}

#проверка наличия рабочего  состояния компа state (work -рабочий burn- сгорел)
#если файл базы был создан заново то заноситься запись об успешном включении

state
if [[ $output == "" ]]; then
 sq work
fi

power_on
#power_off
