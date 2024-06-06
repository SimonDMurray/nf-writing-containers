#!/usr/bin/env nextflow

include { SAMTOOLS } from './modules/samtools.nf'
include { BCFTOOLS } from './modules/bcftools.nf'
include { CONTAINER_LOGGING } from './modules/container_logging.nf'

workflow {

  //Create empty channel that container versions will go into
  ch_containers = Channel.empty()

  ch_ab = Channel.of('a', 'b')

  SAMTOOLS(ch_ab)
  //Add one copy of the container used in each process to the containers channel
  ch_containers = ch_containers.mix(SAMTOOLS.out.container.first())

  BCFTOOLS(SAMTOOLS.out.a)
  ch_containers = ch_containers.mix(BCFTOOLS.out.container.first())

  //incase multiple processes use same container ensure the list is of unique containers
  ch_containers = ch_containers.unique()

  CONTAINER_LOGGING(ch_containers)
}
