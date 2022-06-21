#! /bin/bash

## BUILD CORE ONTOLOGY

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
      
