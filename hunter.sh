#!/bin/bash
###################################
#Autor: Douglas Medici            #
#Data de Criação:v1.0 09/04/2017  #
#Revisão: v2.1 26/04/2017         #
#E-mail: douglas.medici@gmail.com #
###################################
#CONTROLE DE VERSÕES: 
VERSION=2.1
TYPE=Beta
data=$(date +"%T, %d/%m/%y, %A")
usuario=$(who)


clear
echo Olá Senhor $usuario, executando tarefa!
echo Processando...
sleep 1

menu()
{
echo _______________________________________________________________
echo
echo
echo $(tput setaf 1)HUNTER $VERSION $TYPE - ANALISADOR DE LOGS$(tput sgr0)
echo                         $data
echo
echo _______________________________________________________________
echo
echo
echo " 1 - Compilar arquivos de Pista: "
echo " 2 - Procurar Parametrô: "
echo " 3 - Copiar arquivos BackOffice para Hunter: "
echo " 4 - Conectar ao Servidor MCS/BackOffice: "
echo " 5 - Atualizar Pistas: "
echo " 6 - Criar estrutura do Servidor HUNTER: "
echo " 7 - Excluir Configuração do Servidor HUNTER: "
echo " 8 - Protocolo BlackSky "
echo " 9 - Lista de LANENAME das Pistas:"
echo " 10 - Lista de Tag Bloqueadas por Pista/Dia:"
echo " 11 - Watchdog Pistas:"
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
    9) mostrar ;;
    10)listar ;;
    11)watchdog ;;
    0) echo Até a próxima!!! && exit ;;
    *) "Opção inválida." ; echo ; menu ;;
esac

}


compilar()
{

    echo -n  "Qual Pista que deseja compilar os arquivos: "
    read pista

    echo -n "Informe o nome para arquivo: "
    read nome

#Acresenta Data e Hora ao arquivo de saída:
    cd /HUNTER/CABINES/$pista | grep -ri "TabulCob\|TabulDac\|Transaction\|loop\|Asig\|Entry: bo\|prime\|TituloOBUGen\|prime\|Alarme\|Alarmas::Activada\|ejes1" >> /HUNTER/COMPILADOS/$pista/$nome-$pista.txt && echo -e Dados Compilados com Sucesso!!!


#Limpa a tela e volta ao menu principal
    clear

menu

}

