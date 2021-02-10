#!/bin/sh
echo
echo
echo "Déploiement des stacks :"
echo
echo " 1) RESEAUX"
echo " 2) GROUPES DE SECURITE"
echo " 3) INSTANCE NAT"
echo " 4) BDD et REPLICA"
echo " 5) ELB et ASSG"
echo " 6) VPN"
echo " 0) QUITTER"
echo  "Entrez  1 2 3 4 5 ou  0 pour quitter"

while read -p "1)RESEAUX - 2)SG - 3)NAT - 4)BDD BDDR - 5)ELB-ASG-WP - 6)VPN - 0)QUITTER  " choix

do

case $choix in

		1) echo "Déploiement du réseau  : "
		   START_TIME=$SECONDS
		   aws cloudformation  deploy --template-file 1_reseau.yaml --stack-name network
		   ELAPSED_TIME=$(($SECONDS - $START_TIME))
		   echo "Stack réseau déployée en $ELAPSED_TIME secondes -> network"
		   echo ""

;;

		2) echo "Déploiement des groupes de sécurité : "
		   START_TIME=$SECONDS
		   aws cloudformation  deploy --template-file 2_SecurityGroups.yaml --stack-name SG
		   ELAPSED_TIME=$(($SECONDS - $START_TIME))
		   echo "Stack des Groupes de sécurité déployée en $ELAPSED_TIME secondes -> SG"
		   echo ""



;;

		3) echo " Déploiement de l'instance NAT : "
		   START_TIME=$SECONDS
		   aws cloudformation deploy --template-file 3_Nat_instance.yaml --stack-name NAT --capabilities CAPABILITY_NAMED_IAM --parameter-overrides KeyName=tp-terraform
		   ELAPSED_TIME=$(($SECONDS - $START_TIME))
		   echo "Stack Instance NAT déployée en $ELAPSED_TIME secondes -> NAT"
		   echo ""

;;

		4) echo " Déploiement des BDD: "
		   START_TIME=$SECONDS
		   aws cloudformation deploy --template-file 3_1_databases.yaml --stack-name DB --parameter-overrides DBName=wordpress  MasterUserName=wordpress MasterPassword=francis1965
		   ELAPSED_TIME=$(($SECONDS - $START_TIME))
		   echo "Stack base de données déployée en $ELAPSED_TIME secondes -> DB"
		   echo ""


;;

		5) echo "Déploiement de WORDPRESS"
		   START_TIME=$SECONDS
		   aws cloudformation deploy --template-file 4_1_ASG_ELB.yaml --stack-name ELBASG --capabilities CAPABILITY_NAMED_IAM --parameter-overrides KeyName=tp-terraform DBName=wordpress  MasterUserName=wordpress MasterPassword=francis1965
		   ELAPSED_TIME=$(($SECONDS - $START_TIME))
		   echo "Stack ELB ASG WORDPRESS déployée en $ELAPSED_TIME secondes -> ELBASG"
		   echo ""


;;

		6) echo "Annuler la configuration de la salle Baobab"


;;

		0) break

;;

		*) echo "saisie incorrecte"

esac
done