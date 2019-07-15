#Parameter mapping
#string groupname
#string tmpName
#string tmpDataDir
#string tempDir
#string intermediateDir
#string projectResultsDir
#string logsDir

#string gatkVersion
#string gatkJar
#string indexFile

#string	project

#string externalSampleID
#string dedupBam

#string mergedBamRecalibratedTable
#string sampleMergedRecalibratedBam


#Load GATK module.
module load "${gatkVersion}"
module list

# Make a tmp folder for this step, which will be the output location.
makeTmpDir "${sampleMergedRecalibratedBam}" "${intermediateDir}"
tmpSampleMergedRecalibratedBam="${MC_tmpFile}"

# Create the list of BAM files for input.
bams=($(printf '%s\n' "${dedupBam[@]}" | sort -u ))
inputs=$(printf ' -I %s ' $(printf '%s\n' ${bams[@]}))

gatk --java-options "-XX:ParallelGCThreads=1 -Djava.io.tmpdir=${tempDir} -Xmx9g" ApplyBQSR \
-R "${indexFile}" \
${inputs} \
--bqsr-recal-file "${mergedBamRecalibratedTable}" \
-O "${tmpSampleMergedRecalibratedBam}"

mv "${tmpSampleMergedRecalibratedBam}" "${sampleMergedRecalibratedBam}"
echo "moved ${tmpSampleMergedRecalibratedBam}  ${sampleMergedRecalibratedBam}"