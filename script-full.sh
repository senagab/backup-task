#!/bin/bash

# Define ANSI color codes
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
purple='\033[0;35m'
nc='\033[0m' # No Color

# Display text in different colors
# echo -e "${red}This is red text${nc}"
# echo -e "${green}This is green text${nc}"
# echo -e "${yellow}This is yellow text${NC}"
# echo "This is normal text"

# define the function to check and create the destination directory
check_destination_financeiro() {
    financeiro_dir="${base_dir}/${nomedaobra1}" #/c/users/gabrielsena/documents/shell/obras + "/" + alcantarea
    encerrado="${base_dir}/${nomedaobra1}"

    if [ ! -d "$financeiro_dir" ]; then
        echo -e "${yellow}[warning]${nc} diretório \"$nomedaobra1\" não encontrado"
        # exit 1
    # else
        # echo "[success] diretório \"$nomedaobra\" encontrado! ($financeiro_dir)" 
    fi
}

# define the function to check and create the destination directory
check_destination_obra() {
    obra_dir="${base_dir_2}/${nomedaobra2}" #/c/users/gabrielsena/documents/shell/engenharia/acompanhamento de obra/ + "/" + alcantarea

    if [ ! -d "$obra_dir" ]; then
        echo -e "${yellow}[warning]${nc} diretório \"$nomedaobra2\" não encontrado"
        # exit 1
    # else
    #     echo "[success] DIRETORIO \"$nomedaobra\" ENCONTRADO!" 
    fi
}

# declarações globais
base_dir="/c/users/gabrielsena/documents/shell/obras"
base_dir_2="/c/users/gabrielsena/documents/shell/engenharia/acompanhamento de obra" # obra_dir = /users/gabrielsena/documents/shell/engenharia + /alcantarea
base-dir_encerrado="/c/users/gabrielsena/documents/shell/engenharia/acompanhamento de obra/encerrados"
base-dir_2_encerrado="/c/users/gabrielsena/documents/shell/engenharia/acompanhamento de obra/encerrados"

