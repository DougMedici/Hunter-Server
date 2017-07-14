#!/bin/bash
###################################
#Autor: Douglas Medici            #
#Data de Criação:v1.0 01/04/2017  #
#Revisão: v1 10/04/2017           #
#E-mail: douglas.medici@gmail.com #
###################################
#CONTROLE DE VERSÕES:
VERSION=7.0
TYPE=Beta
data=$(date +"%T, %d/%m/%y, %A")
who=$(who | grep pts/0)
hoje=$(date +"%Y_%m_%d")

##Declaração de Variaveis

clear
echo Olá Senhor Douglas, executando tarefa!
echo Processando...
sleep 1
clear

menu()
{
echo _______________________________________________________________
echo
echo
echo $(tput setaf 1)HUNTER $VERSION $TYPE - ANALISADOR DE LOGS$(tput sgr0)
echo
echo "Informações de Login:"
echo $data
echo $who
echo
echo _______________________________________________________________
echo
echo
echo " 1 - Compilar arquivos de Pista: "
echo
echo " 2 - Procurar Parametrô: "
echo
echo " 3 - Copiar arquivos BackOffice para Hunter: "
echo
echo " 4 - Conectar ao Servidor MCS/BackOffice: "
echo
echo " 5 - Atualizar Versão de Pista ou Arquivos de Controle: "
echo
echo " 6 - Criar estrutura do Servidor HUNTER: "
echo
echo " 7 - Excluir Configuração do Servidor HUNTER: "
echo
echo " 8 - Protocolo BlackSky "
echo
echo " 9 - Lista de LANENAME das Pistas:"
echo "     9.1 - Praça Principal "
echo "     9.2 - Alça 100 "
echo "     9.3 - Alça 200 "
echo
echo " 10 - Relatório de Tag Bloqueadas por Pista/Dia:"
echo
echo " 11 - Watchdog Pistas:"
echo
echo " 12 - SETH FAREJADOR"
echo
echo " 0 - Sair !!! "
echo
echo _______________________________________________________________
echo
echo -n "Escolha uma das opções acima: "
read op

case $op in
    1) compilar ;;
    2) procurar ;;
    3) copiar ;;
    4) mapear ;;
    5) atualizar ;;
    6) criar ;;
    7) excluir ;;
    8) blacksky ;;
    9) mostrar_all ;;
    9.1) mostrar_principal ;;
    9.2) mostrar_alca100 ;;
    9.3) mostrar_alca200 ;;
    10)relatorio_tag ;;
    11)watchdog ;;
	12)seth ;;
    0) echo Até a próxima!!! && exit ;;
    *) "Opção inválida." ; echo ; menu ;;
esac

}

#Bloco para Compilar
compilar()
{

    echo -n Informe PISTA para compilar os dados:
    read pista

    echo -n Informe o NOME  para arquivo:
    read nome

#Acresenta Data e Hora ao arquivo de saída:

    cd /HUNTER/CABINES/$pista | grep -ri "TabulCob\|TabulDac\|Transaction\|loop\|LOOP REP\|Asig\|Entry: bo\|prime\|TituloOBUGen\|prime\|Alarme\|Alarmas::Activada\|ejes1" >> /HUNTER/COMPILADOS/$pista/$nome-$pista.txt && echo -e Dados Compilados com Sucesso!!!


#Limpa a tela e volta ao menu principal
clear

menu
}

#Bloco procurar paramêtro
procurar()
{

    echo -n "Informar Lanename: "
    read lanename

    echo -n "Informe Pista:"
    read PISTA

    echo -n "Qual parametrô vamos procurar?:"
    read STRING_CAP

#Grava Arquivo txt do resultado da busca pelo parametrô
  grep "$STRING_CAP" /mnt/$lanename/TRAZA.BCK.* >> /HUNTER/REP/$PISTA/COMPILADOS/RCOMP-$PISTA.TXT
  echo -n Procura concluída com Sucesso: REP/$PISTA/COMPILADOS/RCOMP-$PISTA.TXT





sleep 20
clear

menu
}

#Bloco para Copiar
copiar()
{
#Coletando Variavéis
    echo -n "Informar LANENAME:"
    read lanename

    echo -n "Pasta de Destino Ex. PISTA01:"
    read pista

#Executando comando e salvando arqruivo.

    cd /mnt/$lanename && cp TRAZA.BCK.* /HUNTER/CABINES/$pista/&
    echo -n "Cópia em andamento!!!"
    echo -n ps -aux | grep "cp TRAZA.BCK"

sleep 5
clear

menu
}

