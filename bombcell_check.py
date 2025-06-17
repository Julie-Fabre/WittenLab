

import os, sys
from pathlib import Path
from pprint import pprint 
import numpy as np
import pandas as pd
pd.set_option('display.max_columns', 50)
import matplotlib.pyplot as plt
%load_ext autoreload
%autoreload 2
import bombcell as bc

# Set up parameters


subject = "a2a_230"
#session with NaN values in waveforms for dates: "20240922", "20240929","20241001", "20241009"
date = "20241001"

#subject="a2a_492"  #I also did bombcell for these 
#dates=("20220608", "20220615", "20220616", "20220620")  


for date in dates:
    ks_dir = rf"Z:\RigData\training\npx\electrophysiology\sbolkan\{subject}\{date}\catgt_TowersTask_g0\kilosort4"
    save_path = Path(ks_dir) / "bombcell"
    # Create the save path directory if it doesn't exist
    save_path.mkdir(parents=True, exist_ok=True)
    print(f"Using kilosort directory: {ks_dir}") 
    meta_file = rf"Z:\RigData\training\npx\electrophysiology\sbolkan\{subject}\{date}\catgt_TowersTask_g0\TowersTask_g0_tcat.imec0.ap.meta"   
    param = bc.get_default_parameters(ks_dir, meta_file=meta_file) 
    param["extractRaw"] = True
    param ['raw_data_file']= rf"Z:\RigData\training\npx\electrophysiology\sbolkan\{subject}\{date}\catgt_TowersTask_g0\TowersTask_g0_tcat.imec0.ap.bin"
    param ['save_multiple_raw'] = True  #adding a new param for waveforms unitmatch  
    # Run bombcell quality metrics
    quality_metrics, param, unit_type, unit_type_string = bc.run_bombcell(
        ks_dir, 
        save_path, 
        param
    )
    print(f"Finished processing date: {date}\n")




#raw_waveforms_ks_path =rf'Z:\RigData\training\npx\electrophysiology\sbolkan\a2a_230\20240922\catgt_TowersTask_g0\kilosort4\bombcell\_bc_rawWaveforms_kilosort_format.npy'
#raw_waveforms_path = rf'Z:\RigData\training\npx\electrophysiology\sbolkan\a2a_230\20240929\catgt_TowersTask_g0\kilosort4\bombcell\templates._bc_rawWaveforms.npy'
#ks_waveforms = np.load(raw_waveforms_ks_path, allow_pickle=True)
#raw_waveforms = np.load(raw_waveforms_path, allow_pickle=True)

sample = rf'Z:\RigData\training\npx\electrophysiology\sbolkan\a2a_230\20241001\catgt_TowersTask_g0\RawWaveforms\Unit6_RawSpikes.npy'
sample_wave = np.load(sample, allow_pickle=True)


bc.get_default_parameters

(
    spike_times_samples,
    spike_clusters, # actually spike_templates, but they're the same in bombcell
    template_waveforms,
    template_amplitudes,
    pc_features,
    pc_features_idx,
    channel_positions,
) = bc.load_ephys_data(ks_dir)
# replot global output plots
bc.plot_summary_data(quality_metrics, template_waveforms, unit_type, unit_type_string, param)




