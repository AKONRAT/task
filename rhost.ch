#!/bin/bash

function checkres(){
echo "Включение компа.."

#проверка наличия файла состояния компа stat.txt в этом же каталоге 
#в случае отсутствия файла он создается с признаком 
#работоспособности компа (значение внутри 1) 

if test -f "state.txt";
 then echo ""
 else echo 1 > state.txt  
 fi
if [ $(cat state.txt) == 1 ] 
 then 
   echo "Введите цифру ресурса от 0 до 1"
   read a
 
    if [ $a == $((RANDOM % 1)) ] 
     then 
     echo "Лимит ресурса не превышен"; echo 1  > state.txt
     else echo "Превышение лимита ресурса Ваш комп разрушен"; echo 0  > state.txt 
   fi
  else echo "Ваш комп сгорел включение невозможно" 
  echo $rand
fi
}

checkres