#Conexão com Servidor BackOffic/MCS
mapear()
{
#Procedimento para mapear Diretorios do BackOffice e Servidor Hunter via SMB
    echo -n "Inicinado Mapeamento..."
    echo
    sleep 2
    echo

#Endereço IP do Servidor será Solicitado
echo -n "Informe IP do Servidor:"
read ip

echo -n "Informe Nome de Usuário:"
read user

echo -n "Informe Senha:"
read pw

mount -t cifs //$ip/Pistas /mnt/ -o username=$user,password=$pw && echo -n "Diretórios mapeados com sucesso!!!"
echo -n "Mostrar diretórios e suas dimensões:"
echo
sleep 1

cd /mnt/ && du -h

sleep 3
clear


menu
}

atualizar()
{
echo -n "Informe IP da Pista:"
read ip

echo -n "Diretorio de Origem do Arquivo: Ex: UPDATE_PISTA para Arquivos de Pista ou VERSION para Versão de Pista: "
read origem

tree $(pwd)/$origem
echo "Arquivo existentes no diretório"
echo -n "Informe um dos nomes acima, ou digite *.* para todos os arquivos do diretório: "
read file

#Função para atualizar Pista
sshpass -p lediscet  scp /$(pwd)/$origem/$file  root@$ip:/via/cstables/inbox
echo
echo -n "Arquivo(s) Enviado(s)!"

sleep 5
clear

menu
}

#Criar estrutura de Dados e Diretórios do Servidor HUNTER
criar()
{
comando="$(pwd)"

echo -n "Informe o local onde será criado os diretórios:"
read local

cd $local && mkdir /HUNTER && chmod 777 -R HUNTER/ && cd /HUNTER && mkdir -p COMPILADOS/{PISTA01,PISTA02,PISTA03,PISTA04A,PISTA04B,PISTA05,PISTA06,PISTA07,PISTA08,PISTA09,PISTA10,PISTA11,PISTA12,PISTA13,PISTA14,PISTA15,PISTA16,PISTA17A,PISTA17B,PISTA18,PISTA19,PISTA20} && mkdir -p REP/{PISTA01,PISTA02,PISTA03,PISTA04A,PISTA04B,PISTA05,PISTA06,PISTA07,PISTA08,PISTA09,PISTA10,PISTA11,PISTA12,PISTA13,PISTA14,PISTA15,PISTA16,PISTA17A,PISTA17B,PISTA18,PISTA19,PISTA20}  && mkdir -p CABINES/{PISTA01,PISTA02,PISTA03,PISTA04A,PISTA04B,PISTA05,PISTA06,PISTA07,PISTA08,PISTA09,PISTA10,PISTA11,PISTA12,PISTA13,PISTA14,PISTA15,PISTA16,PISTA17A,PISTA17B,PISTA18,PISTA19,PISTA20} && mkdir UPDATE_PISTA && mkdir VERSION && mkdir LOGs && mkdir SCRIPT && mkdir INFORMATION && chmod 777 -R /HUNTER && echo -n "Diretórios criados com sucesso!!!"
cp '${comando}'/hunter.sh /HUNTER/ && echo -n "Arquivo Principal copiado!!!"

sleep 2
clear

#Instalar Interface Gráfica

echo -n "Instalando pacotes..."
apt-get -y install screen
wget http://repo.ajenti.org/debian/key -O- | sudo apt-key add - && echo "deb http://repo.ajenti.org/ng/debian main main ubuntu" | sudo tee -a /etc/apt/sources.list
sudo apt-get  -y update && sudo apt-get -y install ajenti
sudo service ajenti restart && ufw allow 8000
echo -n "Interface Gráfica"








#Função para criar os diretórios


sleep 4
clear

menu
}

excluir()
{
echo -n  "Deseja excluir configurações do servidor atual ? "
read resposta
#Acresenta Data e Hora ao arquivo de saída:
rm -R /HUNTER && echo -n "Excluido com sucesso!!!"

#Limpa a tela e volta ao menu principal

sleep 3
clear

menu
}


blacksky()
{
echo "Senhor Deseja realmente iniciar o Protocolo BlackSky:?"
read resposta

echo "OK! sua resposta foi $resposta, iniciando protocolo..." &&

sleep 2
clear

menu
}


