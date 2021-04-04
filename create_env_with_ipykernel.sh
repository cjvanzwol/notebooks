#! /bin/sh

# variables
PWD=$(pwd)
RETRY=true
# functions
retry () {
    echo "...retrying..."
    echo ""
    cd $PWD
    RETRY=true
}

echo "Setting up enviroment"
echo ""

# list notebooks
echo "# notebooks:"
echo "#"
find -name *.ipynb -not -path "*/.ipynb_checkpoints/*"
echo ""

# list enviroments
conda env list

# list envorinment.yaml files
echo "# environment.yaml files in repo:"
echo "#"
find $PWD -name environment.yaml
echo ""

#check for conda
cd ~/notebooks/Covid # for testing script with Covid notebook repo.
if [[ -f ./environment.yaml ]]; then
    envName=$(awk '/name/ {print $2}' environment.yaml)
    echo "Environment named '$envName' will be installed"
    conda env create -f environment.yaml
elif [[ $(which conda) != "" ]]; then
    read -p "What is the name for the enviroment? " envName
    if [[ -f ./requirements.txt ]]; then
        packages=$(cat ./requirements.txt)
    else
        read -p "What packages need to be installed on creation? [space seperated list; leave empty for None] " extra_packages
        packages="ipykernel $extra_packages"
    fi
    read -p "Are there any other options for conda create? [leave empty for None] " options
    conda create -n $envName $packages $options -y -q
    source ~/miniconda3/bin/activate $envName
    conda config --add channels conda-forge
    conda deactivate
else
    echo "DO PIP & virtual env --> still needs to be coded"
fi

echo "Setting up kernel"
#read -p "What is the name for the kernel? " kernelName
read -p "What name should be displayed in Jupyter? " displayName 
#read -p "What location should the kernel be installed? [leave empty for default] " location

if [[ $location == "" ]]; then
    prefix=""
    removeLocation=/usr/local/share/jupyter/kernels/$kernelName
else
    prefix="--prefix $location"
    removeLocation=$location/share/jupyter/kernels/$kernelName
fi

if [[ $displayName == "" ]]; then
    displayNameOption=""
else
    displayNameOption="--display-name $displayName"
fi

source ~/miniconda3/bin/activate $envName
python -m ipykernel install --name $envName --display-name $displayName
conda deactivate

<< COMMENT
echo "DEBUG"
echo $envName
echo $activatePath
echo $packages
echo $options
echo $kernelName
echo $displayName
echo $location
echo $prefix
echo $removeLocation
echo $USER
conda env remove --name $envName
rm -r $removeLocation

COMMENT