update_all() {

    #declarações locais
    local obra="$1" # The value of $1 (the first argument) is assigned to $obra
    local relatorio="Relatório"
    local del1="dados"
    local del2="Relatorio"
    
    local relatorio_dir="/07 - Financeiro/Relatório"
    local extrato_dir="/07 - Financeiro/Extratos Bancários"
    local cliente_relatorio_dir="/08 - Acesso Cliente/Financeiro"
    local cliente_extrato_dir="/08 - Acesso Cliente/Financeiro/Extratos Bancários"
    local movimento_dir="/03 - Movimento"
    local cliente_movimento_dir="/08 - Acesso Cliente/Financeiro/Movimento"
    local acompanhamento_obra="/08 - Acesso Cliente/Obra"

    nomedaobra1="$obra" # $obra is assigned to nomedaobra
    echo -e "\nProcessing: ${purple}$obra${nc}...\n"

    # check directories 
    # brief confirmation regarding the directories' existence
    check_destination_financeiro "$financeiro_dir"
    check_destination_obra "$obra_dir"

    # change source and destination directories if needed
    # junção de variáveis para formação "dinâmica" de diretórios
    local copia_relatorio="${financeiro_dir}${relatorio_dir}" # /c/users/gabrielsena/documents/shell/obras/<nome_da_obra> + /07 - Financeiro/Relatório
    local cola_relatorio="${financeiro_dir}${cliente_relatorio_dir}" # /c/users/gabrielsena/documents/shell/obras/<nome_da_obra> + /08 - Acesso Cliente/Financeiro
    local copia_extrato="${financeiro_dir}${extrato_dir}" # /c/users/gabrielsena/documents/shell/obras/<nome_da_obra> + //07 - Financeiro/Extratos Bancários
    local cola_extrato="${financeiro_dir}${cliente_extrato_dir}" # /c/users/gabrielsena/documents/shell/obras/<nome_da_obra> + /08 - Acesso Cliente/Financeiro/Extratos Bancários
    local copia_movimento="${financeiro_dir}${movimento_dir}" # /c/users/gabrielsena/documents/shell/obras/<nome_da_obra> + /03 - Movimento
    local cola_movimento="${financeiro_dir}${cliente_movimento_dir}" # /c/users/gabrielsena/documents/shell/obras/<nome_da_obra> + /08 - Acesso Cliente/Financeiro/Movimento
    local cola_acompanhamento="${financeiro_dir}${acompanhamento_obra}" # /c/users/gabrielsena/documents/shell/obra/<nome_da_obra> + /08 - Acesso Cliente/Obra
    local cola_acompanhamento_encerrado="${encerrado}${acompanhamento_obra}"

    # insira código que deleta relatórios #
    find "$cola_relatorio" -type f -name "*$relatorio" -exec rm -f {} \;
    echo "<<----- relatório residual deletado com sucesso."

    # verifica se o diretório existe, caso não exista mkdir neles
    if [ ! -d "$cola_relatorio" ]; then
        echo -e "${yellow}[warning]${nc} "Relatório" not found. Creating for \"$nomedaobra1\"..."
        mkdir -p "$cola_relatorio"
    fi

    # copia de "07 - financeiro/relatório" para "08 - acesso cliente/financeiro"
    cp -u -r "$copia_relatorio"/* "$cola_relatorio/" # -r for recursive copy and -u for update
    # echo "----->> update de relatório feito com sucesso."
    # Check the exit status of the cp command
    if [ $? -eq 0 ]; then
        echo "----->> update de relatório feito com sucesso."
    else
        echo -e "${red}[error]${nc} no files found or copy operation failed."
        
    fi

    # verifica se o diretório existe, caso não exista mkdir neles
    if [ ! -d "$cola_extrato" ]; then
        echo -e "${yellow}[warning]${nc} "Extrato" not found. Creating for \"$nomedaobra1\"..."
        mkdir -p "$cola_extrato"
    fi

    # copia de "07 - financeiro/extrato bancario" para "08 - acesso cliente/financeiro/extratos bancários"
    cp -u -r "$copia_extrato"/* "$cola_extrato/" # -r for recursive copy and -u for update
    # echo "copia de $copia_extrato para $cola_extrato"
    # echo "----->> update de extrato feito com sucesso."
    if [ $? -eq 0 ]; then
        echo "----->> update de extratos feito com sucesso."
    else
        echo -e "${red}[error]${nc} no files found or copy operation failed."
    fi

    # deleta dados + gerador de relatório
    find "$cola_relatorio" -type f -regex ".*\($del1\).*" -exec rm -f {} \;
    find "$cola_relatorio" -type f -regex ".*\($del2\).*" -exec rm -f {} \;

    # insira aqui o código para movimento
    # verifica se o diretório existe, caso não exista mkdir neles
    if [ ! -d "$cola_movimento" ]; then
        echo -e "${yellow}[warning]${nc} "Movimento" not found. Creating for \"$nomedaobra1\"..."
        mkdir -p "$cola_movimento"
    fi

    # atualização de arquivos (cópia)
    cp -u -r "$copia_movimento"/* "$cola_movimento/" 
    # echo "copia movimento de: $copia_movimento"
    # echo "cola movimento em: $cola_movimento"

    #confirma se houve erro durante a operação de cópia
    if [ $? -eq 0 ]; then
        echo "----->> update de movimento feito com sucesso."
    else
        echo -e "${red}[error]${nc} no files found or copy operation failed"
    fi

    # insira aqui o código para acompanhamento de obra
    cp -u -r "$obra_dir"/* "$cola_acompanhamento/" 2>&1 # -r for recursive copy and -u for update
    # echo -e "\n${green}[success]${nc} acompanhamento de obra \"$obra\" atualizado."
    if [ $? -eq 0 ]; then
        echo -e "----->> update de acompanhamento de obra feito com sucesso."
    else
        echo -e "\n${red}[error]${nc} no files found or copy operation failed."
    fi


    # feedback final
    echo -e "\n${green}[success]${nc} financeiro de \"$obra\" atualizado.\n${green}[success]${nc} acompanhamento de obra de \"$obra\" atualizado."

}

# mapping
# linka uma pasta a outra
declare -A folder_mapping
folder_mapping["bascuare"]="bascuare1"
folder_mapping["fernao"]="fernao1"
folder_mapping["maria cristina"]="maria cristina1"
folder_mapping["alcantarea"]="alcantarea1"

# utiliza mapping como array
for folder in "${!folder_mapping[@]}"; do
    linked_folder="${folder_mapping[$folder]}"

    # herança de nome de pastas (obras) seguindo a organização da unidade \\nas\administracao
    nomedaobra1="$folder"

    # herança de nome de pastas (obras) seguindo a organização da unidade \\nas\engenharia
    nomedaobra2="$linked_folder"

    # trigger da função central do script
    update_all "$folder"
    
    # retorno: reforça quais pastas estão linkadas entre sí
    echo "Folder: $folder, Linked folder: $linked_folder"
    # call functions with $folder and $linked_folder if needed
done