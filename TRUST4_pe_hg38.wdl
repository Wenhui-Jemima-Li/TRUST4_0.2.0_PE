version 1.0

task TRUST4pehg38 {
    input {
      File fastq1
      File fastq2
      String samplename
      File? barcode
      String? barcodeRange
      Boolean abnormalUnmapFlag
      Boolean noExtraction
      Int thread
      Int stage
      Int memory
    }

    String abnormalUnmapFlag_tag=if abnormalUnmapFlag then "--abnormalUnmapFlag" else ""
    String noExtraction_tag=if noExtraction then "--noExtraction" else "" 
    command {
        /home/TRUST4/run-trust4 -1 ${fastq1} -2 ${fastq2} \
          -f /home/TRUST4/hg38_bcrtcr.fa --ref /home/TRUST4/human_IMGT+C.fa \
          -o ${samplename} \
          ~{"--barcode " + barcode} \
          ~{"--barcodeRange" + barcodeRange} \
          -t ${thread} \
          --stage ${stage} \
          abnormalUnmapFlag_tag noExtraction_tag
    }

    output {
        File out_cdr3="${samplename}_cdr3.out"
        File trust4final="${samplename}_final.out"
        File trust4report="${samplename}_report.tsv"
    }

    runtime {
        docker: "jemimalwh/trust4:0.2.0"
        memory: "${memory} GB"
    }

    meta {
        author: "Wenhui Li"
    }
}

workflow TRUST4workflowPE {
    input {
      File fastq1
      File fastq2
      String samplename
      File? barcode
      String? barcodeRange="0 -1 +"
      Boolean abnormalUnmapFlag
      Boolean noExtraction
      Int thread=1
      Int stage=0
      Int memory=4
    }

    call TRUST4pehg38 { 
        input: 
            fastq1=fastq1,
            fastq2=fastq2,
            samplename=samplename, 
            barcode=barcode, 
            barcodeRange=barcodeRange,
            abnormalUnmapFlag=abnormalUnmapFlag,
            noExtraction=noExtraction,
            thread=thread, 
            stage=stage, 
            memory=memory 
    }

    output {
        File out_cdr3 = TRUST4pehg38.out_cdr3
        File trust4final = TRUST4pehg38.trust4final
        File trust4report = TRUST4pehg38.trust4report
    }
}