#!/bin/bash

hoje=`date +%d`
meshoje=`date +%m`

if [ $hoje -eq "01" ]
then
        if [ $meshoje -gt "10" ]
        then
                mesant=`echo $(($meshoje-1))`
        elif [ $meshoje -eq "01" ]
        then
                mesant=12
                anohoje=`date +%Y`
                anoant=`echo $(($anohoje-1))`
                mv /var/www/html/historico.html /var/www/html/historico-$anoant-$mesant.html
        elif [ $meshoje -lt "10" ]
        then
                zero="0"
                anohoje=`date +%Y`
                mesant=`echo $zero$(($meshoje-1))`
                mv /var/www/html/historico.html /var/www/html/historico-$anohoje-$mesant.html
        fi
else
        rm -rf /var/www/html/historico.html
fi

atualiza=`date`
echo "<html>" >> /var/www/html/historico.html
echo "<title>Histórico de Publicações no Portal da IN</title>" >> /var/www/html/historico.html
echo " " >> /var/www/html/historico.html
echo "<head>" >> /var/www/html/historico.html
echo "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">" >> /var/www/html/historico.html
echo "<style>" >> /var/www/html/historico.html
echo "body {" >> /var/www/html/historico.html
echo "  margin: 0;" >> /var/www/html/historico.html
echo "  font-family: Arial, Helvetica, sans-serif;" >> /var/www/html/historico.html
echo "}" >> /var/www/html/historico.html
echo "table, th, td {" >> /var/www/html/historico.html
echo "  border: 1px solid black;" >> /var/www/html/historico.html
echo "  border-collapse: collapse;" >> /var/www/html/historico.html
echo "}" >> /var/www/html/historico.html
echo "tr:hover {" >> /var/www/html/historico.html
echo "  background-color: #DCDCDC;" >> /var/www/html/historico.html
echo "}" >> /var/www/html/historico.html
echo "* {" >> /var/www/html/historico.html
echo "  box-sizing: border-box;" >> /var/www/html/historico.html
echo "}" >> /var/www/html/historico.html
echo "#myInput {" >> /var/www/html/historico.html
echo "  margin: auto;" >> /var/www/html/historico.html
echo "  width: 65%;" >> /var/www/html/historico.html
echo "  border: 3px solid #73AD21;" >> /var/www/html/historico.html
echo "  padding: 10px;" >> /var/www/html/historico.html
echo "}" >> /var/www/html/historico.html
echo "#myInputsecao {" >> /var/www/html/historico.html
echo "  margin: auto;" >> /var/www/html/historico.html
echo "  width: 65%;" >> /var/www/html/historico.html
echo "  border: 3px solid #73AD21;" >> /var/www/html/historico.html
echo "  padding: 10px;" >> /var/www/html/historico.html
echo "}" >> /var/www/html/historico.html
echo "#myTable {" >> /var/www/html/historico.html
echo "  border-collapse: collapse;" >> /var/www/html/historico.html
echo "  width: 100%;" >> /var/www/html/historico.html
echo "  border: 1px solid #ddd;" >> /var/www/html/historico.html
echo "  font-size: 18px;" >> /var/www/html/historico.html
echo "}" >> /var/www/html/historico.html
echo "#myTable th, #myTable td {" >> /var/www/html/historico.html
echo "  text-align: left;" >> /var/www/html/historico.html
echo "  padding: 12px;" >> /var/www/html/historico.html
echo "}" >> /var/www/html/historico.html
echo "#myTable tr {" >> /var/www/html/historico.html
echo "  border-bottom: 1px solid #ddd;" >> /var/www/html/historico.html
echo "}" >> /var/www/html/historico.html
echo "#myTable tr.header, #myTable tr:hover {" >> /var/www/html/historico.html
echo "  background-color: #f1f1f1;" >> /var/www/html/historico.html
echo "}" >> /var/www/html/historico.html
echo "</style>" >> /var/www/html/historico.html
echo " " >> /var/www/html/historico.html
echo "<body>" >> /var/www/html/historico.html
echo "<center><h2>Histórico de Publicações no Portal da IN</h2></center>" >> /var/www/html/historico.html
echo "<script>" >> /var/www/html/historico.html
echo "var btnContainer = document.getElementById(\"myBtnContainer\");" >> /var/www/html/historico.html
echo "var btns = 0;" >> /var/www/html/historico.html
echo "for (var i = 0; i < btns.length; i++) {" >> /var/www/html/historico.html
echo "  btns[i].addEventListener(\"click\", function() {" >> /var/www/html/historico.html
echo "    var current = document.getElementsByClassName(\"active\");" >> /var/www/html/historico.html
echo "    current[0].className = current[0].className.replace(\" active\", \"\");" >> /var/www/html/historico.html
echo "    this.className += \" active\";" >> /var/www/html/historico.html
echo "  });" >> /var/www/html/historico.html
echo "}" >> /var/www/html/historico.html
echo "function myFunction() {" >> /var/www/html/historico.html
echo "  var x = document.getElementById(\"myTopnav\");" >> /var/www/html/historico.html
echo "  if (x.className === \"topnav\") {" >> /var/www/html/historico.html
echo "    x.className += \" responsive\";" >> /var/www/html/historico.html
echo "  } else {" >> /var/www/html/historico.html
echo "    x.className = \"topnav\";" >> /var/www/html/historico.html
echo "  }" >> /var/www/html/historico.html
echo "}" >> /var/www/html/historico.html
echo "function myData() {" >> /var/www/html/historico.html
echo "  var input, filter, table, tr, td, i, txtValue;" >> /var/www/html/historico.html
echo "  input = document.getElementById(\"myInput\");" >> /var/www/html/historico.html
echo "  filter = input.value.toUpperCase();" >> /var/www/html/historico.html
echo "  table = document.getElementById(\"myTable\");" >> /var/www/html/historico.html
echo "  tr = table.getElementsByTagName(\"tr\");" >> /var/www/html/historico.html
echo "  for (i = 0; i < tr.length; i++) {" >> /var/www/html/historico.html
echo "  td = tr[i].getElementsByTagName(\"td\")[0];" >> /var/www/html/historico.html
echo "    if (td) {" >> /var/www/html/historico.html
echo "      txtValue = td.textContent || td.innerText;" >> /var/www/html/historico.html
echo "      if (txtValue.toUpperCase().indexOf(filter) > -1) {" >> /var/www/html/historico.html
echo "        tr[i].style.display = \"\";" >> /var/www/html/historico.html
echo "      } else {" >> /var/www/html/historico.html
echo "        tr[i].style.display = \"none\";" >> /var/www/html/historico.html
echo "      }" >> /var/www/html/historico.html
echo "    }" >> /var/www/html/historico.html
echo "  }" >> /var/www/html/historico.html
echo "}" >> /var/www/html/historico.html
echo "function mySecao() {" >> /var/www/html/historico.html
echo "  var input, filter, table, tr, td, i, txtValue;" >> /var/www/html/historico.html
echo "  input = document.getElementById(\"myInputsecao\");" >> /var/www/html/historico.html
echo "  filter = input.value.toUpperCase();" >> /var/www/html/historico.html
echo "  table = document.getElementById(\"myTable\");" >> /var/www/html/historico.html
echo "  tr = table.getElementsByTagName(\"tr\");" >> /var/www/html/historico.html
echo "  for (i = 0; i < tr.length; i++) {" >> /var/www/html/historico.html
echo "  td = tr[i].getElementsByTagName(\"td\")[1];" >> /var/www/html/historico.html
echo "    if (td && tr[i].style.display != \"none\") {" >> /var/www/html/historico.html
echo "      txtValue = td.textContent || td.innerText;" >> /var/www/html/historico.html
echo "      if (txtValue.toUpperCase().indexOf(filter) > -1) {" >> /var/www/html/historico.html
echo "        tr[i].style.display = \"\";" >> /var/www/html/historico.html
echo "      } else {" >> /var/www/html/historico.html
echo "        tr[i].style.display = \"none\";" >> /var/www/html/historico.html
echo "      }" >> /var/www/html/historico.html
echo "    }" >> /var/www/html/historico.html
echo "  }" >> /var/www/html/historico.html
echo "}" >> /var/www/html/historico.html
echo "</script>" >> /var/www/html/historico.html
echo "</body>" >> /var/www/html/historico.html
echo "<p><center>Atualizado em: $atualiza</center></p>" >> /var/www/html/historico.html
echo "<p><center><input type=\"text\" id=\"myInput\" onkeyup=\"myData();mySecao()\" placeholder=\"Pesquise por dia. Ex.: 1970-12-31\" title=\"Pesquise por dia. Ex.: 1970-12-31\"></center></p>" >> /var/www/html/historico.html
echo "<p><center><input type=\"text\" id=\"myInputsecao\" onkeyup=\"myData();mySecao()\" placeholder=\"Pesquise por seção: Ex.: Seção 1\" title=\"Pesquise por seção: Ex.: Seção 1\"></center></p>" >> /var/www/html/historico.html
echo " " >> /var/www/html/historico.html
echo "<center><table id=myTable style=width:65%>" >> /var/www/html/historico.html
echo "<tr style=\"background-color: #DCDCDC;\" aling>" >> /var/www/html/historico.html
echo "    <th style=\"text-align:center\"> DATA </th>" >> /var/www/html/historico.html
echo "    <th style=\"text-align:center\"> SEÇÃO </th>" >> /var/www/html/historico.html
echo "    <th style=\"text-align:center\"> GN4 </th>" >> /var/www/html/historico.html
echo "  <th style=\"text-align:center\"> PORTAL </th>" >> /var/www/html/historico.html
echo "</tr>" >> /var/www/html/historico.html

