# ADR-0001 : Utiliser Traefik comme reverse proxy

Date : 2026-10-06
Statut : Accepté
Décideurs : équipe infra

## Contexte

- L'équipe héberge une quinzaine de services en conteneurs Docker sur deux serveurs.
- De nouveaux services sont ajoutés chaque mois : chaque ajout demande aujourd'hui une modification manuelle de la configuration du proxy.
- Le renouvellement des certificats TLS est fait à la main et a déjà provoqué une coupure.
- L'équipe infra connaît bien Nginx, pas Traefik.

## Options envisagées

### 1. Nginx

- (+) Bien connu de l'équipe, très documenté, stable.
- (+) Aucune formation ni migration.
- (−) Chaque nouveau service demande un nouveau bloc de configuration écrit à la main, puis un rechargement.
- (−) Pas de gestion intégrée des certificats : il faut ajouter et maintenir un outil comme certbot et sa planification.

### 2. Traefik

- (+) Détecte les conteneurs Docker grâce à leurs labels : un nouveau service est publié sans toucher à la configuration du proxy.
- (+) Demande et renouvelle les certificats TLS automatiquement (Let's Encrypt).
- (−) Inconnu de l'équipe : temps de formation à prévoir.
- (−) Doit lire le socket Docker pour détecter les conteneurs, ce qui est sensible en sécurité.
- (−) La détection se fait par serveur : il faut une instance par serveur.

## Décision

Nous utilisons Traefik comme reverse proxy, avec une instance sur chacun des deux serveurs.

Les deux problèmes actuels (ajout mensuel de services, renouvellement manuel des certificats) sont traités nativement par Traefik, alors qu'ils demandent de l'outillage supplémentaire avec Nginx. La coupure déjà subie pèse plus lourd que le coût de formation.

## Conséquences

Positives :

- (+) Plus de renouvellement manuel des certificats : le risque de coupure pour certificat expiré disparaît.
- (+) Ajouter un service revient à ajouter des labels dans son fichier Compose, dans la même PR.
- (+) La configuration du routage est versionnée avec chaque service.

Négatives :

- (−) L'équipe doit se former à Traefik ; pendant ce temps, le diagnostic des incidents sera plus lent.
- (−) Migration à planifier service par service depuis Nginx, avec retour arrière possible.
- (−) L'accès au socket Docker doit être limité (lecture seule, ou proxy de socket).
- (−) Deux instances à maintenir et à garder cohérentes, une par serveur.
- (−) Le stockage des certificats (`acme.json`) devient un fichier critique à sauvegarder et à protéger.
