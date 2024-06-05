# nf-writing-containers
A test repository for seeing viability in writing containers used by pipeline to an output file

## Notes:
* Normally I don't believe in writing lots of groovy functions for Nextflow pipelines as readability is lost.

* I did not want the container repo being passed as a parameter (can lead to people accidentally overwriting repo path and pipeline failing.
  * Defining these strings in the `nextflow.config` or another config file and passing them to processes as a variables iin not possible.
  * A `modules.config` can be created with these variables defined and then define process containers there within that file using the variables (overkill for this PoC).
* I did want the tags being passed as parameters so that people can experiment with different versions of the containers used by the pipeline so that if there is an update they can compare results.

* I originally looked at `workflow.onComplete()` however `workflow.onComplete()` cannot see any workflow channels etc which is how I am obtaining container names.
  * However, onComplete() can see params so if you wanted to store containers in params variables then onComplete() could work.

* The `write_container_file()` function assumes the repo name is the last element of a list when splitting by `/`, this should always be true but if there is no `/` (i.e. local image) this function still works as expected.
  * If there are other `/`s that do not indicate the repository path or the path is delimited by another character then the entire string will be used to name the container, this could be a bug.