for dia in $( eval echo {"$hoje"..1});
do
        if [ $dia -lt "10" ]
        then
                zero="0"
                dia=$zero$dia
        fi
        if [[ "$dia" == *"00"* ]]
        then
                dia=`echo $dia | sed 's/^.//'`
        fi
        ano=`date +%Y`
        mes=`date +%m`
        data="$ano-$mes-$dia"

        for secao in do1 do2 do3 do1e do2e do3e do1esp do2esp do1a;
        do
                if [ "$secao" = 'do1' ]
                then
                        jornal=\'\"idJornal\":515\'
                        nome="Seção 1"
                elif [ "$secao" = 'do2' ]
                then
                        jornal=\'\"idJornal\":529\'
                        nome="Seção 2"
                elif [ "$secao" = 'do3' ]
                then
                        jornal=\'\"idJornal\":530\'
                        nome="Seção 3"
                elif [ "$secao" = 'do1e' ]
                then
                        jornal=\'\"idJornal\":600\\\|\"idJornal\":601\\\|\"idJornal\":602\\\|\"idJornal\":603\\\|\"idJornal\":612\\\|\"idJornal\":613\\\|\"idJornal\":614\\\|\"idJornal\":615\'
                        nome="Seção 1 - Extra"
                elif [ "$secao" = 'do1esp' ]
                then
                        jornal=\'\"idJornal\":701\'
                        nome="Seção 1 - Especial"
                elif [ "$secao" = 'do2e' ]
                then
                        jornal=\'\"idJornal\":604\\\|\"idJornal\":605\\\|\"idJornal\":606\\\|\"idJornal\":607\'
                        nome="Seção 2 - Extra"
                elif [ "$secao" = 'do2esp' ]
                then
                        jornal=\'\"idJornal\":702\'
                        nome="Seção 2 - Especial"
                elif [ "$secao" = 'do3e' ]
                then
                        jornal=\'\"idJornal\":608\\\|\"idJornal\":609\\\|\"idJornal\":610\\\|\"idJornal\":611\'
                        nome="Seção 3 - Extra"
                elif [ "$secao" = 'do1a' ]
                then
                        jornal=\'\"idJornal\":1020\'
                        nome="Suplemento Orçamento"
                fi

                comando="cat /opt/kafka-monitor/logs/messages.log | grep $jornal | grep $data"
                echo "$comando > /opt/kafka-monitor/logs/messages-html-$data.log" > /opt/kafka-monitor/comando.sh
                sh /opt/kafka-monitor/comando.sh
                rm -rf /opt/kafka-monitor/comando.sh

                echo "$comando | wc -l" > /opt/kafka-monitor/countgn4.sh
                countgn4=`sh /opt/kafka-monitor/countgn4.sh`

                if [ $countgn4 -eq 0 ]
                then
                        quantidadegn4=0
                else
                        while read line;
                        do
                                echo "$line" | python -m json.tool | grep quantidade | awk '{print$2}' | sed 's/,//g' | sed 's/\"//g'
                        done < /opt/kafka-monitor/logs/messages-html-$data.log >> /opt/kafka-monitor/logs/messages-html-$data-1.log
                        quantidadegn4=`cat /opt/kafka-monitor/logs/messages-html-$data-1.log | awk '{s+=$1} END {printf "%.0f\n", s}'`
                fi

                rm -rf /opt/kafka-monitor/countgn4.sh

                get1=`/bin/curl -G --silent -XGET 'http://172.16.2.210:8080/leiturajornal' --data-urlencode "data=$dia-$mes-$ano" --data-urlencode "secao=$secao" | grep "pubOrder"`
                count=`echo "$get1" | sed -r '/^\s*$/d' | wc -l`

                if [ $count -ne 0 ]
                then
                        quantidadeportal=`echo "$get1" | python -m json.tool | grep 'numberPage' | wc -l` >> /var/www/html/historico.html
                else
                        quantidadeportal=`echo 0` >> /var/www/html/historico.html
                fi

                echo "<tr>" >> /var/www/html/historico.html
                echo "<td style="text-align:center">$data</td>" >> /var/www/html/historico.html
                echo "<td style="text-align:center">$nome</td>" >> /var/www/html/historico.html
                echo "<td style="text-align:center">$quantidadegn4</td>" >> /var/www/html/historico.html
                echo "<td style="text-align:center">$quantidadeportal</td>" >> /var/www/html/historico.html
                echo "</tr>" >> /var/www/html/historico.html

                rm -rf /opt/kafka-monitor/logs/messages-html-$data-1.log
        done
        rm -rf /opt/kafka-monitor/logs/messages-html-$data.log
done

echo "</table></center>" >> /var/www/html/historico.html
echo "</html>" >> /var/www/html/historico.html
