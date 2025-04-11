# .bashrc

# Jika tidak berjalan secara interaktif, tidak perlu melakukan apapun
[[ $- != *i* ]] && return

# Start program di terminal
neofetch

# Alias untuk mempermudah
alias ls='ls --color=auto'

# Fungsi untuk memeriksa status baterai dan persentase menggunakan /sys/class/power_supply
battery_status() {
    # Mencari perangkat baterai di /sys/class/power_supply
    battery_device=$(ls /sys/class/power_supply/ | grep -i '^BAT' | head -n 1)

    # Jika perangkat baterai ditemukan, ambil status dan kapasitas
    if [ -n "$battery_device" ]; then
        charging_status=$(cat /sys/class/power_supply/$battery_device/status)
        battery_percentage=$(cat /sys/class/power_supply/$battery_device/capacity)

        # Menampilkan status baterai berdasarkan apakah sedang di-charge atau tidak
        if [[ "$charging_status" == "Charging" ]]; then
            # Ikon petir dengan warna kuning jika sedang mengisi daya
            echo -e "\033[1;33m⚡ ${battery_percentage}%\033[0m"
        else
            # Ikon baterai dengan warna biru jika tidak sedang di-charge
            echo -e "\033[1;34m ${battery_percentage}%\033[0m"
        fi
    else
        # Jika tidak ada perangkat baterai, tampilkan ikon baterai kosong atau pesan lain
        echo -e "\033[1;34m 0%\033[0m"
    fi
}

# Fungsi untuk mengambil nama pengguna
user_name() {
    echo "$USER"  # Mengambil nama pengguna
}

# Fungsi untuk menampilkan path home atau direktori saat ini
current_path() {
    # Memeriksa apakah direktori saat ini adalah direktori home (root home saja, bukan subdirektori)
    if [[ "$(realpath $PWD)" == "$(realpath $HOME)" ]]; then
        echo "🏠"  # Simbol Home hanya jika berada di direktori home (root home)
    else
        echo "📂"  # Folder icon untuk direktori lain
    fi
}

# Menyesuaikan prompt Bash dengan warna
PS1='╭─[$(battery_status)]\033[1;34m♜\033[0m $(user_name) \033[1;34m♜\033[0m [\033[1;33m$(current_path)$(basename $PWD)\033[0m]\n╰─────$ '

# Optional: bash completion (memungkinkan fitur autocompletion untuk perintah bash)
if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
fi