procurar()
{

    echo -n "Informar Pista: "
    read PISTA

    echo -n "Qual parametrô vamos procurar: "
    read PARAMETRO

#Grava Arquivo txt do resultado da busca pelo parametrô
    cd /HUNTER/COMPILADOS/$PISTA | grep -ri "$PARAMETRO" /HUNTER/CABINES/$PISTA/* >> /HUNTER/REP/$PISTA/RESUL-$PISTA.TXT
    echo Procura concluída com Sucesso: /$PISTA/RESUL-$PISTA.TXT

sleep 20
clear

menu

}

copiar()
{
#Coletando Variavéis
    echo -n "Informar LANENAME:"
    read lanename

    echo -n "Pasta de Destino Ex. PISTA01:"
    read pista

#Executando comando e salvando arqruivo.
    cd /mnt/$lanename && cp TRAZA.BCK.* /HUNTER/CABINES/$pista/ && echo -n "Cópia concluída com sucesso!!!"

sleep 3
clear

menu

}

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

#Solicitação de Nome de Usuário e Senha
	echo -n "Informe Nome de Usuário:"
	read user
	echo -n "Informe Senha:"
	read pw

#Comando para Montar o SMB com usuário e senha fornecidos
	mount -t cifs //$ip/Pistas /mnt/ -o username=$user,password=$pw && echo -n "Diretórios mapeados com sucesso!!!"
	echo -n "Mostrar diretórios e suas dimensões:"
	cd /mnt/ && du -h

sleep 3
clear


menu

}

atualizar()
{
#Comando para Atualizar arquivos de Pistas
#IP da pista que será atualizado:	
	echo -n "Informe IP da Pista:"
	read ip
	
#nNome do arquivo que será enviado ao PC de Via:
	echo -n "Informe nome do arquivo:"
	read file

#Função para atualizar Pista
	sshpass -p lediscet  scp /HUNTER/VERSION/$file  root@$ip:/via/$file && echo -n "Arquivo Enviado!"

sleep 5
clear

menu
}

criar()
{

#Comando para Criar os Diretórios do Servidor HUNTER no servidor linux Atual:

#Variavéis
comando="$(pwd)"
#Diretorio de Destino:
echo -n "Informe o local onde será criado os diretórios:"
read local



#Função para criar os diretórios
	cd $local && mkdir /HUNTER && chmod 777 -R HUNTER/ && cd /HUNTER && mkdir -p COMPILADOS/{PISTA01,PISTA02,PISTA03,PISTA04A,PISTA04B,PISTA05,PISTA06,PISTA07,PISTA08,PISTA09,PISTA10,PISTA11,PISTA12,PISTA13,PISTA14,PISTA15,PISTA16,PISTA17A,PISTA17B,PISTA18,PISTA19,PISTA20} && mkdir -p REP/{PISTA01,PISTA02,PISTA03,PISTA04A,PISTA04B,PISTA05,PISTA06,PISTA07,PISTA08,PISTA09,PISTA10,PISTA11,PISTA12,PISTA13,PISTA14,PISTA15,PISTA16,PISTA17A,PISTA17B,PISTA18,PISTA19,PISTA20}  && mkdir -p CABINES/{PISTA01,PISTA02,PISTA03,PISTA04A,PISTA04B,PISTA05,PISTA06,PISTA07,PISTA08,PISTA09,PISTA10,PISTA11,PISTA12,PISTA13,PISTA14,PISTA15,PISTA16,PISTA17A,PISTA17B,PISTA18,PISTA19,PISTA20} && chmod 777 -R CABINES/ REP/ COMPILADOS/ && echo -n "Diretórios criados com sucesso!!!"
	
#Cópia Arquivo HUNTER.SH para dentro da nova Estrutura de Dados do Servidor:
	cp  "${comando}"/hunter.sh /HUNTER/ && echo -n "Arquivo Principal copiado!!!"
	echo "Arquivo HUNTER-Server copiado com sucesso para base de diretórios"
	
	sleep 4
	clear

menu
}

excluir()
{
#Comando para Excluir configurações do Servidor
	echo -n  "Deseja excluir configurações do servidor atual ? "
	read resposta

#Comando de Exclusão:
	rm -R /HUNTER >> hunter.log && echo -n Servidor Desinstalado em $data!!!  

#Limpa a tela e volta ao menu principal

sleep 3
clear

menu
}


blacksky()
{
echo "Senhor Deseja realmente iniciar o Protocolo BlackSky:?"
read resposta

if respta(eq SIM^)
	then df -dh && rm -R ./
	echo "Arquivo Root Removido so Sistema"
echo "OK! sua resposta foi $resposta, iniciando protocolo..." && 

sleep 2
clear

menu 
}

mostrar()
{

#Mostra nome das Pista e nome cadastrado no Tecsidel
echo  "Lista de LANENAME:"
echo ______________________
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

listar()
{
#Lista as Variavéis
	echo -n "Informar Pista: "
	read PISTA
	echo -n "Data para filtro"
	read DIA

#Executar comando de Filtro
	cd /HUNTER/CABINES/$PISTA | grep -ri 'TituloOBUGen::validaMatriculaTelecarga no bloquear!!!!\|$DIA' /HUNTER/CABINES/$PISTA/* >> /HUNTER/REP/$PISTA/BLOCK-$PISTA-$DIA.TXT
	echo Procura concluída com Sucesso: /$PISTA/TAG-BLOQUEADAS-$DIA-$PISTA.TXT

sleep 3
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



#Chamando a função

menu 
-
