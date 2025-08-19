Halo rekan, 

pada kesempatan kali ini saya akan sharing bagaimana cara install VMware Workstation di kali linux:

sebagai berikut steb by step simple nya:

silahkan buka terminal, dan cari lokasi folder atau directory bahan dasar atau lokasi aplikasi Vmwarexxxx.bunlde

👉 chmod 766 vmware.bunlde
-> berikan akses izin Write dan Read untuk user biasa

👉 ./vmware.bandle
-> jalankan installer VMware

####### Jika Terdapat Error VMware-Host Module #######

👉 apt update && apt install git -y
-> Update List Repository dan jalankan perintah untuk install git

👉 git clone https://github.com/aldihatomi123/vmware-fix
-> Clone atau download file dari repository github 

👉 cd vmware-fix
-> masuk ke directory vmware-fix

👉 sudo su
-> login sebagai super user(root)

👉 chmod 777 vmware.sh
-> berikan akses izin Write, Read, dan modify untuk user biasa

👉 ./vmware.sh atau ./vmware.sh
-> jalankan file bash script shell vmware.sh

tunggu hingga selesai fix error nya berhasil atau success,
kemudian silahkan buka pada list aplication vmware-workstation
