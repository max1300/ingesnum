# Droits d'accès

**A partir d'un utilisateur non privilégié**

- Vous est-il possible de faire une copie du fichier `/etc/passwd` ?
- Vous est-il possible de supprimer ou de modifier le fichier `/etc/passwd` ?
- Répeter ces tentatives en tant qu'utilisateur `root`.
- Expliquer la situation à l’aide de la commande `ls -l`.
- A l’aide de la commande `id`, vérifier votre identité et le(s) groupe(s) au(x)quel(s) vous appartenez.
- Créer un petit fichier texte (de contenu quelconque), qui soit lisible par tout le monde, mais non modifiable (même pas par vous).
- Créer un répertoire nommé `Secret`, dont le contenu est visible uniquement par vous même.
- Les fichiers placés dans ce répertoire sont-ils lisibles par d’autres membres de votre groupe?
- Créer un répertoire nommé `Inities` tel que les autres utilisateurs ne puissent pas lister son contenu mais puissent lire les fichiers qui y sont placés.

On obtiendra:
ls Connaisseurs
ls : Connaisseurs: Permission denied
cat Connaisseurs/toto
<...le contenu du fichier toto (s’il existe)...>
- Chercher dans le répertoire /usr/bin des exemples de commandes ayant la permission SUID.
- De quelle genre de commande s’agit-il ?

# Les utilisateurs

- Votre compte d'utilisateur est-il défini dans le fichier `/etc/passwd` ? Pourquoi ? Il y a-t-il d'autres alternatives ?
- Quel est le répertoire de connexion de l’utilisateur `root` ?
- Quel est le shell de l’utilisateur `root` ?
- Quelle est la particularité de l’utilisateur nobody?
- Quels sont les utilisateurs définis dans `/etc/passwd` qui font partie du même groupe que nobody ?

