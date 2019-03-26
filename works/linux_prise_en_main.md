À partir de maintenant toutes les commandes seront tapées dans un terminal. Vous vous reporterez au cours pour la syntaxe des commandes utilisées (et les exemples).

# Naviguer dans les répertoires

1. Vous venez de vous connecter/de lancer un terminal, dans quel répertoire vous trouvez vous ?

2. Faites les manipulations suivantes

```
cd
pwd
cd /tmp
pwd
cd ~
pwd
```

3. Regardez le résultat, à quel répertoire le ~ correspond-il ?
On peut toujours aller dans son répertoire principal / répertoire personnel, son «home» (en jargon système) en faisant simplement `cd`.

4. Creez le répertoire `ingesnum` dans votre répertoir principal:

```
mkdir ~/ingesnum
cd ~/ingesnum
```
ou de façon équivalente avec :
```
cd
mkdir ingesnum
cd ingesnum
```

5. Afficher le contenu avec `ls`

6. Créez un fichier vide (dans le répertoire `~/ingesnum`) nommé foo.txt en tapant la commande: `touch foo.txt`
Réaffichez le contenu du répertoire

7. `ls` peut également être utilisé comme suit:

```
cd /tmp
ls ~/ingesnum
```

8. Faites `cd ~/ingesnum` pour vous assurez que vous êtes dans le bon répertoire avant de continuer ;)

9. Quel est le contenu du répertoire ?

10. Créez un répertoire `toto` puis réaffichez le contenu. (Du répertoire courant, pas du répertoire `toto`)

11. Effacez le répertoire `toto`, puis réaffichez son contenu

12. Essayer d'effacer le répertoire `toto` à nouveau. Que se passe t'il ?

13. Effectuez

```
cd /tmp
ls
ls -a
ls -l
```
vous pouvez également saisir `ls -a -l` ou encore `ls -al`

14. Quel est la différence d'affichage ? A quoi servent les options `-l` et `-a`

15. Supprimez le répertoire `ingesnum` et son contenu

```
cd ~
rm -Rf ingesnum
```

# Reproduction

1. En utilisant les commandes précédentes créez l'arborescence suivante.

```
          ~
    |-----|-----------|
  Algo   algo        tmp
    |     |----|
   TP1   TP1  TP2

```
