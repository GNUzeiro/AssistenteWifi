#!/bin/bash
clear

if [ $1 = "-h" ]; then
	echo "######################################"
	echo "#_Joni_Softwares________________2019_#"
	echo "#====================================#"
	echo "#         ASS_WIFI VERSAO 2.0        #"
	echo "#====================================#"
	echo "#   Modo de usar:                    #"
	echo "# $ sudo ./wifi placa                                   #"
	echo "#                                    #"
	echo "#====================================#"
	echo "#   PRESSIONE <ENTER> PARA COMEÇAR   #"
	echo "#                                    #"
	echo "######################################"
elif [ $1 = "-d" ]; then
	echo "ola mundo"
elif [ $1 = "--set" ]; then
	sleep 1
	clear
	
else
	sleep 1
	clear
	echo "========================================="
	echo " Assistente de conexão wifi"
	echo "========================================="
	sleep 1
	echo "[*] Buscando placas reconhecidas..."
	echo ""
	PLACAS=$(ifconfig -a | grep flags | sed "s/: flags.*$//")
	sleep 2
	echo $PLACAS
	sleep 1
	echo ""
	echo "[*] Digite a placa que deseja usar: "
	read ESCOLHIDA
	echo ""
	echo "[*] Derrubando placa..."
	sleep 1
	ifconfig $ESCOLHIDA down && echo " OK"
	echo ""
	echo "[*] Levantando placa..."
	sleep 1
	ifconfig $ESCOLHIDA up && echo " OK"
	echo ""
	
	killall dhclient 1> /dev/null 2> /dev/null
	killall wpa_supplicant 1> /dev/null 2> /dev/null

	echo "[*] Listando redes..."
	echo ""
	sleep 1
	iwlist $ESCOLHIDA scan | sed -n '/Cell */{N;N;N;N;N;p;}'
	echo ""
	echo "[*] Digite o nome da rede: "
	read REDE
	sleep 1
	echo ""
	echo "[+] Conectando a rede $REDE"
	echo "[-] Senha: "
	read SENHA
	if [ $SENHA = "--brute" ]; then
		sleep 1
		echo "[*] Digite o nome/caminho do arquivo..."
		read WORD
		NUM_LINHAS=wc -l $WORD
		sleep 1
		echo "[*] Iniciar testes para as $NUM_LINNHAS possibilidades?"
		if [ $RESP = "sim" ]; then
			"[+] Começando..."
		else
			echo ""
		fi
	else
		echo ""
	fi
	
	sleep 1
	echo "[*] Deseja definir como rede padrão? s/n"
	read PADRAO

	if [ $PADRAO = "n" ]; then
		sleep 1
	else
		echo "$ESCOLHIDA\n$REDE\n$SENHA" > default.txt
	fi
	echo "==============================================="
	echo "[*] Gerando arquivo de configuração..."
	sleep 1
	echo "[*] Estabelecendo conexão..."
	sleep 1
	wpa_supplicant -i $ESCOLHIDA -D wext -c /etc/wpa_supplicant/wifi.config -B && echo "[OK] Conexão estabelecida"
	sleep 1
	echo "[*] Recebendo o endereço IP do servidor DHCP..."
	sleep 1
	echo "[OK] Conectado via DHCP."
	echo ""
	echo "CONECTADO A REDE $REDE"
fi
