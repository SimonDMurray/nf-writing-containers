#!/usr/bin/env nextflow

//define file that the container versions will be written to:
def container_file = new File("${params.outdir}/containers.txt")

//cannot write to a file within a non-existent subdirectory, so make those directories first
new File(container_file.getParent()).mkdirs()

//Write file header to file
container_file.write("Container versions used:")

//Function to write each container version to file
def write_container_file(container_file, container_string) {
    String tool_name = container_string.split('/').last().split(':').first()
    container_file.append("\n ${tool_name}: ${container_string}")
}

include { SAMTOOLS } from './modules/samtools.nf'
include { BCFTOOLS } from './modules/bcftools.nf'

workflow {

  //Create empty channel that container versions will go into
  ch_containers = Channel.empty()

  ch_ab = Channel.of('a', 'b')

  SAMTOOLS(ch_ab)
  //Add one copy of the container used in each process to the containers channel
  //ch_containers = ch_containers.mix(SAMTOOLS.out.container.first())
  ch_containers = ch_containers.mix(SAMTOOLS.out.container)

  BCFTOOLS(SAMTOOLS.out.a)
  //ch_containers = ch_containers.mix(BCFTOOLS.out.container.first())
  ch_containers = ch_containers.mix(BCFTOOLS.out.container)

  //incase multiple processes use same container ensure the list is of unique containers
  ch_containers = ch_containers.unique()

  /*cannot pass a channel straight to the function as it will be viewed as a dataflow object,
    map extracts channel value which can then be passed to function*/ 
  ch_containers.map{ it -> write_container_file(container_file, it) }
}
