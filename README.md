Title: Facial Behavioral Signals Network (Private)

Description:

This private repository contains code for processing and analyzing facial behavioral signals, potentially related to a research project on driver distraction detection using facial behavior analysis. The code provides functionalities for:

Feature extraction from FACS (Facial Action Coding System) signals (ExtractFeature_facs.m).
(Potentially) Feature extraction based on correlations (Extract_Cor_Feature.m, functionality inferred from filename).
Please Note: Due to the repository's private nature, access is restricted.

If you are a collaborator or have been granted access:

This README provides an overview of the available code:

ExtractFeature_facs.m:

This function likely extracts various features from FACS signals, considering functional and non-functional connectivity.
The specific features and their interpretations might be relevant to the research project.
Extract_Cor_Feature.m:

Based on the filename, this function might extract features related to correlations within the signals.
The specific correlation-based features and their usage require further examination of the code.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
**Title:** Extract Features from Facial Action Coding System (FACS) Signals

**Description:**

This repository provides the `ExtractFeature_facs` function, designed to extract features from FACS signals based on functional and non-functional connectivity. It caters to researchers investigating driver distraction detection through facial behavior analysis.

**Features:**

- Extracts various features, including correlation coefficients, covariance, Dynamic Time Warping (DTW) distance, cross-correlation, and effective connectivity.
- Supports segmentation of signals based on user-defined time windows.
- Handles missing data by setting invalid segments to all ones.

**Installation:**

1. Clone this repository:

   ```bash
   git clone https://github.com/mohammadianamin/Facial-Behavioral-Signals-Network/blob/main/ExtractFeature_facs.m
   ```

**Usage:**

1. Import the `ExtractFeature_facs` function into your MATLAB script:

   ```matlab
   addpath('path/to/ExtractFeature_facs') % Replace with the actual path
   Contact_features = ExtractFeature_facs(params, signal, Timestamp_s, Timestamp_s_FACS, ModalitySignal, Stimulus_sel);
   ```

2. **Required Input Arguments:**

   - `params`: A structure containing parameters for feature extraction:
     - `StartPhaseTag`: Starting time point for feature window (seconds).
     - `EndPhaseTag`: Ending time point for feature window (seconds).
     - `step`: Time step for sliding window (seconds).
     - `window_size`: Size of the time window for feature extraction (samples).
     - `SamplingRatefacs`: Sampling rate of the FACS signal (Hz).
   - `signal`: The FACS signal matrix (time x channels).
   - `Timestamp_s`: Timestamps for the FACS signal (seconds).
   - `Timestamp_s_FACS`: Timestamps for the FACS signal aligned with the start of each time window (seconds).
   - `ModalitySignal`: (Optional) An additional modality signal (e.g., EEG) for potential feature extraction (matrix, same dimensions as `signal`).
   - `Stimulus_sel`: A vector indicating stimulus type for each time window.

3. **Output:**

   - `Contact_features`: A structure containing extracted features:
     - `StarttimePhase`: Starting time point used for feature extraction.
     - `EndtimePhase`: Ending time point used for feature extraction.
     - `Window`: Size of the time window used for feature extraction (samples).
     - `SamplingRate`: Sampling rate of the FACS signal (Hz).
     - `valid`: A vector indicating validity of each extracted feature window (1 for valid, 0 for invalid).
     - `W(k).FACS`: A matrix where each row represents features extracted from a valid time window (k indexes windows). Features include:
       - Correlation coefficients (excluding redundant values).
       - Covariance (excluding redundant values).
       - DTW distances between each signal channel pair.
       - Maximum, minimum, and mean values from cross-correlation between each signal channel pair.
       - Mean of the entire signal segment.
       - Effective connectivity measures (if `effect_connect_moh.m` is available).

**Example Usage:**

```matlab
% Sample parameters (modify as needed)
params.StartPhaseTag = 1;
params.EndPhaseTag = 5;
params.step = 1;
params.window_size = 100;
params.SamplingRatefacs = 128;

% Sample FACS signal, timestamps, and stimulus labels (replace with your data)
signal = ...;
Timestamp_s = ...;
Timestamp_s_FACS = ...;
Stimulus_sel = ...;

% (Optional) Additional modality signal (if used)
ModalitySignal = ...;

% Extract features
Contact_features = ExtractFeature_facs(params, signal, Timestamp_s, Timestamp_s_FACS, ModalitySignal, Stimulus_sel);

% Access extracted features
valid_windows = Contact_features.valid;
features_window1 = Contact_features.W(1).FACS;
% ... (access features from other windows as needed)
```

Title: Extract Correlation-Based Features from Signals

Description:

This repository provides the Extract_Cor_Feature function, designed to extract features from signals based on correlations and covariance. It caters to researchers analyzing functional and non-functional connectivity in various domains (e.g., neuroscience, driver distraction detection).

Features:

Extracts upper triangular correlation coefficients (excluding redundant values) for a specified set of channels.
Computes the Singular Value Decomposition (SVD) of the covariance matrix.
Segments signals into windows for time-resolved analysis.
Handles missing data by replacing invalid segments with all ones.
Installation:

Clone this repository:

Bash
git clone https://github.com/mohammadianamin/Facial-Behavioral-Signals-Network/blob/main/Extract_Cor_Feature.m
Use code with caution.
content_copy
Usage:

Import the Extract_Cor_Feature function into your MATLAB script:

Matlab
addpath('path/to/Extract_Cor_Feature') % Replace with the actual path
Contact_features = Extract_Cor_Feature(params, signal, Timestamp_s);
Use code with caution.
content_copy
Required Input Arguments:

params: A structure containing parameters for feature extraction:
StartPhaseTag: Starting time point for feature window (seconds).
EndPhaseTag: Ending time point for feature window (seconds).
step: Time step for sliding window (seconds).
window_size: Size of the time window for feature extraction (samples).
SamplingRate: Sampling rate of the signal (Hz).
signal: The signal matrix (time x channels).
Timestamp_s: Timestamps for the signal (seconds).
Output:

Contact_features: A structure containing extracted features:
StarttimePhase: Starting time point used for feature extraction.
EndtimePhase: Ending time point used for feature extraction.
Window: Size of the time window used for feature extraction (samples).
SamplingRate: Sampling rate of the signal (Hz).
valid: A vector indicating validity of each extracted feature window (1 for valid, 0 for invalid).
W(k).allcor: A matrix where each row represents features extracted from a valid time window (k indexes windows). Features include:
Upper triangular correlation coefficients for a predefined set of channels (configurable).
Singular values from the SVD of the covariance matrix.
Example Usage:

Matlab
% Sample parameters (modify as needed)
params.StartPhaseTag = 1;
params.EndPhaseTag = 5;
params.step = 1;
params.window_size = 100;
params.SamplingRate = 250;

% Sample signal and timestamps (replace with your data)
signal = ...;
Timestamp_s = ...;

% Extract features
Contact_features = Extract_Cor_Feature(params, signal, Timestamp_s);

% Access extracted features
valid_windows = Contact_features.valid;
features_window1 = Contact_features.W(1).allcor;
% ... (access features from other windows as needed)


**Dependencies:**

- MATLAB

**Authors:**

- Amin Mohammadian (a.mohammadian@aut.ac.ir)
