# Linux - Prise en main

À partir de maintenant toutes les commandes seront tapées dans un terminal. Vous vous reporterez au cours pour la syntaxe des commandes utilisées (et les exemples).

## Naviguer dans les répertoires

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

## Reproduction

1. En utilisant les commandes précédentes créez l'arborescence suivante.

```
          ~
    |-----|-----------|
  Algo   algo        tmp
    |     |----|
   TP1   TP1  TP2

```

2. Se placer dans le répertoire `algo/TP1` et y créer un fichier `bar.txt` vide.

3. Supprimer le fichier `bar.txt` et tout nettoyer

## Afficher du texte

Pour tester les commandes suivantes nous allons utiliser des fichiers qui se trouvent dans `/etc/dictionaries-common`
Placez vous dans ce répertoire et:

1. Tapez

```
ls -l
cat words
cat words words
```

Que fait la commande `cat` ? Peut-on visualiser de gros fichiers ?

2. Utilisation de `less`

`less words`

Ensuite:
- Tapez sur la touche `espace` (x3)
- Tapez sur la touche `b` (x2)
- Tapez sur la flèche du haut
- Tapez sur la touche `h` (Regardez 30s et continuez)
- Tapez sur la touche `q` (pour sortir de help)
- Tapez sur la touche `q` (Pour sortir de `less`)

Que fait `less` lorsque l'on saisi `/quelquechose`

3. Comparez `less` et `more`

## Recherche

Toujours dans le répertoire `/etc/dictionaries-common`

1. Que fait la commande `wc` <nomfichier> et ses options `-l` et `-w`
2. Que fait la commande `grep`:
    `grep house words`
    `grep maison words`

## Édition de fichier

Il existe plusieurs éditeurs de texte, les plus connus sont sans doute `vi(m)` et `emacs`Les systèmes Debian quant à eux utilisent par défaut `nano`

Ouvrez un fichier que vous nommez comme vous le souhaitez.

1. Écrire vos noms et prénoms, sauver et quitter l'éditeur.
2. Vérifier à l'aide de `less` que ce fichier contient bien ce que vous y avez écrit.
3. Quelle taille a se fichier ?

## Rechercher des fichiers dans un répertoire

1. Effectuez

```
find /etc
find /etc -name "*.d"
find /etc -name "*.cfg" -ls
ls -R /etc
```

2. Que signifie l'étoile ?
3. A quoi sert l'option `-name`
4. Commentez la différence entre `ls -R` et `find`
5. Testez la commande `find /etc -exec wc {} +` et ensuite `find /etc -name "*.cfg" -exec wc {} +`

6. Que fait l'option `-exec` ?

7. Que fait l'option `-iname` ?

## Entrées / sorties standard, redirection et «tubes»

1. Que fait la commande `sort` (Indice: elle porte bien son nom ;) ) ?
2. Essayer
```
sort
a
c
d
```
puis taper `Ctrl` + `D`

3. Essayons à présent de trier les chiffres 2, 11, 1 puis expliquer pourquoi 11 est considéré comme inférieur à 2. Comment effectuer un tri numérique ?

La commande `sort` a lu **l'entrée standard** au lieu d'un fichier.

Ces entrées et sorties standard peuvent être redirigées.

- La sortie peut être écrite dans un fichier et non pas affichée (avec `>`)
- La sortie peut être ajoutée à la fin d'un fichier et non pas affichée (avec `>>`)
- L'entrée d'une commande peut-être prise à partir d'un fichier et pas du clavier (avec `<`)
- La sortie d'un programme devient l'entrée d'un autre programme (avec un tube `|` ou pipe)

### La sortie standard

1. Faites les manipulations suivantes:
```
cd ~/ingesnum
echo foo
echo foo > fichier
cat fichier
echo toto
echo toto > fichier
cat fichier
```
Vous aurez constaté que le deuxième `echo` écrase le contenu du fichier.

2. Avec `>>` on peut ajouter à la fin d'un fichier sans écraser son contenu.

```
echo foo >> fichier2
cat fichier2
echo toto >> fichier2
cat fichier2
```

3. A l'aide de `sort`, faire en sorte de générer un fichier `file.sorted` où les nombres 11,2 et 1 sont dans l'ordre croissant.

4. Tapez:

```
sort < file.sorted
sort < file.sorted > file2.sorted
cat file2.sorted
```

5. Il est possible de comparer 2 fichiers avec la commande `diff`
Exemple: `diff file.sorted file2.sorted`

### Le tube (pipe)

1. Visualiser le nombre de lignes qui contient le chiffre 1 dans le fichier `file.sorted`
2. Compter le nombre de lignes de ce fichier
3. Comment faire pour compter le nombre de lignes qui contiennet le chiffre 1 dans `file.sorted` ?

4. Le jeu des différences, exécuter les commandes:

```
find /etc | grep cfg
ls -R /etc | grep cfg
```
Que constatons nous ?

## Commandes utiles

`gzip` et `tar`

1. À l'intérieur d'un répertoire `Systeme/dossier_1`, créer un répertoire nommé `toto` contenant deux fichiers `titi.txt` contenant le mot `tata`  et `tata.txt` contenant `titi`

2. Vérifiez le contenu de vos fichiers

3. Créer une archive du répertoire `toto`
```
tar -cfv toto.tar toto
ls -l toto.tar
tar -tvf toto.tar
```

4. Créer un autre répertoire `Systeme/dossier_1/archive` et mettez y l'archive et désarchivez la (`tar -xvf`). Supprimer pour finir le dossier `Systeme/dossier_1/toto`

5. Compressez l'archive tar à l'aide de la commande `gzip` (option `-9`). Vérifier la taille de votre archive compressée par rapport à votre archive d'origine.

Il est possible d'allier le meilleur des deux en utilisant l'option `-z` de la commande `tar`: `tar -cvfz toto.tgz toto`






