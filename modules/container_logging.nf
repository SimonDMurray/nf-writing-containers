//Process to write each container version to file
process CONTAINER_LOGGING {

   input:
     val(container_string)

   exec:
     //ensuring containers file is appended to in output directory to stop parallel overwriting
     def container_file = new File("${params.outdir}/containers.txt")
     String tool_name = container_string.split('/').last().split(':').first()
     container_file.append("${tool_name}: ${container_string}\n")
}
