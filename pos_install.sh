#!/usr/bin/env bash
# pos instalação do meu sistema

#CORES

VERMELHO='\e[1;91m'
VERDE='\e[1;92m'
SEM_COR='\e[0m'
AMARELO='\e[1;33m'
AZUL='\e[1;36m'

package_update(){
  echo -e "${AZUL}[atualizando]${SEM_COR} - verificando se a atualizações pendentes"
  sudo dnf update -y
}


programs_instaled() {
  cat programas.txt | grep -q "$@"
}

# -------------------------------TESTES E REQUISITOS----------------------------------------- #

# Internet conectando?
if ! ping -c 1 8.8.8.8 -q &> /dev/null; then
  echo -e "${VERMELHO}[ERROR] - Seu computador não tem conexão com a Internet. Verifique a rede.${SEM_COR}"
  exit 1
else
  echo -e "${VERDE}[INFO]${SEM_COR} - Conexão com a Internet funcionando normalmente.${SEM_COR}"
fi

# ------------------------------- INSTALAÇÃO DE PACOTES DNF ----------------------------------------- #

echo -e "${AZUL}[DNF]${SEM_COR} configurando e instalando dnf's"

package_update

dnf list --installed > programas.txt

PROGRAMAS_PARA_INSTALAR=(
  neovim
  nodejs
  vim
  htop
  wget
  curl
  gnome-tweaks
)

for nome_do_programa in ${PROGRAMAS_PARA_INSTALAR[@]}; do
  if ! programs_instaled $nome_do_programa; then # Só instala se já não estiver instalado
    sudo dnf install "$nome_do_programa" -y
  else
    echo -e "${AMARELO}[INSTALADO]${SEM_COR} [dnf] - $nome_do_programa"
  fi
done


# ------------------------------- CONFIGURANDO FLATPAK ----------------------------------------- #

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

FLATPAK_APPS=(
  org.inkscape.Inkscape
  org.telegram.desktop
  com.simplenote.Simplenote
  com.discordapp.Discord
  de.haeckerfelix.Fragments
  org.eclipse.Java
  org.gimp.GIMP
  sh.ppy.osu
)

echo -e "${AZUL}[FLATPAK]${SEM_COR} configurando e instalando flatpaks"

flatpak list > flatpaks.txt

for flatpak in ${FLATPAK_APPS[@]}; do
  if ! cat flatpaks.txt | grep -q $flatpak; then
    flatpak install $flatpak -y
     echo -e "${AMARELO}[INSTALADO]${SEM_COR} [flatpak] - $flatpak"
  else 
     echo -e "${AMARELO}[INSTALADO]${SEM_COR} [flatpak] - $flatpak"
  fi
done

# ------------------------------- CONFIGURANDO NVIM ----------------------------------------- #

if ls /home/$USER/.config/nvim; then
 echo -e "${AMARELO}[INFO]${SEM_COR} Diretorio já criado"
 else
   git clone https://github.com/Ryannnkl/vim-config.git /home/$USER/.config/nvim
fi

# package_update

# ------------------------------- REMOVENDO ARQUIVOS TEMPORARIOS ----------------------------------------- #

rm programas.txt flatpaks.txt

echo -e "${VERDE}[INFO] - Script finalizado, instalação concluída! :)${SEM_COR}"

