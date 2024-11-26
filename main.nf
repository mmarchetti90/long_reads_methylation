#!/usr/bin/env nextflow

nextflow.enable.dsl=2

/*
Pipeline for methylation analysis of ONT and PacBio CCS/HiFi reads
*/

// ----------------Workflow---------------- //

include { PACB } from './workflows/local/pacb.nf'
include { ONT } from './workflows/local/ont.nf'

workflow {

  if ("$workflow.profile" == "standard") {
    
    PACB()

  }
  else if ("$workflow.profile" == "pacb") {
    
    PACB()

  }
  else if ("$workflow.profile" == "ont") {
    
    ONT()

  } else {

    println "ERROR: Unrecognized profile!"
    println "Please chose one of: standard, pacb, ont"

  }

}