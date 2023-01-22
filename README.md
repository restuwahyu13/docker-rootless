# Docker Rootless Mode

By default ketika kita menjalankan container menggunakan docker maka hak access by default yang di berikan adalah `root`, dan ini sangatlah berbahaya jika container yang kita punya bisa di akses oleh orang yang tidak dikenal, maka dari itu kita perlu memisahkan antara user yang memiliki privilage acess dan unprivilage access ketika kita menjalankan aplikasi yang kita buat menggunakan docker container, cek lebih lanjut untuk terkait docker security di [OWAPS Docker Security](https://cheatsheetseries.owasp.org/cheatsheets/Docker_Security_Cheat_Sheet.html)

![qTRL9mF.png](https://i.imgur.com/qTRL9mF.png)

![qTRL9mF.png](https://i.imgur.com/Ofne3yU.png)

![qTRL9mF.png](https://i.imgur.com/LImtotl.png)

![qTRL9mF.png](https://i.imgur.com/fCP4bNu.png)

