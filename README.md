# Docker Rootless Mode (For Production Environment)

By default ketika kita menjalankan container menggunakan docker hak access yang di berikan adalah `root`, dan ini sangatlah berbahaya jika container yang kita miliki bisa di akses oleh orang lain yang tidak dikenal dari jarak jauh, maka dari itu kita perlu membatasi hak akses antara user yang memiliki privilage dan user yang tidak memiliki privilage, ketika kita menjalankan aplikasi menggunakan docker container, cek lebih lanjut terkait docker security di [OWASP Docker](https://cheatsheetseries.owasp.org/cheatsheets/Docker_Security_Cheat_Sheet.html)

![qTRL9mF.png](https://i.imgur.com/qTRL9mF.png)

![qTRL9mF.png](https://i.imgur.com/Ofne3yU.png)

![qTRL9mF.png](https://i.imgur.com/LImtotl.png)

![qTRL9mF.png](https://i.imgur.com/fCP4bNu.png)

