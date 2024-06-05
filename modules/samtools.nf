process SAMTOOLS {

   container "quay.io/biocontainers/samtools:${params.samtools_tag}"

   publishDir "${params.outdir}", mode: 'copy'

   input:
     val(a)

   output:
     path('a.txt'), emit: a
     val(task.container), emit: container

   script:
   """
   samtools --help > a.txt
   """
}
