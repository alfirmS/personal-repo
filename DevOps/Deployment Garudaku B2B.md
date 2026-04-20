
## 1. STAGING
---

### A. Job: Preparation Repo
- Setup SSH (ssh-agent, private key, known_hosts)
- Connect ke server via SSH
- Menjalankan perintah Git:
    - `remote prune`
    - `fetch`
    - `checkout` branch tertentu
    - `pull`
    - `submodule update`

***Variasi Environment***

Terdapat banyak job dengan pola yang sama untuk environment berbeda:

- `prepare-repo` → staging utama
- `prepare-repo-li54`
- `prepare-repo-an93l`
- `prepare-repo-ek4`
- `prepare-repo-c1ndy`
- `prepare-repo-m4nd4`
- `prepare-repo-alpha`
- `prepare-repo-beta`

### B. Job: Update Docker

Job ini dijalankan setelah `prepare-repo` (menggunakan `needs`).

### Proses Utama:

1. Stop container: `docker-compose stop`
2. Jalankan ulang container: `docker-compose up -d`
3. Scaling service: `docker-compose scale lumen_b2b=1 lumen_supplier=1 lumen_finance=1`
4. Ambil container ID: `docker ps -aqf 'name=...'`
5. Eksekusi dalam container:
    - Install dependency: `composer install`
    - Migrasi database: `php artisan migrate`
6. Set permission: `chown -R www:www storage` dan `chmod -Rf 777 storage`

## Service yang Dikelola

Beberapa service utama yang dideploy:

- **lumen_b2b**
- **lumen_supplier**
- **lumen_finance**

Setiap service:

- Diinstall dependency
- Di-migrate database
- Diatur permission storage

## Khusus Environment Beta

Pada `prepare-repo-beta` terdapat tambahan:

- Script build: `/home/ubuntu/waiting_building_topup_beta.sh`
- Copy hasil build ke `dist_prod`
