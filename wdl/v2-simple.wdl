version 1.0

# 主工作流：宏基因组分析
workflow metagenomic_analysis {
    input {
        File kraken2_db          # Kraken2数据库文件
        File reads               # 输入的测序数据文件
        File krona_db            # Krona数据库文件
    }

    # Kraken2分类任务
    call kraken2_classification {
        input:
            kraken2_db = kraken2_db,
            reads = reads
    }

    # Krona可视化任务
    call krona_visualization {
        input:
            kraken_report = kraken2_classification.kraken_report,
            krona_db = krona_db
    }

    # 多样性分析任务
    call diversity_analysis {
        input:
            kraken_report = kraken2_classification.kraken_report
    }

    # 差异丰度分析任务
    call differential_abundance_analysis {
        input:
            kraken_report = kraken2_classification.kraken_report
    }

    # 生成最终报告任务
    call report_generation {
        input:
            krona_plot = krona_visualization.krona_plot,
            alpha_diversity = diversity_analysis.alpha_diversity,
            beta_diversity = diversity_analysis.beta_diversity,
            diff_abundance = differential_abundance_analysis.diff_abundance
    }
}

# Kraken2分类任务定义
task kraken2_classification {
    input {
        File kraken2_db  # Kraken2数据库文件
        File reads       # 输入的测序数据文件
    }

    command {
        kraken2 --db ~{kraken2_db} --output kraken_output --report kraken_report ~{reads}
    }

    output {
        File kraken_output = "kraken_output"
        File kraken_report = "kraken_report"
    }

    runtime {
        docker: "kraken2_docker_image"
    }
}

# Krona可视化任务定义
task krona_visualization {
    input {
        File kraken_report  # Kraken2生成的报告文件
        File krona_db       # Krona数据库文件
    }

    command {
        ktImportTaxonomy -o krona_plot.html -db ~{krona_db} ~{kraken_report}
    }

    output {
        File krona_plot = "krona_plot.html"
    }

    runtime {
        docker: "krona_docker_image"
    }
}

# 多样性分析任务定义
task diversity_analysis {
    input {
        File kraken_report  # Kraken2生成的报告文件
    }

    command {
        Rscript diversity_analysis.R ~{kraken_report}
    }

    output {
        File alpha_diversity = "alpha_diversity.csv"
        File beta_diversity = "beta_diversity.csv"
    }

    runtime {
        docker: "r_docker_image"
    }
}

# 差异丰度分析任务定义
task differential_abundance_analysis {
    input {
        File kraken_report  # Kraken2生成的报告文件
    }

    command {
        Rscript differential_abundance_analysis.R ~{kraken_report}
    }

    output {
        File diff_abundance = "diff_abundance.csv"
    }

    runtime {
        docker: "r_docker_image"
    }
}

# 报告生成任务定义
task report_generation {
    input {
        File krona_plot       # Krona生成的可视化文件
        File alpha_diversity  # α多样性分析结果
        File beta_diversity   # β多样性分析结果
        File diff_abundance   # 差异丰度分析结果
    }

    command {
        Rscript generate_report.R ~{krona_plot} ~{alpha_diversity} ~{beta_diversity} ~{diff_abundance}
    }

    output {
        File report = "metagenomic_report.html"
    }

    runtime {
        docker: "r_docker_image"
    }
}
