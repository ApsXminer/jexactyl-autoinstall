# Jexactyl Auto-Installer for VPS

This script automates the installation of **Jexactyl**, a frontend panel for **Pterodactyl**, on a fresh VPS. It works for **Ubuntu** and **Debian** environments (with slight variations). This will install all the required dependencies (Nginx, PHP, MariaDB, Composer, Node.js, etc.), clone the Jexactyl repository, set up the environment, and configure the server.

---

## 🚀 Prerequisites

- A fresh **Ubuntu 20.04/22.04** or **Debian 11/12** VPS
- **Root** access or a user with **sudo** privileges
- A **domain name** (optional but recommended for HTTPS)
- **MySQL/MariaDB** configured and accessible

---

## 🛠️ Installation Steps

### 1. **Run the Installer Script**

**For Ubuntu**
```bash
bash <(curl -s https://raw.githubusercontent.com/ApsXminer/jexactyl-autoinstall/main/install.sh)
````
 **For Debian** 

```bash
bash <(curl -s https://raw.githubusercontent.com/ApsXminer/jexactyl-autoinstall/main/debian-install.sh)
````

> **Note:** This script installs Jexactyl on **Debian 11/12** or **Ubuntu 20.04/22.04**. If you are using a different OS, the script might need modifications.

### 2. **Configure the Panel**

The installer will:

* Install all necessary dependencies (PHP, Nginx, MariaDB, Composer, Node.js)
* Download the Jexactyl repository
* Set up the MySQL database
* Configure the `.env` file for Jexactyl
* Configure Nginx for hosting the panel

---

## ⚙️ Additional Setup

### 1. **Set up HTTPS (Optional but Recommended)**

If you are using a domain, securing the connection with **SSL** is highly recommended. You can do this with **Certbot**:

```bash
sudo apt install certbot python3-certbot-nginx -y
sudo certbot --nginx
```

---

## 🔑 Default Admin Login

* **Login URL**: `http://yourdomain.com`
* **Username**: `admin@example.com`
* **Password**: `password`

> Be sure to change the default password and update the `.env` file with the correct domain and database credentials.

---

## 📜 Customization

### 1. **Nginx Configuration**

The Nginx configuration is set up in `/etc/nginx/sites-available/jexactyl`. You can modify it if you want to set custom ports or tweak the server settings.

### 2. **Database Configuration**

Make sure to edit the `.env` file in the Jexactyl panel directory (`/var/www/panel`) and update the database credentials.

---

## 📡 Support

For any issues or questions, feel free to open an issue in the repository or reach out to us.

---

## 👨‍💻 Developer

This script is maintained by **Code X (APS)**.

---

