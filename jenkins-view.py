import argparse
import configparser

import requests
from requests.auth import HTTPBasicAuth


def read_config(config_file):
    config = configparser.ConfigParser()
    config.read(config_file)
    return config["Credentials"]


def add_job_to_view(jenkins_url, username, api_token, view_name, job_name):
    # URL untuk mengambil konfigurasi tampilan
    view_url = f"{jenkins_url}/view/{view_name}/config.xml"

    # Ambil konfigurasi tampilan
    response = requests.get(view_url, auth=HTTPBasicAuth(username, api_token))
    view_config = response.text

    # Tambahkan pekerjaan ke dalam konfigurasi tampilan
    job_line = f"<string>{job_name}</string>"
    if job_line not in view_config:
        view_config = view_config.replace("</jobNames>", f"  {job_line}\n</jobNames>")

        # Update konfigurasi tampilan
        response = requests.post(
            view_url,
            auth=HTTPBasicAuth(username, api_token),
            headers={"Content-Type": "application/xml"},
            data=view_config,
        )

        if response.status_code == 200:
            print(
                f"Pekerjaan {job_name} berhasil ditambahkan ke dalam tampilan {view_name}"
            )
        else:
            print(f"Gagal menambahkan pekerjaan. Kode status: {response.status_code}")
    else:
        print(f"Pekerjaan {job_name} sudah ada dalam tampilan {view_name}")


def remove_job_from_view(jenkins_url, username, api_token, view_name, job_name):
    # URL untuk mengambil konfigurasi tampilan
    view_url = f"{jenkins_url}/view/{view_name}/config.xml"

    # Ambil konfigurasi tampilan
    response = requests.get(view_url, auth=HTTPBasicAuth(username, api_token))
    view_config = response.text

    # Hapus pekerjaan dari konfigurasi tampilan
    job_line = f"<string>{job_name}</string>"
    if job_line in view_config:
        view_config = view_config.replace(f"  {job_line}\n", "")

        # Update konfigurasi tampilan
        response = requests.post(
            view_url,
            auth=HTTPBasicAuth(username, api_token),
            headers={"Content-Type": "application/xml"},
            data=view_config,
        )

        if response.status_code == 200:
            print(f"Pekerjaan {job_name} berhasil dihapus dari tampilan {view_name}")
        else:
            print(f"Gagal menghapus pekerjaan. Kode status: {response.status_code}")
    else:
        print(f"Pekerjaan {job_name} tidak ditemukan dalam tampilan {view_name}")


def create_view(jenkins_url, username, api_token, view_name):
    # URL untuk membuat tampilan baru
    create_view_url = f"{jenkins_url}/createView?name={view_name}"

    # Kirim permintaan untuk membuat tampilan
    response = requests.post(create_view_url, auth=HTTPBasicAuth(username, api_token))

    if response.status_code == 200:
        print(f"Tampilan {view_name} berhasil dibuat")
    else:
        print(f"Gagal membuat tampilan. Kode status: {response.status_code}")


def delete_view(jenkins_url, username, api_token, view_name):
    # URL untuk menghapus tampilan
    delete_view_url = f"{jenkins_url}/view/{view_name}/doDelete"

    # Kirim permintaan untuk menghapus tampilan
    response = requests.post(delete_view_url, auth=HTTPBasicAuth(username, api_token))

    if response.status_code == 200:
        print(f"Tampilan {view_name} berhasil dihapus")
    else:
        print(f"Gagal menghapus tampilan. Kode status: {response.status_code}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Manajemen tampilan Jenkins dan pekerjaan."
    )
    parser.add_argument(
        "--config-file",
        "-c",
        default="config.ini",
        help="Nama file konfigurasi (default: config.ini)",
    )

    subparsers = parser.add_subparsers(
        title="commands", dest="command", help="Pilih salah satu perintah"
    )

    # Perintah untuk menambahkan pekerjaan ke tampilan
    add_parser = subparsers.add_parser(
        "add", help="Tambahkan pekerjaan ke dalam tampilan"
    )
    add_parser.add_argument(
        "--view-name", "-v", required=True, help="Nama tampilan Jenkins"
    )
    add_parser.add_argument(
        "--job-name", "-j", required=True, help="Nama pekerjaan Jenkins"
    )

    # Perintah untuk menghapus pekerjaan dari tampilan
    remove_parser = subparsers.add_parser(
        "remove", help="Hapus pekerjaan dari tampilan"
    )
    remove_parser.add_argument(
        "--view-name", "-v", required=True, help="Nama tampilan Jenkins"
    )
    remove_parser.add_argument(
        "--job-name", "-j", required=True, help="Nama pekerjaan Jenkins"
    )

    # Perintah untuk membuat tampilan baru
    create_parser = subparsers.add_parser("create", help="Buat tampilan baru")
    create_parser.add_argument(
        "--view-name", "-v", required=True, help="Nama tampilan Jenkins"
    )

    # Perintah untuk menghapus tampilan
    delete_parser = subparsers.add_parser("delete", help="Hapus tampilan")
    delete_parser.add_argument(
        "--view-name", "-v", required=True, help="Nama tampilan Jenkins"
    )

    args = parser.parse_args()

    # Baca informasi dari file konfigurasi
    credentials = read_config(args.config_file)

    # Tangani perintah yang dipilih
    if args.command == "add":
        add_job_to_view(
            credentials["JENKINS_URL"],
            credentials["USERNAME"],
            credentials["API_TOKEN"],
            args.view_name,
            args.job_name,
        )
    elif args.command == "remove":
        remove_job_from_view(
            credentials["JENKINS_URL"],
            credentials["USERNAME"],
            credentials["API_TOKEN"],
            args.view_name,
            args.job_name,
        )
    elif args.command == "create":
        create_view(
            credentials["JENKINS_URL"],
            credentials["USERNAME"],
            credentials["API_TOKEN"],
            args.view_name,
        )
    elif args.command == "delete":
        delete_view(
            credentials["JENKINS_URL"],
            credentials["USERNAME"],
            credentials["API_TOKEN"],
            args.view_name,
        )
    else:
        print("Pilih salah satu perintah: add, remove, create, atau delete")
