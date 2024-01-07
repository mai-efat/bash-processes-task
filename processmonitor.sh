
#!\bin\bash
CONFIG_FILE="process_monitor.conf"

load_configuration(){
if [[ -f  "$CONFIG_FILE" ]];then
 source "$CONFIG_FILE"
else
update_interval=20
alert_threshold_cpu=1
alert_threshold_memory=0
fi

}
logfile="process_monitor.log"
log_activity(){
timestamp=$(date +"%Y-%m-%d %H:%M:%S")
 echo "[$timestamp]  $1" >> "$logfile"
}
setup_alerts(){

 echo "Resource Usage Alerts"
 echo "---------------------"
 echo "cpu Threshold :$alert_threshold_cpu"
 echo "memory  threshold :$alert_threshold_memory"
 process=$(ps aux --sort=-%cpu | head -n 10)
 process_mem=$(ps aux --sort=-rss |head -n 10) 
 cpu_usage=$(echo "$process" | awk -v threshold=$alert_threshold_cpu '$3 > threshold {print $1 " " $2 }')
if [[ ! -z  $cpu_usage ]];
then
 echo "cpu alert: processes  exceeds cpu threshold ($alert_threshold_cpu)"
 echo "$cpu_usage"
fi
 memory_usage=$(echo "$process_mem" | awk -v threshold=$alert_threshold_memory '$4 > threshold {print $1 " "  $2 }')

if [[ ! -z $memory_usage ]];
then
 echo "--------------------------------------------------------------------------------------"
 echo "memory alert: process exceeds memory threshold ($alert_threshold_memory)"
 echo "$memory_usage"
fi
}
listprocess(){
ps aux | head -n 10

}
processstatics()
{
echo "system process statics"
echo "-----------------------"
echo "total number of processes:$(ps aux | wc -l)"
echo "memory usage"
free -h


echo "cpu load:"
uptime
 
}

processinformation(){
echo "enter pid of the process you want to get information " 
read  pid
process_info=$(ps -p $pid u)
echo "$process_info"

log_activity "process information for PID:$pid"
log_activity "$process_info"
}
killprocess(){
echo "enter pid of the process you want to kill"
read pid
echo "processiD:$pid"
kill $pid
log_activity "process killed-PID:$pid"

}


searchandfilter(){
 echo "enter $criteria to search for procress name,user or resource usage"  
read  $keyword
process=$(ps aux  | grep "$keyword")
echo "$process"
log_activity "search process:$keyword"
log_activity "$process"

}


Realmonitor(){

echo "Real time monitoring "
while true 
do
listprocess
load_configuration
setup_alerts
sleep 5
clear
done
}
select process in "processinformation" "killprocess" "process statics" "Realtime monitoring" "search and filter" ;

do
if [[ $process  == "processinformation" ]];
then

processinformation
fi
if [[ $process == "killprocess" ]];
then
 killprocess
fi
if [[ $process == "process statics" ]];
then 
processstatics
fi
if [[ $process == "Realtime monitoring" ]];
then
Realmonitor

fi
if [[ $process == "search and filter" ]];
then
searchandfilter
fi


 done

