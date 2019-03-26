# Shell

## Pratique des variables du shell

Expérimentons:

1. Affectation des variables (notez qu'il n'y a pas d'espace avant et après le caractère égal)

```
a=10 ; b=a; echo $b
b=$a ; echo $b ; echo "$b"
a=3; echo $b
```

2. Affectation des variables et affectation du résultat

```
datedujour=$(date)
echo $datedujour
datedujour=la date du jour est $(date)
datedujour='la date du jour est $(date)'
echo $datedujour
datedujour=" la date du jour est $(date)"
echo $datedujour
```

L'anti-quote `'` est équivalent à `$(....)`

## Variables locales, portée, commande `export`

1. Tapez les commandes suivantes

```
b=1
echo $b
echo $$ # affiche le PID du processus du shell (son numéro)
bash
echo $$ # vous êtes dans un nouveau shell
echo $b # b n'est visible que sur le premier shell
exit # quitter le deuxième shell
echo $$ # vous êtes de nouveau sur le premier shell
export b
bash
echo $$ # vous êtes dans un nouveau shell
echo $b
exit
```

2. Que fait `export` Pourquoi n'exporte t'on pas toujours toutes les variables ?

## Commande `expr`

```
export a=10 ;
export b=5;
echo $a '+' $b
expr $a '+' $b
echo expr $a '+' $b
echo 'expr $a '+' $b'
echo $(expr $a '+' $b)
```

## Commandes utiles

1. Regarder ce que fait `ping google.fr`

2. Récupérer ce fichier avec la commande `wget https://github.com/gfaivre/ingesnum/blob/master/works/04-shell.md`

## Script simple

1. Dans un terminal taper la commande affichant "Bonjour !"
2. Copiez/Coller cette commande dans un fichier nommé `hello.sh` en rajoutant en haut du fichier `#!/bin/bash`
3. Rendre le fichier exécutable
4. L'exécuter `./hello.sh`
5. Utiliser la variable `$USER` dans le script pour que le script dise bonjour à l'utilisateur.

### Les paramètres

Dans un nouveau fichier `param.sh` ajouter

```
#!/bin/bash
echo '$1' = $1
echo '$2' = $2
echo '$*' = $*
echo '$#' = $#
```

Lancer ensuite le script en lui ajoutant des paramètres (peu importe lesquels)

### Test et valeurs de retour

1. Dans un fichier `dedans.sh `

```
#!/bin/bash
if grep $1 $2
then
echo $? : $1 se trouve dans $2
else
echo $? : $1 ne se trouve pas dans $2
fi
```

2. Combien de paramètres prend ce script ?
3. Créer un fichier `grain.txt` contenant le mot grain
4. Exécuter:

```
./dedans.sh grain grain.txt
./dedans.sh autre grain.txt
./dedans.sh autre fichierquinexistepas.txt
```

5. Que contient la variable `$?` dans chacun des cas ?
6. Que se passe t'il si on exécute `./dedans.sh mot` (avec un seul paramètre) ?

### Boucle `for`

Créer et rendre exécutable le script suivant:

```
!/bin/bash
for i in *
do
    echo $i
done
```
Expliquez, puis remplacez l’étoile par `$(ls -l /etc/pass*)`.

### Boucle `while`

```
#!/bin/bash
b=0
while [ $b -le 5 ]
do
echo nom $b
  b=$(expr $b + 1)
done
```

### Test

Bash propose un mécanisme de test d'expressions régulières.

`[[ $var =~ expr_reg ]]`

Cette expression retourne 0 si la variable correspond à l'expression régulière.

```
#!/bin/bash
if [[ $1 =~ [0-9] ]]
then
    echo "le parametre $1 a un chiffre"
else
    echo "paf"
fi
```

