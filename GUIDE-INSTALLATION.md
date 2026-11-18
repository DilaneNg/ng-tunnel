# 🚀 NG TUNNEL — Guide d'installation

> **Version 1.0.0** · Auteur : **DilaneNg** · Licence : **GPL-3.0**
>
> Ce guide décrit l'installation complète de NG TUNNEL sur un VPS : panel terminal (`menu`), panel web (`ngpanel`), et les vérifications à faire avant et après l'installation.

---

## 📑 Sommaire

1. [Aperçu de l'installation](#1-aperçu-de-linstallation)
2. [Prérequis](#2-prérequis)
3. [Étape 0 — Publier le dépôt GitHub (obligatoire)](#3-étape-0--publier-le-dépôt-github-obligatoire)
4. [Installation express — une seule commande](#4-installation-express--une-seule-commande)
5. [Installation du panel web](#5-installation-du-panel-web)
6. [Premiers pas](#6-premiers-pas)
7. [Mise à jour](#7-mise-à-jour)
8. [Désinstallation](#8-désinstallation)
9. [Dépannage](#9-dépannage)
10. [Checklist post-installation](#10-checklist-post-installation)

---

## 1. Aperçu de l'installation

NG TUNNEL est composé de deux panneaux qui travaillent sur les mêmes fichiers de données :

| Composant | Rôle | Installé par | Commande |
|---|---|---|---|
| **Panel terminal** | Gestion SSH/ZiVPN/SlowDNS/HAProxy directement sur le VPS | `bootstrap.sh` ou `terminal-panel/install.sh` | `menu` |
| **Panel web** | Administration à distance, multi-clients, revendeurs (Node.js) | `bootstrap.sh` (optionnel) ou `web-panel/deploy/install.sh` | `ngpanel` |

**Chemins et services créés sur le serveur :**

| Élément | Emplacement |
|---|---|
| Dépôt local du projet | `/opt/ng-tunnel` |
| Base de données des comptes SSH | `/etc/ngtunnel/users.db` |
| Consommation de bande passante | `/etc/ngtunnel/bandwidth/<utilisateur>.usage` |
| Commande du panel terminal | `/usr/local/bin/menu` |
| Service limiteur (limite + bande passante) | `ngtunnel-limiter.service` (script : `/usr/local/bin/ngtunnel-limiter.sh`) |
| Service du panel web | `ngpanel.service` |
| Commande de maintenance du panel web | `/usr/local/bin/ngpanel` |
| Binaires udp-custom | `/root/udp` |

> ⚠️ **Important** : `terminal-panel/install.sh` remplace `/etc/ssh/sshd_config` par la configuration optimisée de NG TUNNEL (port **22**). Une sauvegarde horodatée est créée avant (`/etc/ssh/sshd_config.backup.<date>`) et la nouvelle configuration est validée par `sshd -t` avant redémarrage — en cas de configuration invalide, l'ancienne est restaurée automatiquement.

---

## 2. Prérequis

| Prérequis | Détail |
|---|---|
| **Système** | VPS Ubuntu 20.04/22.04+ ou Debian 11+ (architecture **x86_64** ou **ARM64**) |
| **Accès** | Compte **root** ou `sudo` |
| **Dépendances** | Installées automatiquement : `git`, Node.js 20 (panel web), `dnsutils`, `certbot`, `nginx` (mode nginx uniquement) |
| **Domaine** | Optionnel mais recommandé pour le panel web. Sans domaine, une IP est détectée automatiquement et un **certificat auto-signé** est utilisé (avertissement navigateur à accepter une fois) |
| **Ports** | `22` (SSH), `2045` (panel web, public, modifiable), `3000` (port interne Node, mode nginx uniquement). Le port d'écoute d'udp-custom est choisi lors de son installation depuis le menu |

**Configuration pare-feu** : ouvrez les ports que vous utilisez (22, 2045, ports des protocoles créés via le menu). Le menu sait ouvrir les ports dans `ufw` lorsqu'il est actif.

---

## 3. Étape 0 — Publier le dépôt GitHub (obligatoire)

Les scripts d'installation dépendent du dépôt GitHub **`DilaneNg/ng-tunnel`** :

- `bootstrap.sh` clone ce dépôt vers `/opt/ng-tunnel` ;
- le menu télécharge les binaires **udp-custom** depuis `github.com/DilaneNg/ng-tunnel/raw/main/udp/…`.

**Avant toute installation, publiez donc les fichiers du package sur ce dépôt :**

```bash
# 1. Créez le dépôt public « ng-tunnel » sur votre compte GitHub (DilaneNg)

# 2. Décompressez le package ng-tunnel.zip puis poussez son contenu :
cd ng-tunnel
git init
git add .
git commit -m "NG Tunnel v1.0.0"
git branch -M main
git remote add origin https://github.com/DilaneNg/ng-tunnel.git
git push -u origin main
```

**Vérifications avant de continuer :**

- [ ] `bootstrap.sh` est bien à la **racine** du dépôt ;
- [ ] le dossier `udp/` contient les deux binaires (`udp-custom-linux-amd64` et `udp-custom-linux-arm`) ;
- [ ] le dépôt est **public** (sinon le clone et le téléchargement des binaires échoueront).

---

## 4. Installation express — une seule commande

Sur un VPS vierge, connecté en root ou avec sudo :

```bash
curl -fsSL https://raw.githubusercontent.com/DilaneNg/ng-tunnel/main/bootstrap.sh | sudo bash
```

### Ce que fait le script, étape par étape

1. **Dépendances** : installe `git` si absent.
2. **Dépôt** : clone `https://github.com/DilaneNg/ng-tunnel.git` vers `/opt/ng-tunnel` (ou `git pull` si le dépôt y est déjà — la même commande sert à l'installation **et** à la mise à jour).
3. **Panel terminal** : exécute `terminal-panel/install.sh` :
   - copie `menu.sh` vers `/usr/local/bin/menu` ;
   - sauvegarde puis remplace `/etc/ssh/sshd_config` par la configuration du dépôt ;
   - valide la configuration (`sshd -t`), redémarre le service SSH (`sshd`/`ssh` selon la distribution) ;
   - exécute la configuration initiale du menu (`menu --install-setup`) : création de `/etc/ngtunnel`, groupe système, service **`ngtunnel-limiter.service`** (limites de comptes + suivi de bande passante), nettoyage des anciens banners SSH dynamiques ;
   - lance l'interface du tunnel.
4. **Panel web (question)** : `👉 Install/update the web panel too? (y/n)` — répondez `y` puis indiquez votre domaine (ou laissez vide pour utiliser l'IP du VPS). Le panel web s'installe alors automatiquement (voir section 5).
5. **Terminé** : le récapitulatif affiche les commandes `menu` et `ngpanel`.

> 💡 **Exécution sans terminal interactif** (CI, script automatisé) : le panel web est ignoré et un message l'indique. Installez-le ensuite manuellement :
> ```bash
> sudo bash /opt/ng-tunnel/web-panel/deploy/install.sh --domain panel.tondomaine.com
> ```

### Installation manuelle (sans bootstrap)

Si vous préférez installer composant par composant depuis un clone :

```bash
git clone https://github.com/DilaneNg/ng-tunnel.git ng-tunnel
cd ng-tunnel

# Panel terminal uniquement
cd terminal-panel
sudo bash install.sh

# Panel web uniquement (retour à la racine du projet)
cd ../web-panel
sudo bash deploy/install.sh
```

---

## 5. Installation du panel web

`web-panel/deploy/install.sh` est **entièrement interactif** — chaque question peut aussi être passée en option pour une installation non interactive.

### Mode interactif (défaut)

Le script pose les questions suivantes :

| Question | Défaut | Remarque |
|---|---|---|
| Nom de domaine | *(vide)* | Vide = détection automatique de l'IP publique → certificat **auto-signé** |
| Mode TLS | `1` | `1` = Nginx reverse proxy (recommandé) · `2` = Node gère lui-même le certificat, sans Nginx |
| Port public (HTTPS) | `2045` | Doit être libre — le script vérifie avec `ss` |
| Port interne Node | `3000` | Uniquement en mode nginx ; doit être différent du port public |
| Nom d'utilisateur admin | `admin` | |
| Mot de passe admin | *(généré)* | Vide = mot de passe fort généré et affiché dans le résumé final |
| Secret de session | *(généré)* | Vide = généré automatiquement |

Le script installe ensuite Node.js 20, `dnsutils`, `certbot` (+ `nginx` en mode 1), écrit le fichier `.env`, installe les dépendances (`npm install --omit=dev`), crée le service **`ngpanel.service`** et la commande **`ngpanel`**, obtient le certificat TLS (Let's Encrypt pour un domaine, avec détection Cloudflare ; auto-signé pour une IP), configure Nginx (mode 1), démarre le service et installe les hooks de renouvellement Certbot.

**Résumé final affiché :**

```text
✅ Deployment completed !
   Panel accessible at : https://panel.tondomaine.com:2045
   Admin username      : admin
   Admin password      : ********  (affiché en clair à l'écran)
```

### Mode non interactif (CI / automatisation)

Toutes les valeurs peuvent être passées en options :

```bash
sudo bash web-panel/deploy/install.sh \
  --domain panel.tondomaine.com \
  --tls-mode nginx \
  --port 2045 \
  --app-port 3000 \
  --admin-user admin \
  --admin-pass 'S3cur3Pass!' \
  --secret "$(openssl rand -hex 32)"
```

> 💡 En cas d'échec du certificat (DNS pas encore propagé, Cloudflare mal réglé), le service et la commande `ngpanel` sont déjà installés : corrigez le DNS puis relancez `ngpanel domain` ou `ngpanel tls-mode`.

---

## 6. Premiers pas

### Panel terminal — commande `menu`

```bash
menu
```

Depuis ce panneau : création/gestion des comptes SSH (WebSocket, UDP, TLS), SlowDNS, ZiVPN, HAProxy, udp-custom/badvpn, proxy SSL, PY SOCKS/WS, installation parallèle de 3x-ui, monitoring et désinstallation complète.

### Panel web — commande `ngpanel`

```bash
ngpanel status        # État du service
ngpanel logs          # Logs de l'application
ngpanel restart       # Redémarrer le service
ngpanel update        # Mettre à jour le panel
ngpanel domain <ndd>  # Changer de domaine
ngpanel port <port>   # Changer le port web
ngpanel tls-mode      # Changer de mode TLS (nginx / node)
ngpanel admin-user    # Changer l'identifiant admin
ngpanel admin-pass    # Changer le mot de passe admin
ngpanel secret        # Régénérer le secret de session
ngpanel backup        # Sauvegarde du système
ngpanel restore <f>   # Restaurer une sauvegarde
ngpanel uninstall     # Désinstallation complète du panel web
```

### Accès au panel web

Ouvrez `https://<domaine-ou-ip>:2045` et connectez-vous avec les identifiants admin. **Changez le mot de passe par défaut dès la première connexion** (via le panel ou `ngpanel admin-pass`).

### Synchronisation des deux panneaux

Les comptes créés dans l'un sont immédiatement disponibles dans l'autre :

| Donnée | Fichier partagé |
|---|---|
| Comptes SSH | `/etc/ngtunnel/users.db` |
| Bande passante SSH | `/etc/ngtunnel/bandwidth/<utilisateur>.usage` |
| Identifiants et quotas ZiVPN | `/etc/zivpn/config.json` · `/etc/zivpn/passwords_meta.json` |

---

## 7. Mise à jour

**Méthode recommandée** — relancez la même commande d'installation ; le bootstrap détecte les composants déjà présents et met à jour uniquement ce qui est nécessaire :

```bash
curl -fsSL https://raw.githubusercontent.com/DilaneNg/ng-tunnel/main/bootstrap.sh | sudo bash
```

**Par composant :**

```bash
cd /opt/ng-tunnel

# Panel terminal uniquement
bash terminal-panel/update.sh

# Panel web uniquement
bash web-panel/update.sh

# Ou manuellement après un git pull :
git pull
cp terminal-panel/menu.sh /usr/local/bin/menu && chmod +x /usr/local/bin/menu
cd web-panel && npm install && systemctl restart ngpanel   # npm seulement si package.json a changé
```

---

## 8. Désinstallation

### Panel web

```bash
ngpanel uninstall
```

### Panel terminal et tous les composants

Depuis le menu (`menu`), l'option de désinstallation supprime la commande `menu`, toutes les données de `/etc/ngtunnel`, le service `ngtunnel-limiter.service` et les services installés (badvpn, udp-custom, HAProxy, Nginx, ZiVPN). Elle propose aussi de supprimer les comptes SSH créés — action **irréversible**, confirmée en tapant `yes`.

Chaque protocole peut aussi être retiré individuellement depuis le sous-menu dédié (badvpn, udp-custom, ssl-tunnel, ZiVPN, PY SOCKS/WS, 3x-ui).

### Suppression du dépôt local

```bash
rm -rf /opt/ng-tunnel
```

---

## 9. Dépannage

| Symptôme | Cause probable | Solution |
|---|---|---|
| `Repository ... not found` au clone | Dépôt `DilaneNg/ng-tunnel` inexistant, privé, ou fichiers non poussés | Refaire l'[étape 0](#3-étape-0--publier-le-dépôt-github-obligatoire) |
| Échec du téléchargement udp-custom | Binaires absents du dépôt sur GitHub (`udp/`) | Vérifier que `udp/udp-custom-linux-amd64` et `udp/udp-custom-linux-arm` sont poussés sur la branche `main` |
| `The port 2045 seems to be already in use` | Port occupé par un autre service | Choisir un autre port, ou identifier le processus : `ss -ltnp \| grep 2045` |
| Certificat Let's Encrypt refusé | DNS non propagé, proxy Cloudflare actif sur une entrée DNS non compatible | Corriger le DNS puis relancer : `ngpanel domain` ou `ngpanel tls-mode` |
| Avertissement « certificat non approuvé » | Installation par IP (certificat auto-signé) | Comportement normal — accepter une fois, ou installer avec un vrai domaine |
| SSH invalide après modification | Configuration `sshd` rejetée par `sshd -t` | La sauvegarde `/etc/ssh/sshd_config.backup.<date>` est restaurée automatiquement par `install.sh` |
| Panel web inaccessible | Service arrêté ou port fermé | `systemctl status ngpanel` · `journalctl -u ngpanel -f` · ouvrir le port du pare-feu |
| Limites de comptes non appliquées | Service limiteur arrêté | `systemctl status ngtunnel-limiter` · `journalctl -u ngtunnel-limiter -n 15` |

---

## 10. Checklist post-installation

- [ ] Dépôt GitHub `DilaneNg/ng-tunnel` public et complet (`bootstrap.sh` à la racine, binaires dans `udp/`)
- [ ] `menu` fonctionne et le service `ngtunnel-limiter` est actif (`systemctl status ngtunnel-limiter`)
- [ ] Panel web accessible sur `https://<domaine>:2045`, mot de passe admin changé
- [ ] Ports ouverts dans le pare-feu (22, 2045, ports des protocoles)
- [ ] Placeholders `A_REMPLACER` remplacés par vos vrais liens dans **4 fichiers** : `README.md`, `web-panel/views/about.ejs`, `terminal-panel/ngtunnel.sh`, `terminal-panel/menu.sh`
- [ ] Sauvegarde créée : `ngpanel backup`

---

*NG TUNNEL v1.0.0 — fork de NOVA XTUNNEL (NOSTRA-DevOps), sous licence GPL-3.0 — © 2026 DilaneNg*
