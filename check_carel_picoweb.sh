#/bin/sh



# carel pcoweb  cooling systems
# check ambient temp, output temp, humidity levels
# by Nika Chkhikvishvili - smartlogic 2015

# currently snmp v1 only



in_hostname=$1
in_community=$2
in_check_type=$3
in_warning=`echo $4*10|bc`
in_critical=`echo $5*10|bc`
in_timeout=$6

##########
warn=`echo $in_warning/10|bc`
crit=`echo $in_critical/10|bc`



function statecomp {


if [ $curvalue -le $in_warning  ]; then 

   echo -en OK;
   stateid=0
   

elif [ $curvalue -gt $in_warning ] && [ $curvalue -le $in_critical ]; then

   
   echo -en  "WARNING"
   stateid=1
 elif  [ $curvalue -gt $in_critical ]; then

   echo -en  "CRITICAL"
   stateid=2
    
  else
  
   echo -en "UNKNOWN"
   stateid=3
 
  fi

}



# give output 
     
 

    if [ "$in_check_type" == "ambient-temp" ]; then
    
        curvalue=$(snmpget -OvqU -v 1 -c $in_community -t 10 $in_hostname 1.3.6.1.4.1.9839.2.1.2.4.0)
        
        statecomp
        value=`echo $curvalue/10|bc`
        echo -e  " - Ambient Temperature is: $value | ambient_temp=$value;$warn;$crit"
        exit $stateid
    
   elif [ "$in_check_type" == "humidity" ]; then
        
        curvalue=$(snmpget -OvqU -v 1 -c $in_community -t 10 $in_hostname 1.3.6.1.4.1.9839.2.1.2.1.0)
        statecomp
        value=`echo $curvalue/10|bc`
        echo -e  " - Relative Humidity is: $value% | relative_humidity=$value;$warn;$crit"
        exit $stateid

    
   elif [ "$in_check_type" == "output-temp" ]; then
    
        curvalue=$(snmpget -OvqU -v 1 -c $in_community -t 10 $in_hostname 1.3.6.1.4.1.9839.2.1.2.5.0)
        statecomp
       value=`echo $curvalue/10|bc`
        echo -e  " - Output Temperature is: $value | output_temp=$value;$warn;$crit"
        exit $stateid
         
    else 
       echo "wrong check types defined."
       stateid=3
       
fi


