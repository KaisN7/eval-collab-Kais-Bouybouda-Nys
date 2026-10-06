# AGENTS.md

Consignes pour les assistants et agents IA qui travaillent sur ce dépôt.

## Contexte

- Dépôt de configuration et de documentation d'une infrastructure : une quinzaine de services en conteneurs Docker, sur deux serveurs, derrière un reverse proxy Traefik (voir `docs/adr/0001-choix-du-reverse-proxy.md`).
- Structure :
  - `README.md` : présentation, prérequis, contribution
  - `docs/adr/` : décisions d'architecture, modèle dans `0000-modele.md`
  - `.github/CODEOWNERS` : propriétaires du dépôt
- Langue : français pour la documentation, les issues et les PR.

## Vérifier avant de proposer

- Fichier Compose modifié : `docker compose -f <fichier-compose> config --quiet`
- Script shell modifié : `bash -n <script.sh>`
- Documentation modifiée : vérifier que les liens relatifs pointent vers des fichiers existants.
- Si une information manque, poser la question au lieu de l'inventer.

## Conventions

- Commits au format Conventional Commits : `type(scope): description`, à l'impératif, moins de 72 caractères.
- Branches : `<type>/<n° issue>-<description>`, créées depuis `main`.
- Toute modification passe par une PR vers `main`, avec `Closes #<n°>` et une description complète.
- Merge en **Squash and merge**, après review humaine.
- Une décision d'architecture = un nouvel ADR dans `docs/adr/`. Un ADR accepté ne se réécrit pas : on en crée un nouveau qui le remplace.
- Signaler l'usage de l'IA dans la PR (label `ai-assisted` ou trailer `Co-Authored-By`).

## Interdits

- Aucun secret dans le dépôt (mot de passe, jeton, clé privée) : utiliser un fichier `.env` ignoré par Git.
- Aucun commit ni push direct sur `main`.
- Ne jamais approuver ni merger une PR : la validation reste humaine.
- Ne jamais lancer de déploiement ni de commande sur les serveurs de production.
- Pas d'image en `latest`, pas de conteneur `privileged` ou exécuté en `root`.
- Ne pas publier d'autre port que 80 et 443 sur les serveurs.
- Ne pas désactiver la vérification des clés SSH (`StrictHostKeyChecking=no`).
