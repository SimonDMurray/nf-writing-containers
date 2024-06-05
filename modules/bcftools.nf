process BCFTOOLS {

   container "quay.io/biocontainers/bcftools:${params.bcftools_tag}"

   input:
     path(a)

   output:
     val(task.container), emit: container

   script:
   """
   bcftools --help
   """
}
