Projet de programmation en Prolog
=================================


Partie 1 : tester la non transitivité d'une liste de dés
--------------------------------------------------------

Le code est dans le fichier `src/check.pl`. La commande `make part1` compile le
fichier et lance un interpréteur prolog qui connaît les prédicats suivants :

- `check_dice/1` prend une liste de dés avec toutes ses faces instanciées et
  renvoie `true` si et seulement si la liste des dés est non transitive.

- `beats/2` attends deux dés et teste si le premier bat le second avec
  probabilité > 1/2.


Partie 2 : générer des listes de dés non transitifs
---------------------------------------------------

Le code est dans le fichier `src/generate.pl`. La commande `make part2` compile
le fichier et lance un interpréteur prolog qui connaît les prédicats suivants :

- `dice/3` tel que `dice(N, S, L)` génère des listes de `N` dés non transitifs à
  `S` faces. Les constantes `N` ne doivent pas nécessairement être instanciées.

- `dice_constraints/3` fait exactement la même chose sans le backtracking :
  permet de visualiser les contraintes qu'on génère dans `dice/3`.


### Simplification du problème

On voit les dés comme des ensembles de faces et non des listes, on casse donc
une symétrie en imposant que les faces soient ordonnées.

La liste des dés peut-être vue à permutation cyclique près. De plus on peut
demander à ce que les faces soient des entiers strictement positifs et que la
valeur 1 soit prise. On casse donc une autre symétrie en imposant que le dé qui
contient la face 1 soit en première position.

Voici une solution explicite pour S = 3 :

```
[
    [N,   N,   N  ],
    [N-1, N-1, N-1],
    ...
    [2,   2,   N+2],
    [1,   N+1, N+1]
]
```

Si S est un multiple de 3, il suffit de concaténer chaque dé S/3 fois avec lui
même pour obtenir une solution pour S.

Si S s'écrit 3k+1 ou 3k+2, il suffit de concaténer chaque dé k fois avec lui
même et de compléter avec des N+3 pour obtenir une solution pour S dès que
k ≥ 2.

Cela justifie qu'on cherche des solutions dans 1..N+3, pour le cas k = 1, on
constate que ça marche aussi.

Je n'ai pas implémenté l'algorithme qui donne cette solution explicite, ce n'est
pas très intéressant.


Partie 3 : recherche d'un optimum
---------------------------------

Le code est dans le fichier `src/optimal.pl`. La commande `make part3` compile
le fichier et lance un interpréteur prolog qui connaît les prédicats suivants :

- `optimal/3` tel que `optimal(N, S, L)` génère des solutions optimales au sens
  défini dans l'énoncé.

- `optimal_constraints/4` pose juste les contraintes et ne fait pas le
  backtracking. L'argument supplémentaire et l'entier `C` tel que le `p` de
  l'énoncé est `C / S*S`


### Cassons des symétries

De même que précédemment, les faces des dés sont triées par ordre croissant.

On peut justifier que les faces sont à valeur dans `{1, 2, ..., N*S}` :
- Il y a N*S faces au total donc au pire, N*S valeurs différentes sont prises
- Si une valeur ≤ N*S n'est pas prise, on peut tout décaler vers le bas sans
  changer les probabilités de victoires.

On peut demander à ce que toutes les faces de tous les dés soient distinctes :
Si une valeur est prise plusieurs fois, disons 1, il suffit de remplacer toutes
les occurences de 1 par 1+ε, 1+2ε, 1+3ε, etc avec ε assez petit. Ainsi on
transforme des anciennes égalités en vitoires (auquel cas on améliore la proba
P[A > B]) ou en défaites (ce qui ne change pas la proba P[A > B]). On peut
ensuite revenir sur les entiers car on a un nombre fini de valeurs.

Ainsi toutes les valeurs de 1 à NS sont prisent exactement une fois.

On peut demander à ce que le premier dé contienne la valeur 1 pour la même
raison que précédemment.
