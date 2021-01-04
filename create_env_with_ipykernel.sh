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
read
#check for conda
if [[ $(which conda) != "" ]]; then
    echo "DO CONDA MAGIC"
    if [[ -f ./environment.yml ]]; then
        envName=$(awk '/name/ {print $2}' environment.yml)
        echo $ENV_NAME
        conda env create -f environment.yml
    else
        read -p "What is the name for the enviroment? " envName
        read -p "What packages need to be installed on creation? [space seperated list; leave empty for None] " extra_packages
        if [[ -f ./requirements.txt ]]; then
            pip install -r requirements.txt
        else
            read -p "What packages need to be installed with pip? [space seperated list; leave empty for None] " pip_packages 
        fi
        read -p "Are there any other options for conda create? [leave empty for None] " options
    fi
else
    echo "DO PIP"
fi
exit

<< COMMENT

echo "Setting up kernel"
read -p "What is the name for the kernel? " kernelName
read -p "What name should be displayed in Jupyter? " displayName 
read -p "What location should the kernel be installed? [leave empty for default] " location

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
packages="ipykernel $extra_packages"

conda create --name $envName $packages $options -y -q
source /opt/conda/bin/activate $envName
conda config --add channels conda-forge

#conda install -y -q ipykernel
python -m ipykernel install --name $kernelName
if [[ $pip_packages != "" ]]; then
	pip install $pip_packages
fi
conda deactivate
COMMENT


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
