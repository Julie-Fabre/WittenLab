#based on https://github.com/EnnyvanBeest/UnitMatch/blob/main/UnitMatchPy/Demo%20Notebooks/UMPy_example.ipynb 


%load_ext autoreload
%autoreload 

import UnitMatchPy.bayes_functions as bf
import UnitMatchPy.utils as util
import UnitMatchPy.overlord as ov
import numpy as np
import matplotlib.pyplot as plt
import UnitMatchPy.save_utils as su
import UnitMatchPy.GUI as gui
import UnitMatchPy.assign_unique_id as aid
import UnitMatchPy.default_params as default_params
from pathlib import Path
import os


subject = "a2a_230"
date1 = "20241001"
date2 = "20241009"
#date2 = "20240929"
dates =[date1, date2]
base_path = r"Z:\RigData\training\npx\electrophysiology\sbolkan"
ks_dir1 = os.path.join(base_path, subject, date1, "catgt_TowersTask_g0", "kilosort4")
ks_dir2 = os.path.join(base_path, subject, date2, "catgt_TowersTask_g0", "kilosort4")

KS_dirs = [ks_dir1, ks_dir2]

output_dirs = [rf"Z:\RigData\training\npx\electrophysiology\sbolkan\{subject}\{date}\catgt_TowersTask_g0\kilosort4\bombcell"
           for date in dates]
for ks_dir in output_dirs:
    save_dir = Path(ks_dir) / "unitmatch"
    save_dir.mkdir(parents=True, exist_ok=True)
    print(f"Using unitmatch directory: {save_dir}")


param = default_params.get_default_param()
param['KS_dirs'] = KS_dirs

# STEP 0 -- data preparation
# Read in data and select the good units and exact metadata
waveform, session_id, session_switch, within_session, good_units, param = util.load_good_waveforms(wave_paths, unit_label_paths, param, good_units_only = True) 


# Create clus_info, contains all unit id/session related info
clus_info = {'good_units' : good_units, 'session_switch' : session_switch, 'session_id' : session_id, 
            'original_ids' : np.concatenate(good_units) }

good_units = util.get_good_units(unit_label_paths, good = True )  # good = False to load in ALL units
waveform, session_id, session_switch, within_session, param = util.load_good_units(good_units, wave_paths, param)

# STEP 1
# Extract parameters from waveform
extracted_wave_properties = ov.extract_parameters(waveform, channel_pos, clus_info, param)  #I get an error : ValueError: array must not contain infs or NaNs








# STEP 2, 3, 4
# Extract metric scores
total_score, candidate_pairs, scores_to_include, predictors  = ov.extract_metric_scores(extracted_wave_properties, session_switch, within_session, param, niter  = 2)
# STEP 5
# Probability analysis
# Get prior probability of being a match
prior_match = 1 - (param['n_expected_matches'] / param['n_units']**2 ) # freedom of choose in prior prob
priors = np.array((prior_match, 1-prior_match))
# Construct distributions (kernels) for Naive Bayes Classifier
labels = candidate_pairs.astype(int)
cond = np.unique(labels)
score_vector = param['score_vector']
parameter_kernels = np.full((len(score_vector), len(scores_to_include), len(cond)), np.nan)
parameter_kernels = bf.get_parameter_kernels(scores_to_include, labels, cond, param, add_one = 1)
# Get probability of each pair of being a match
probability = bf.apply_naive_bayes(parameter_kernels, priors, predictors, param, cond)
output_prob_matrix = probability[:,1].reshape(param['n_units'],param['n_units'])