#Bloco que informa os LANENAME de todas as pistas da Concessão:

mostrar_all()
{
echo  "Lista de LANENAME:"
echo ______________________
echo
echo   "Praça Principal"
echo
echo  "LNC050101 - PISTA01"
echo  "LNC050102 - PISTA02"
echo  "LNC050103 - PISTA03"
echo  "LNC050104 - PISTA04A"
echo  "LNC050105 - PISTA04B"
echo  "LNC050106 - PISTA05"
echo  "LNC050107 - PISTA06"
echo  "LNC050108 - PISTA07"
echo  "LNC050109 - PISTA08"
echo  "LNC050110 - PISTA09"
echo  "LNC050111 - PISTA10"
echo  "LNC050112 - PISTA11"
echo  "LNC050113 - PISTA12"
echo  "LNC050114 - PISTA13"
echo  "LNC050115 - PISTA14"
echo  "LNC050116 - PISTA15"
echo  "LNC050117 - PISTA16"
echo  "LNC050118 - PISTA17A"
echo  "LNC050119 - PISTA17B"
echo  "LNC050120 - PISTA18"
echo  "LNC050121 - PISTA19"
echo  "LNC050122 - PISTA20"
echo ______________________
echo        "Alça 100"
echo
echo  "LNC050123 - PISTA01"
echo  "LNC050124 - PISTA02"
echo  "LNC050125 - PISTA03"
echo ______________________
echo        "Alça 200"
echo
echo  "LNC050126 - PISTA01"
echo  "LNC050127 - PISTA02"
echo  "LNC050128 - PISTA03"
echo ______________________

sleep 5

menu
}


mostrar_principal()
{
echo  "Lista de LANENAME:"
echo ______________________
echo
echo   "Praça Principal"
echo
echo  "LNC050101 - PISTA01"
echo  "LNC050102 - PISTA02"
echo  "LNC050103 - PISTA03"
echo  "LNC050104 - PISTA04A"
echo  "LNC050105 - PISTA04B"
echo  "LNC050106 - PISTA05"
echo  "LNC050107 - PISTA06"
echo  "LNC050108 - PISTA07"
echo  "LNC050109 - PISTA08"
echo  "LNC050110 - PISTA09"
echo  "LNC050111 - PISTA10"
echo  "LNC050112 - PISTA11"
echo  "LNC050113 - PISTA12"
echo  "LNC050114 - PISTA13"
echo  "LNC050115 - PISTA14"
echo  "LNC050116 - PISTA15"
echo  "LNC050117 - PISTA16"
echo  "LNC050118 - PISTA17A"
echo  "LNC050119 - PISTA17B"
echo  "LNC050120 - PISTA18"
echo  "LNC050121 - PISTA19"
echo  "LNC050122 - PISTA20"
echo
echo ______________________

sleep 3

menu
}


mostrar_alca100()
{
echo  "Lista de LANENAME:"
echo ______________________
echo
echo        "Alça 100"
echo
echo  "LNC050123 - PISTA01"
echo  "LNC050124 - PISTA02"
echo  "LNC050125 - PISTA03"
echo
echo ______________________

sleep 3

menu
}



mostrar_alca200()
{
echo  "Lista de LANENAME:"
echo ______________________
echo
echo        "Alça 200"
echo
echo  "LNC050126 - PISTA01"
echo  "LNC050127 - PISTA02"
echo  "LNC050128 - PISTA03"
echo
echo ______________________

sleep 3

menu
}

#Fim do bloco que mostra as pistas da concessão


