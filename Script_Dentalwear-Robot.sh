#! /bin/bash

## DEFINE OPTIONS

update=0
build=0

function usage {
    echo " "
    echo "usage: $0 [-b][-u]"
    echo " "
    echo "    -b          build owl file"
    echo "    -u          initalize/update submodule"
    echo "    -h -?       print this help"
    echo " "
    
    exit
}

while getopts "bcuh?" opt; do
    case "$opt" in
	
	u)  update=1
	    ;;
	b) build=1
	   ;;       
	?)
	usage
	;;
	h)
	    usage
	    ;;
    esac
done
if [ -z "$1" ]; then
    usage
fi

## PREPARE SUBMODULES

## Check if submodules are initialised

gitchk=$(git submodule foreach 'echo $sm_path `git rev-parse HEAD`')
if [ -z "$gitchk" ];then
    update=1
    echo "Initializing git submodule"
fi

## Initialise and update git submodules

if  [ $update -eq 1 ]; then
    git submodule init
    git submodule update
fi


if [ $build -eq 1 ]; then # Starts build process

## BUILD DEPENDENCIES

## Build Core Ontology

cd RDFBones-O/robot

./Script-Build_RDFBones-Robot.sh

cd ../..

## COMPILE TEMPLATE

robot template --template Template_Dentalwear-Robot.tsv \
      --input RDFBones-O/robot/results/rdfbones.owl \
      --prefix "dentalwear: http://w3id.org/rdfbones/ext/dentalwear/" \
      --prefix "obo: http://purl.obolibrary.org/obo/" \
      --prefix "rdfbones: http://w3id.org/rdfbones/core#" \
      --ontology-iri "http://w3id.org/rdfbones/ext/dentalwear/latest/dentalwear.owl" \
      --output results/dentalwear.owl

## Annotate output

robot annotate --input results/dentalwear.owl \
      --remove-annotations \
      --ontology-iri "http://w3id.org/rdfbones/ext/dentalwear/latest/dentalwear.owl" \
      --version-iri "http://w3id.org/rdfbones/ext/dentalwear/v0-1/dentalwear.owl" \
      --annotation dc:creator "Felix Engel" \
      --annotation dc:creator "Stefan Schlager" \
      --annotation owl:versionInfo "0.1" \
      --language-annotation dc:description "This RDFBones ontology extension implements the dental wear scoring technique outlined by E. C. Scott (1979)." en \
      --language-annotation dc:title "Dental wear scoring technique" en \
      --language-annotation rdfs:label "Dental wear scoring technique" en \
      --language-annotation rdfs:comment "The RDFBones core ontology, version 0.2 or later, needs to be loaded into the same information system for this ontology extension to work." en \
      --output results/dentalwear.owl
      
## Quality check of output  

robot reason --reasoner ELK \
      --input results/dentalwear.owl \
      -D results/debug.owl

fi # Ends build process
      
