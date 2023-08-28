1. Penggunaan git-flow untuk proses commit strategy:
	- Fungsi: 
		- Dapat dikategorikan menjadi 3 proses tagging : hotfix, feature, release
			- hotfix: digunakan untuk proses bug fixing
			- feature: digunakan untuk proses development feature baru
			- release: digunakan untuk proses release ke production
	- Tujuan :
		- Untuk mempermudah tracking proses bug fixing, develop feature atau proses release baru
		- Menstandarisasi git strategy proses development
2. Penggunakan Helm Chart Template yang standard dengan membuat static value2 yang mudah berubah di cluster kubernetes:
	- IP
3. Menggunakan argo CD.
	- Fungsi:
		- Pendistribusian deployment aplikasi ke cluster yang berbeda
		- Mempermudah jika terdapat update/upgrade manifest
	- Tujuan:
		- Mempermudah swing antar platform kubernetes