#Bloco de Filtros para TAG
relatorio_tag()
{
echo -n "Informar Pista: "
read PISTA

echo -n "Data para filtro"
read DIA

cd /HUNTER/CABINES/$PISTA | grep -ri 'TituloOBUGen::validaMatriculaTelecarga no bloquear!!!!\|$DIA' /HUNTER/CABINES/$PISTA/* >> /HUNTER/REP/$PISTA/BLOCK-$PISTA-$DIA.TXT
echo Procura concluída com Sucesso: /$PISTA/TAG-BLOQUEADAS-$DIA-$PISTA.TXT

sleep 20
clear

menu
}

watchdog()
{
sh watchdog.sh&

sleep 2
clear


menu
}


#####Setor de Software: Seth Versão 1.0#####
#Variavéis
SCRIPT=SETH
VERSION_SETH=1.0


seth()
{
clear
sleep 1

menu2
}

menu2()
{
echo _______________________________________________________________
echo
echo
echo $(tput setaf 1) $SCRIPT $TYPE $VERSION_SETH - FAREJADOR$(tput sgr0)
echo
echo "Informações de Login:"
echo $data
echo $who
echo
echo _______________________________________________________________
echo  "Escolha uma Opção:"
echo
echo " 1 - Compilar dados por Dia: "
echo
echo " 2 - Compilar dados por Mês: "
echo
echo " 3 - Compilar dados por Ano: "
echo
echo " 4 - Visualizar Diretórios REP:"
echo
echo " 5 - Volta ao HUNTER !!!"
echo
echo " 0 - Sair !!! "
echo _______________________________________________________________
echo -n "Escolha a opção desejada: "
read op
case $op in
    1) compilar_dia ;;
    2) compilar_mes ;;
    3) compilar_ano ;;
	4) comando_tree ;;
	5) menu;;
    0) echo Até a próxima!!! && exit ;;
    *) "Opção inválida." ; echo ; menu ;;
esac


}

compilar_dia()
{

#Compila as Opções nos diretorios corretos

echo -n "Informe LANENAME: "
read LANENAME

echo -n "Informe nome do diretório PISTA equilavente ou LANENAME:"
read PISTA

echo -n  "Informe DIA(Exemplo 01/01/2017):"
read DIA

echo -n "Qual parametrô vamos procurar: "
read PARAMETRO

echo -n "NOME DIA para Arquivo:"
read NAME_DAY


#Grava Arquivo txt do resultado da busca pelo parametrô

   cd /mnt/$LANENAME/ &&  cat TRAZA.BCK.* | awk '{if (($1) >= '$DIA' && ($1) <= '$DIA') print}' | grep $PARAMETRO >> /HUNTER/REP/$PISTA/COMPILADOS/$PARAMETRO-$PISTA-$NAME_DAY.TXT
   echo Procura concluída com Sucesso: /HUNTER/REP/$PISTA/COMPILADOS/$PARAMETRO-$PISTA-$NAME_DAY.TXT

sleep 2
clear

menu2
}


compilar_mes()
{

#Compila as Opções nos diretorios corretos

echo -n "Informe PISTA: "
read PISTA

echo -n  "Informe Mês(Exemplo /01/2017):"
read MES

echo -n "Qual parametrô vamos procurar: "
read PARAMETRO

echo -n "NOME MES para Arquivo:"
read NAME_MOTH

#Grava Arquivo txt do resultado da busca pelo parametrô

   cd /HUNTER/REP/$PISTA/COMPILADOS/ &&  grep -ri "$MES" RCOMP-$PISTA.TXT >> /HUNTER/REP/$PISTA/COMPILADOS/RCOMP-$PISTA-$NAME_MOTH.TXT
   echo Procura concluída com Sucesso: /$PISTA/COMPILADOS/RCOMP-$PISTA-$MES.TXT

 sleep 2
clear

menu2
}

compilar_ano()
{

#Compila as Opções nos diretorios corretos

echo -n "Informe PISTA: "
read PISTA

echo -n  "Informe ANO(Exemplo /2017):"
read ANO

echo -n "Qual parametrô vamos procurar: "
read PARAMETRO

echo -n "NOME ANO para Arquivo:"
read NAME_AGE

#Grava Arquivo txt do resultado da busca pelo parametrô

   cd /HUNTER/REP/$PISTA/COMPILADOS/ &&  grep -ri "$ANO" RCOMP-$PISTA.TXT >> /HUNTER/REP/$PISTA/RCOMP-$PISTA-$NAME_AGE.TXT
   echo Procura concluída com Sucesso: /REP/$PISTA/COMPILADOS/RCOMP-$PISTA-$ANO.TXT

 sleep 2
clear

menu2
}

comando_tree()
{

cd $(pwd)/REP && tree

sleep 10
clear

menu2
}


#Armazenamento de Log de execução:
hora=$(date +"%H:%M:%S %Z")
echo -ne "[$hora] Servidor executado, pelo Usuário [$who].\r\n" >> /HUNTER/LOGs/log_hunter.$hoje.txt


#Chamando a função do Menu:

menu
-
