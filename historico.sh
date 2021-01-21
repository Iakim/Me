
#!/bin/bash

atualiza=`date`
echo "<html>"
echo "<title>Histórico de Publicações no Portal da IN</title>"
echo " "
echo "<head>"
echo "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">"
echo "<style>"
echo "body {"
echo "  margin: 0;"
echo "  font-family: Arial, Helvetica, sans-serif;"
echo "}"
echo "table, th, td {"
echo "  border: 1px solid black;"
echo "  border-collapse: collapse;"
echo "}"
echo "tr:hover {"
echo "  background-color: #DCDCDC;"
echo "}"
echo "* {"
echo "  box-sizing: border-box;"
echo "}"
echo "#myInput {"
echo "  margin: auto;"
echo "  width: 65%;"
echo "  border: 3px solid #73AD21;"
echo "  padding: 10px;"
echo "}"
echo "#myInputsecao {"
echo "  margin: auto;"
echo "  width: 65%;"
echo "  border: 3px solid #73AD21;"
echo "  padding: 10px;"
echo "}"
echo "#myTable {"
echo "  border-collapse: collapse;"
echo "  width: 100%;"
echo "  border: 1px solid #ddd;"
echo "  font-size: 18px;"
echo "}"
echo "#myTable th, #myTable td {"
echo "  text-align: left;"
echo "  padding: 12px;"
echo "}"
echo "#myTable tr {"
echo "  border-bottom: 1px solid #ddd;"
echo "}"
echo "#myTable tr.header, #myTable tr:hover {"
echo "  background-color: #f1f1f1;"
echo "}"
echo "</style>"
echo " "
echo "<body>"
echo "<center><h2>Histórico de Publicações no Portal da IN</h2></center>"
echo "<script>"
echo "var btnContainer = document.getElementById(\"myBtnContainer\");"
echo "var btns = 0;"
echo "for (var i = 0; i < btns.length; i++) {"
echo "  btns[i].addEventListener(\"click\", function() {"
echo "    var current = document.getElementsByClassName(\"active\");"
echo "    current[0].className = current[0].className.replace(\" active\", \"\");"
echo "    this.className += \" active\";"
echo "  });"
echo "}"
echo "function myFunction() {"
echo "  var x = document.getElementById(\"myTopnav\");"
echo "  if (x.className === \"topnav\") {"
echo "    x.className += \" responsive\";"
echo "  } else {"
echo "    x.className = \"topnav\";"
echo "  }"
echo "}"
echo "function myData() {"
echo "  var input, filter, table, tr, td, i, txtValue;"
echo "  input = document.getElementById(\"myInput\");"
echo "  filter = input.value.toUpperCase();"
echo "  table = document.getElementById(\"myTable\");"
echo "  tr = table.getElementsByTagName(\"tr\");"
echo "  for (i = 0; i < tr.length; i++) {"
echo "  td = tr[i].getElementsByTagName(\"td\")[0];"
echo "    if (td) {"
echo "      txtValue = td.textContent || td.innerText;"
echo "      if (txtValue.toUpperCase().indexOf(filter) > -1) {"
echo "        tr[i].style.display = \"\";"
echo "      } else {"
echo "        tr[i].style.display = \"none\";"
echo "      }"
echo "    }"
echo "  }"
echo "}"
echo "function mySecao() {"
echo "  var input, filter, table, tr, td, i, txtValue;"
echo "  input = document.getElementById(\"myInputsecao\");"
echo "  filter = input.value.toUpperCase();"
echo "  table = document.getElementById(\"myTable\");"
echo "  tr = table.getElementsByTagName(\"tr\");"
echo "  for (i = 0; i < tr.length; i++) {"
echo "  td = tr[i].getElementsByTagName(\"td\")[1];"
echo "    if (td && tr[i].style.display != \"none\") {"
echo "      txtValue = td.textContent || td.innerText;"
echo "      if (txtValue.toUpperCase().indexOf(filter) > -1) {"
echo "        tr[i].style.display = \"\";"
echo "      } else {"
echo "        tr[i].style.display = \"none\";"
echo "      }"
echo "    }"
echo "  }"
echo "}"
echo "</script>"
echo "</body>"
echo "<p><center>Atualizado em: $atualiza</center></p>"
echo "<p><center><input type=\"text\" id=\"myInput\" onkeyup=\"myData();mySecao()\" placeholder=\"Pesquise por dia. Ex.: 1970-12-31\" title=\"Pesquise por dia. Ex.: 1970-12-31\"></center></p>"
echo "<p><center><input type=\"text\" id=\"myInputsecao\" onkeyup=\"myData();mySecao()\" placeholder=\"Pesquise por seção: Ex.: Seção 1\" title=\"Pesquise por seção: Ex.: Seção 1\"></center></p>"
echo " "
echo "<center><table id=myTable style=width:65%>"
echo "<tr style=\"background-color: #DCDCDC;\" aling>"
echo "    <th style=\"text-align:center\"> DATA </th>"
echo "    <th style=\"text-align:center\"> SEÇÃO </th>"
echo "    <th style=\"text-align:center\"> GN4 </th>"
echo "  <th style=\"text-align:center\"> PORTAL </th>"
echo "</tr>"


hoje=`date +%d`
for dia in $( eval echo {"$hoje"..1});
do
        if [ $dia -lt 10 ]
        then
                dia=0$dia
        else
                echo "ok" > /dev/null
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

                get1=`/bin/curl -G --silent -XGET 'https://portal-homol.in.gov.br/leiturajornal' --data-urlencode "data=$dia-$mes-$ano" --data-urlencode "secao=$secao" | grep "pubOrder"`
                count=`echo "$get1" | sed -r '/^\s*$/d' | wc -l`

                if [ $count -ne 0 ]
                then
                        quantidadeportal=`echo "$get1" | python -m json.tool | grep 'numberPage' | wc -l`
                else
                        quantidadeportal=`echo 0`
                fi

                echo "<tr>"
                echo "<td style="text-align:center">$data</td>"
                echo "<td style="text-align:center">$nome</td>"
                echo "<td style="text-align:center">$quantidadegn4</td>"
                echo "<td style="text-align:center">$quantidadeportal</td>"
                echo "</tr>"

                rm -rf /opt/kafka-monitor/logs/messages-html-$data-1.log
        done
        rm -rf /opt/kafka-monitor/logs/messages-html-$data.log
done

echo "</table></center>"
echo "</html>"
