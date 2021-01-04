#! /bin.sh
echo "THIS SCRIPT IS UNDERDEVELOPED"
echo ""

read -p "THIS WILL DELETE AN ENVORIMENT. ARE YOU SURE? [y/N]" yn
if [[ $yn == y ]]; then
    # list enviroments conda
    # list envoroments venv
    # choose enviroment to delete
    read -p "What is the name of the enviroment to delete? " envName
    conda env remove --name $envName
    read -p "What directory needs to be delete? " removeLocation
    rm -r $removeLocation
fi
exit