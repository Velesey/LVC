#!/bin/bash
is_show_help=true
const_val=5
max_volume=200
min_volume=0
if [ "$#" -gt 0 -a "$1" = "-p" ]; then
    char=+
    if  test -z $2; then 
    	val=$const_val
    else
        val="$2" 
    fi
    is_show_help=false
fi
if [ "$#" -gt 0 -a "$1" = "-m" ]; then
    char=-
    if  test -z $2; then 
    	val=$const_val
    else
        val="$2" 
    fi
    is_show_help=false
fi
if $is_show_help; then           														      # если нет параметров, отображаем справочное сообщение
	echo "Регулирка громкости 
	-p [10] -- (plus 10) увеличить на 10% 
	-m [10] -- (minus 10) уменьшить на 10%
    максимальный уровень громкости - $max_volume%"
else
    vol=$(amixer get Master | grep Left | grep -o '[0-9]\{1,3\}%' | grep -o '[0-9]\{1,3\}') # получаем текущее значение громкости
	let "vol = $vol $char $val"                                                               # прибавляем или отнимаем от текущей громкости параметр val
	if (($vol>$max_volume)); then
	vol=$max_volume
	fi
	if (($vol<$min_volume)); then
		vol=$min_volume
	fi
	pactl -- set-sink-volume alsa_output.pci-0000_00_1b.0.analog-stereo $vol%                 # устанавливаем новую громкость
    notify-send  "Громкость : $vol%" -t 1 													  # отображаем уведомление
fi
