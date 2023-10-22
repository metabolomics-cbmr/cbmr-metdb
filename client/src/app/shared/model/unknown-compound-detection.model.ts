export interface UnknownCompoundDetectionAPIResult {
  output: Output[];
  settings: Settings;
  summary: Summary;
}

export interface Output {
  data: Data;
}

export interface Data {
  image: Image;
  query: Query;
  reference: Query;
  result: Result;
}

export interface Image {
  molecular_structure: string;
  mz_intensity: string;
}

export interface Query {
  collision_energy: number;
  name: string;
  precursor_mass: string;
  retention_time: string;
  scan_number: number;
}

export interface Result {
  match_method: string;
  num_matching_peaks: number;
  score: string;
}

export interface Settings {
  [key: string]: Matching;
}

export interface Matching {
  description: string;
  threshold: number;
}

export interface Summary {
  matches_over_threhold: number;
  precursor_mass_tolerance: string;
  total_ms2_rows_compared: number;
  unique_compounds_compared: number;
}
