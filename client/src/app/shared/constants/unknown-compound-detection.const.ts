import { UnknownCompoundDetectionAPIResult } from '../model/unknown-compound-detection.model';

export const DEFAULT_UNKNOWN_COMPOUND_DETECTION_RESULT: UnknownCompoundDetectionAPIResult =
  {
    output: [],
    settings: {},
    summary: {
      matches_over_threhold: 0,
      precursor_mass_tolerance: '',
      total_ms2_rows_compared: 0,
      unique_compounds_compared: 0,
    },
  };

export const UNKNOWN_COMPOUND_DETECTION_SUMMARY = {
  matches_over_threhold: 'Matches exceeding threshold',
  precursor_mass_tolerance:
    'Precursor Mass tolerance for selecting reference compounds',
  total_ms2_rows_compared: 'Total MS2 rows compared',
  unique_compounds_compared: 'Unique Compounds compared',
};

export const UNKNOWN_COMPOUND_REFERENCE_KEYS = {
  collision_energy: 'Collision Energy',
  name: 'Name',
  precursor_mass: 'Precursor Mass',
  retention_time: 'Retention Time (secs)',
  scan_number: 'Scan number',
};

export const UNKNOWN_COMPOUND_QUERY_KEYS = {
  collision_energy: 'Collision Energy',
  name: 'Name',
  precursor_mass: 'Precursor Mass',
  retention_time: 'Retention Time (secs)',
  scan_number: 'Scan number',
};

export const UNKNOWN_COMPOUND_DESCRIPTION_ORDER = [
  'collision_energy',
  'name',
  'precursor_mass',
  'retention_time',
  'scan_number',
];
