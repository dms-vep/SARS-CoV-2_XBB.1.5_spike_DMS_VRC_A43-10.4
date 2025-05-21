"""Custom rules used in the ``snakemake`` pipeline.

This file is included by the pipeline ``Snakefile``.

"""


rule spatial_distances:
    """Get spatial distances from PDB."""
    input: 
        pdb="data/PDBs/aligned_spike_TM.pdb",
    output:
        csv="results/spatial_distances/spatial_distances.csv",
    params:
        target_chains=["A", "B", "C"],
    log:
        log="results/logs/spatial_distances.txt",
    conda:
        os.path.join(config["pipeline_path"], "environment.yml")
    script:
        "scripts/spatial_distances.py"


rule escape_logos:
    """Make logo plots of escape."""
    input:
        per_antibody_escape="results/summaries/antibody_escape.csv",
    output:
        svg="results/escape_logos/escape_logos.svg",
    log:
        notebook="notebooks/logs/escape_logoplots_for_key_sites.ipynb",
    conda:
        os.path.join(config["pipeline_path"], "environment.yml"),
    notebook:
        "notebooks/escape_logoplots_for_key_sites.py.ipynb"

other_target_files.append(rules.escape_logos.output.svg)

# Files (Jupyter notebooks, HTML plots, or CSVs) that you want included in
# the HTML docs should be added to the nested dict `docs`:
docs["Additional data files"] = {
    "Spike site numbering": {
        "CSV converting sequential sites in XBB.1.5 spike to Wuhan-Hu-1 reference sites":
            config["site_numbering_map"],
    },
}
