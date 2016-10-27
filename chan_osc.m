function [voltageSamples, instAmp, instPhase, instFreq, instNoise] = chan_osc(dataLengthSamples, sampleRate, oscCenter, varargin)

    %TODO: optional time output
    % open help if no arguments provided
    if nargin == 1
        help chan_fm;
        return
    end
    
    % check for minimum required inputs
    if (0 < nargin) && (nargin < 3)
        error('myfuns:somefun2:TooFewInputs', ...
            'Requires at least 3 inputs, 8 optional');
    end
    
    % make sure all keywords have matching values
    if (round(nargin/2) == nargin/2)
        error('Even number of input arguments??')
    end

    % default params
    oscAmp = 1;
    oscAmpGiven = 0;
  
    isFM = 0;
    oscModFreq = 1;
    oscFreqDev = 5;
    
    isAM = 0;
    oscAModFreq = 1;
    oscAmpDev = 1;
    
    isNoisy = 0;
    oscMean = 0;
    oscStdDev = 1/sqrt(2);
    snr = 1;
    noiseMean = 0;
    noiseStdDev = 0.5;
    samplingNoiseAmp = 0;
    phaseOffset = 0;

    % Set oscillation amplitude
    for i = 1:2:length(varargin)
        Param = varargin{i};
        Value = varargin{i+1};
        if ~ischar(Param)
            error('Flag arguments must be strings')
        end
        if strcmpi(Param,'oscAmp')
            oscAmpGiven = 1;
            oscAmp = Value;
        end
        if strcmpi(Param,'phaseOffset') % assumes value from 0 to 2pi
            phaseOffset = Value;
        end
    end
    
    % Does the user want AM signal?
    for i = 1:2:length(varargin)
        Param = varargin{i};
        Value = varargin{i+1};
        if ~ischar(Param)
            error('Flag arguments must be strings')
        end
        if strcmpi(Param,'isAM')
            isAM = Value;
        end
        if isAM
            for i = 1:2:length(varargin)
                Param = varargin{i};
                Value = varargin{i+1};
                if ~isstr(Param)
                    error('Flag arguments must be strings')
                end
                Param = lower(Param);
                switch Param
                    case 'oscAModFreq'
                        oscAModFreq = Value;
                    case 'oscAmpDev'
                        oscAmpDev = Value;
                end
            end
            break
        end
    end
    
    if oscAmp - oscAmpDev < 0
        warning('AM amplitude deviation exceeds identified oscillation amplitude, i.e. the oscillation amplitude becomes negative')
    end
    
    % Does the user want FM signal?
    for i = 1:2:length(varargin)
        Param = varargin{i};
        Value = varargin{i+1};
        if ~ischar(Param)
            error('Flag arguments must be strings')
        end
        if strcmpi(Param,'isFM')
            isFM = Value;
        end
        if isFM
            for i = 1:2:length(varargin)
                Param = varargin{i};
                Value = varargin{i+1};
                if ~isstr(Param)
                    error('Flag arguments must be strings')
                end
                Param = lower(Param);
                switch Param
                    case 'oscModFreq'
                        oscModFreq = Value;
                    case 'oscFreqDev'
                        oscFreqDev = Value;
                end
            end
            break
        end
    end
    
    if oscCenter-oscFreqDev < 0
        error('Maximum frequence deviation (oscFreqDev) cannot exceed center frequency (oscCenter)')
    end
    
    % Does the user want noisy signal?
    for i = 1:2:length(varargin)
        Param = varargin{i};
        Value = varargin{i+1};
        if ~ischar(Param)
            error('Flag arguments must be strings')
        end
        if strcmpi(Param,'isNoisy')
            isNoisy = Value;
        end
        if isNoisy
            for i = 1:2:length(varargin)
                Param = varargin{i};
                Value = varargin{i+1};
                if ~isstr(Param)
                    error('Flag arguments must be strings')
                end
                Param = lower(Param);
                switch Param
                    case 'oscMean'
                        oscMean = Value;
                    case 'snr'
                        snr = Value;
                    case 'noiseMean'
                        noiseMean = Value;
                    case 'noiseStdDev' 
                        noiseStdDev = Value;
                    case 'samplingNoiseAmp' 
                        samplingNoiseAmp = Value;
                end
            end
            break
        end
    end
    
    % Signal to noise parameters
    if isNoisy
        if oscAmpGiven
            warning('Provided oscillation amplitude overriden by given SNR and noise standard dev.')
        end
        oscStdDev = abs(sqrt(snr*(noiseStdDev^2)));
        oscAmp = sqrt(2)*oscStdDev;
    end
    
    % Constructs 1/f noise by taking CDF of normal dist.
    power = noiseStdDev^2;
    normalNoise = wgn(1,dataLengthSamples, power);
%     if randi([0,1],1)
        pinkNoise = noiseMean+cumsum(normalNoise);
%     else
%         pinkNoise = noiseMean-cumsum(normalNoise);
%     end
    
    % Constructs signal
    sampleSpacing = 1/sampleRate;
    dataLengthSecs = dataLengthSamples/sampleRate;
    t = 0:sampleSpacing:(dataLengthSecs-sampleSpacing);
    h = oscFreqDev/oscModFreq; % Modulation index, FYI < 1 narrowband, > 1 wideband
    instAmp = oscAmp + isAM*oscAmpDev*cos(2*pi*oscAModFreq*t)/oscAModFreq; % mod around center amp
    fc = oscCenter*2*pi*t;
    fm = isFM*h*cos(2*pi*oscModFreq*t);
    instNoise = isNoisy*(pinkNoise + samplingNoiseAmp * rand(1,dataLengthSamples));
    
    voltageSamples = oscMean + instAmp.*cos(fc-fm+phaseOffset) + instNoise;
    
    %Optional output of instaneous phase
    instFreq = sampleRate/(2*pi)*diff(fc-fm);
    instPhase = wrapTo2Pi(fc-fm);
end




















