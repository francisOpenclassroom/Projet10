#!/bin/sh
echo
echo
echo "Déploiement des stacks :"
echo
echo " 1) RESEAUX BASE"
echo " 2) VPN NAT"
echo " 3) INTRANET"
echo " 4) GROUPE DE SECURITE"
echo " 5) BASE DE DONNEES"
echo " 6) WORDPRESS"
echo " T) TOUT DEPLOYER"
echo " 0) QUITTER"

echo  "Entrez  1 2 3 4 5 6 7 ou  0 pour quitter"

while read -p "1)RESEAUX - 2)VPN-NAT - 3)INTRANET - 4)SG - 5)BDD - 6)WORDPRESS - S)SUPPRIMER - 0)QUITTER  " choix

do

case $choix in

		1) echo "Déploiement du réseau  : "
		   START_TIME=$SECONDS
		   aws cloudformation  deploy --template-file 1_reseau_base.yaml --stack-name network
		   ELAPSED_TIME=$(($SECONDS - $START_TIME))
		   echo "Stack réseau déployée en $ELAPSED_TIME secondes -> network"
		   echo ""

;;

		2) echo "Déploiement de l'instance VPN NAT : "
		   START_TIME=$SECONDS
		   aws cloudformation  deploy --template-file 2_Nat_VPN.yaml --stack-name NAT
		   ELAPSED_TIME=$(($SECONDS - $START_TIME))
		   echo "Stack VPN NAT déployée en $ELAPSED_TIME secondes -> NAT"
		   echo ""



;;

		3) echo " Déploiement de l'instance INTRANET : "
		   START_TIME=$SECONDS
		   aws cloudformation  deploy --template-file 3_Intranet.yaml --stack-name INTRANET
		   ELAPSED_TIME=$(($SECONDS - $START_TIME))
		   echo "Stack Instance INTRANET déployée en $ELAPSED_TIME secondes -> INTRANET"
		   echo ""

;;

		4) echo " Déploiement des Groupes de sécurité: "
		   START_TIME=$SECONDS
		   aws cloudformation  deploy --template-file 4_Groupe_securite.yaml --stack-name SG
		   ELAPSED_TIME=$(($SECONDS - $START_TIME))
		   echo "Stack des groupes de sécurité déployée en $ELAPSED_TIME secondes -> SG"
		   echo ""


;;

		5) echo "Déploiement des BDD"
		   START_TIME=$SECONDS
		   aws cloudformation deploy --template-file 5_Databases.yaml --stack-name DB --parameter-overrides DBName=wordpress  MasterUserName=wordpress MasterPassword=francis1965
		   ELAPSED_TIME=$(($SECONDS - $START_TIME))
		   echo "Stack des Base de données déployée en $ELAPSED_TIME secondes -> ELBASG"
		   echo ""


;;

		6) echo "Déploiement de WORDPRESS"
		   START_TIME=$SECONDS
		   aws cloudformation deploy --template-file 6_wordpress.yaml --stack-name worpdress --capabilities CAPABILITY_NAMED_IAM --parameter-overrides KeyName=tp-terraform DBName=wordpress  MasterUserName=wordpress MasterPassword=francis1965
		   ELAPSED_TIME=$(($SECONDS - $START_TIME))
		   echo "Stack WORDPRESS déployée en $ELAPSED_TIME secondes -> wordpress"
		   echo ""

;;

    T) echo "Déploiement de toutes les stacks"
       START_TIME=$SECONDS
		   aws cloudformation  deploy --template-file 1_reseau_base.yaml --stack-name network
		   aws cloudformation  deploy --template-file 2_Nat_VPN.yaml --stack-name NAT
		   aws cloudformation  deploy --template-file 3_Intranet.yaml --stack-name INTRANET
		   aws cloudformation  deploy --template-file 4_Groupe_securite.yaml --stack-name SG
		   aws cloudformation deploy --template-file 5_Databases.yaml --stack-name DB --parameter-overrides DBName=wordpress  MasterUserName=wordpress MasterPassword=francis1965
		   aws cloudformation deploy --template-file 6_wordpress.yaml --stack-name worpdress --capabilities CAPABILITY_NAMED_IAM --parameter-overrides KeyName=tp-terraform DBName=wordpress  MasterUserName=wordpress MasterPassword=francis1965

		   ELAPSED_TIME=$(($SECONDS - $START_TIME))
		   echo "Stacks déployées en $ELAPSED_TIME secondes"
		   echo ""


;;

		0) break

;;

		*) echo "saisie incorrecte"

esac
done